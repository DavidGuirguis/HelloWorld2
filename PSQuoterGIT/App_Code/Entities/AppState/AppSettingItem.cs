using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections.Specialized;
using Enums;

namespace Entities.AppState {
    /// <summary>
    /// Summary description for AppSettingItem
    /// </summary>
    public class AppSettingItem {
        public string Key { get; set; }
        public string Value { get; set; }
        public int SystemIdFlags {get; set;}
        public DivisionTypeEnum DivisionType { get; set; }
    }
}