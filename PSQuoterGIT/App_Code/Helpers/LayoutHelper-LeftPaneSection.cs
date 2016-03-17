using AppContext = Canam.AppContext;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Web;
using System.Web.UI.WebControls;
using Entities;
using Entities.AppState;
using Entities.AppState.Extensions;
using Enums;
using Repositories;
using UI.Abstracts.MasterPages;
using X;
using X.Extensions;
using X.Web;
using X.Web.Extensions;
using X.Web.Globalization;
using X.Web.UI;
using Popup = UI.Abstracts.Pages.Popup;
using Areas;
using Enums;

namespace Helpers {
    public static partial class LayoutHelper {
        private static void LeftPaneSection(AppContext appContext, global::WebContext webContext, IPage page, bool sectionDefined, TextWriter writer) {
            object view = GetView(X.Web.WebContext.Current.Page);
        }
    }
}

