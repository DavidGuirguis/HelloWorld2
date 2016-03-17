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
        private static void DetailPaneSection(AppContext appContext, global::WebContext webContext, IPage page, bool sectionDefined, TextWriter writer) {
            object view = GetView(page);

            var specificDetailedInfoShown = false;

            writer.Write("<div style=\"padding-left:10px;padding-right:5px;\">");
            // Module Title
            writer.Write("<div class=\"t14 tSb tAr\" id=\"moduleTitleContainer\">{0}</div>", page.ModuleTitle.HtmlEncode());
            // View specific detailed info
            writer.Write("<div id=\"detailedInfoContainer\">");
            if (view is IAccountView) {
                specificDetailedInfoShown = true;
                
            } 
            else if(view is IRepView) {
                specificDetailedInfoShown = true;

            }
            else {
                writer.Write("<span style=\"visibility:hidden;\">.</span>");
            }
            writer.Write("</div>");
            writer.Write("</div>");

            if (specificDetailedInfoShown) {
                writer.Write("<style type=\"text/css\">#moduleTitleContainer {float:right;}</style>");
            } 
            else {
                writer.Write("<style type=\"text/css\">#detailedInfoContainer{display:none;}</style>");
            }
        }
    }
}

