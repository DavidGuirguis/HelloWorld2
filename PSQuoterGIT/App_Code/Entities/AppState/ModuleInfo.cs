using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Enums;

namespace Entities.AppState {
    /// <summary>
    /// Summary description for ModuleInfo
    /// </summary>
    public class ModuleInfo {
        public ModuleInfo() {
            var appSettingItems = new List<AppSettingItem> {
                new AppSettingItem {
                    SystemIdFlags = 1,
                    DivisionType = DivisionTypeEnum.All,
                    Key = "SerialNumber.Mandatory",
                    Value = "2"
                },
                new AppSettingItem {
                    SystemIdFlags = 1,
                    DivisionType = DivisionTypeEnum.All,
                    Key = "DataStore.Local",
                    Value = "1"
                }
            };

            //TODO: get from SQL
            switch (WebContext.Current.Request.ScriptName.ToLower()) {
                case "modules/account/profile/customer_rentalprofile.aspx":
                    this.ModuleId = 66;
                    break;
                case "modules/account/equipment/customer_equipment.aspx":
                case "modules/account/equipment/customer_equipment_edit.aspx":
                case "modules/account/equipment/customer_equipment_transfer.aspx":
                    this.ModuleId = 68;
                    appSettingItems.AddRange(new[] {new AppSettingItem {
                        SystemIdFlags = 1,
                        DivisionType = DivisionTypeEnum.All,
                        Key = "EquipmentList.AddEditDeleteButtons.Show",
                        Value = "2"
                    },
                    new AppSettingItem {
                        SystemIdFlags = 1,
                        DivisionType = DivisionTypeEnum.All,
                        Key = "CustomerAttachment.SortOrderBy",
                        Value = "EquipManufDesc"
                    },
                    new AppSettingItem {
                        SystemIdFlags = 1,
                        DivisionType = DivisionTypeEnum.All,
                        Key = "CustomerEquipment.SortOrderBy",
                        Value = "EquipManufDesc"
                    }});
                    break;
                case "modules/account/request/customer_submitrequest_2sql.aspx":
                    this.ModuleId = 78;
                    appSettingItems.AddRange(new[] {new AppSettingItem {
                        SystemIdFlags = 1,
                        DivisionType = DivisionTypeEnum.All,
                        Key = "Address.DataStore.Local.Fields",
                        Value = "CountyCode@CountyCode|FaxNumber@FaxNo"
                    },
                    new AppSettingItem {
                        SystemIdFlags = 1,
                        DivisionType = DivisionTypeEnum.All,
                        Key = "ExtraDetails.DataStore.Local",
                        Value = "2"
                    }});
                    break;
            }
            Settings = new ApplicationSettings(appSettingItems);
        }

        public int ModuleId { get; private set; }

        public bool HasAccess(bool showMessage = false) {
            return true;//TODO:add logic back from HasAccess from inc_local_customer.asp
        }

        public ApplicationSettings Settings { get; private set; }
    } 
}