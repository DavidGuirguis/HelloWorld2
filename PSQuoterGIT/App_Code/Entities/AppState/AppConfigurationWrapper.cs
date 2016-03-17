using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections.Specialized;

namespace Entities.AppState {
    /// <summary>
    /// Summary description for AppConfigurationWrapper
    /// </summary>
    public class AppConfigurationWrapper {

        #region Properties
        public List<AppSettingItem> AppSettings { get; set; }
        #endregion
    }
}