using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using ADODB;
using X.Data;
using X.Extensions;

namespace Helpers {
    /// <summary>
    /// Summary description for LegacyExtensions
    /// </summary>
    public static class LegacyHelper {
        public static ADODB.Recordset NextRecordset(this ADODB.Recordset recordset) {
            object recordsAffected;
            return recordset.NextRecordset(out recordsAffected);
        }

        public static ADODB.Recordset Execute(this ADODB.Command command) {
            object recordsAffected;

            if (command == null) return null;
            command.CommandTimeout = 60; //<CODE_TAG_101957>
            var parameters = command.Parameters.OfType<Parameter>();
            if (parameters
                .Any(p => p.Direction == ParameterDirectionEnum.adParamReturnValue
                    || p.Direction == ParameterDirectionEnum.adParamInputOutput
                    || p.Direction == ParameterDirectionEnum.adParamOutput
                ))
                command.ActiveConnection.CursorLocation = CursorLocationEnum.adUseClient;

            // Forbid using default value
            parameters
                .Where(p => p.Value == null)
                .ForEach(p => p.Value = DBNull.Value);

            // Ensure CommandType is StoredProcedure
            command.CommandType = CommandTypeEnum.adCmdStoredProc;

            // Ensure parameter assignments
            Match match = null;
            if (global::WebContext.Current.User.IsDebugger 
                && (match = Regex.Match(command.CommandText, "(?i)(call\\s+){0,1}([\\w.]+)")).Success
            ) {
                var spName = match.Groups[2].Value;
                var paramDefs = SqlHelperParameterCache.GetSpParameterSet(spName);
                var paramsExclRet = parameters.Where(p => p.Direction != ParameterDirectionEnum.adParamReturnValue);
                var paramIndex = 0;

                if (paramDefs.Length != paramsExclRet.Count()
                    || paramsExclRet.Any(p => 0 != String.Compare(paramDefs[paramIndex++].ParameterName.Trim(), p.Name.Trim().StartsWith("@") ? p.Name.Trim() : "@" + p.Name.Trim(), StringComparison.InvariantCultureIgnoreCase)) 
                ) {
                    throw new InvalidOperationException(String.Format("{0}: The assigned parameters mismatch with the one in SQL Server.\r\nAssigned parameters: {1}\r\nSQL Server parameters:{2}"
                        ,/*0*/ spName
                        ,/*1*/ String.Join(", ", paramsExclRet.Select(p => p.Name.StartsWith("@") ? p.Name : "@" + p.Name).ToArray())
                        ,/*2*/ String.Join(", ", paramDefs.OfType<SqlParameter>().Select(p => p.ParameterName).ToArray()) 
                    ));   
                }
            }
            return command.Execute(out recordsAffected);
        }

        public static ADODB.ConnectionClass OpenDataConnection() {
            var connection = new ADODB.ConnectionClass();
            connection.Open("Provider=SQLNCLI10;DataTypeCompatibility=80;" + X.Data.Connections.Current.ApplicationDb.ConnectionString);

            return connection;
        }

        public static ADODB.Parameters Clear(this ADODB.Parameters parameters) {
            if (parameters == null) return null;

            var count = parameters.Count;
            for (var i = 0; i < count; i++)
                parameters.Delete(0);

            return parameters;
        }

        public static bool ContainsColumn(this ADODB.Recordset recordSet, string columnName) {
            if (String.IsNullOrWhiteSpace(columnName)) return false;

            if (recordSet == null || recordSet.BOF || recordSet.EOF) return false;

            foreach (ADODB.Field field in recordSet.Fields) {
                if (0 == String.Compare(field.Name, columnName, StringComparison.InvariantCultureIgnoreCase)) 
                    return true;
            }

            return false;
        }
    }
}
