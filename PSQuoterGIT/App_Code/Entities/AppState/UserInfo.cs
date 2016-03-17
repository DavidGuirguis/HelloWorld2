using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security;
using System.Web;
using Enums;
using Repositories;
using X;
using X.Data;
using X.Extensions;
using X.Web.Extensions;
using X.Web;

namespace Entities.AppState {
    public class UserInfo {
        private static readonly ResourceManager Resource = new ResourceManager(typeof(UserInfo));

        public UserInfo(bool isAuthenticated) {
            this.IsAuthenticated = isAuthenticated;

            this.LogonUser = global::WebContext.Current.User.IdentityEx.Copy<IdentityInfo>();
            this.Viewer = this.LogonUser.Copy();
        }

        public void Initialize(DataSet appData, bool isImpersonating) {
            var operationInfoDataRow = appData.Tables.OfType<DataTable>()
                .Where(table => table.Rows.Count > 0 
                    && table.Columns.Contains("RS_Type") 
                    && table.Rows[0]["RS_Type"].AsString() == "User.Access")
                .SelectMany(table => table.AsEnumerable())
                .FirstOrDefault();

            if(operationInfoDataRow == null)
                throw new Exception("The current user's security access info was not found.");

            RoleBasedAuthEnabled = BitMaskBoolean.IsTrue(operationInfoDataRow["RoleBasedACInd"]);

            Operation = new OperationInfo {
                CreateQuote = operationInfoDataRow["CreateQuotes"].AsInt() == 1,
                WOReports = operationInfoDataRow["WOReports"].AsInt() == 1,
                DeleteQuote = operationInfoDataRow["DeleteQuotes"].AsInt() == 1,
                Admin = operationInfoDataRow["Admin"].AsInt() == 1,
                RepairOption = operationInfoDataRow["RepairOptions"].AsInt() == 1,
                WODetails = operationInfoDataRow["WODetails"].AsInt() == 1,
                TRG = operationInfoDataRow["TRG"].AsInt() == 1,
                QuoteSearchReps = operationInfoDataRow["Quote.SearchReps"].AsInt() == 1,
                CreateWO = operationInfoDataRow["CreateWO"].AsInt() == 1,
                RoleId = operationInfoDataRow["RoleId"].AsInt(),   //<CODE_TAG_103481>
            };

      


            // Display name)
            this.DisplayName = this.IsImpersonating
                ? String.Format(Resource.GetString("rk_DisplayName"), /*0*/this.LogonUser.FullName, /*1*/this.Viewer.FullName)
                : this.LogonUser.FullName
            ;
        }

        public void InitializeRequest() {
        }

        public IdentityInfo Viewer { get; private set; }
        /// <summary>
        /// User who actually log on to the application.
        /// </summary>
        public IdentityInfo LogonUser { get; private set; }
        public bool IsImpersonating { get; private set; }
        public bool CanImpersonate { get { return LogonUser.CanImpersonate; } }
        public string DisplayName { get; private set; }
        public bool RoleBasedAuthEnabled { get; private set; }
        public bool IsAuthenticated { get; private set; }

        public OperationInfo Operation { get; private set; }
    }
}