using AppContext = Canam.AppContext;
using System;
using System.Linq;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Collections.Specialized;
using Entities.AppState;
using X.Configuration;
using X.Data;
using X;
using X.Extensions;
using X.Web.Security;
using Enums;

namespace Repositories
{
    public class AppStateRepository {
        #region Member fields
        private AppContext _appContext;
        #endregion

        #region ctor
        public AppStateRepository(AppContext appContext) {
            _appContext = appContext;
        }
        #endregion
         
        public AppConfigurationWrapper GetAppConfiguration()
        {
            //TODO: work on app data retrieving logic
            var data = SqlHelper.ExecuteDataset(
                "AppDb_PSQuoter.dbo.App_Configuration_Get"
                , _appContext.User.Viewer.UserID
                , _appContext.ApplicationId
                );
            var wrapper = new AppConfigurationWrapper();
            wrapper.AppSettings = new List<AppSettingItem>();

            foreach (DataTable dataTable in data.Tables) {
                if (dataTable.Rows.Count > 0 && dataTable.Columns.Contains("RS_Type")) {
                    switch (dataTable.Rows[0].Field<string>("RS_Type")) {
                        #region App.Settings
                        case "App.Settings":
                            var rows = dataTable.AsEnumerable();

                            wrapper.AppSettings = (
                                from row in rows
                                select new AppSettingItem {
                                    Key = row.Field<string>("ConfigKey"),
                                    Value = row.Field<string>("ConfigValue")//,
                                    //SystemIdFlags = Convert.ToInt32(row["LocSystemId"]),
                                    //DivisionType = row["DivisionType"].As<DivisionTypeEnum>()
                                }
                            ).ToList();
                            break;
                        #endregion
                    }
                }
            }

            return wrapper;
        }

        public DataSet GetSessionStartUpData() {
            return GetSessionStartUpData(_appContext.User.Viewer.UserID, false);
        }

        public DataSet GetSessionStartUpData(int? userID, bool isImpersonating) {
            return SqlHelper.ExecuteDataset(
                "dbo.App_X_UserLoginCheck"
                , _appContext.ApplicationId
                , userID
                , null // @AppName
                , X.Url.AbsoluteApplicationPath
                , isImpersonating ? "<params impersonating=\"2\" />" : null // @ExtraParams
                , _appContext.BusinessEntityId
                , (int) EnvironmentSettings.Current.ApplicationType
            );
        }

        public int? GetDefaultRegionId() {
            var reader = SqlHelper.ExecuteReader(
                "dbo.SalesLink_Global_Region_Get"
                , _appContext.User.Viewer.UserID
                , _appContext.DivisionCode
                );

            if (reader == null || !reader.Read()) return null;

            var regionId = reader["RegionId"].As<int?>();

            reader.Close();

            return regionId;
        }
    }
}

