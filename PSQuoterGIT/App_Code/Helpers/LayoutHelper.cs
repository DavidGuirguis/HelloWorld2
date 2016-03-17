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


namespace Helpers {
    public static partial class LayoutHelper {
        private static readonly ResourceManager Resource = new ResourceManager(typeof(LayoutHelper));

        public static string GetThemeName() {
            return AppContext.Current.BusinessEntity.Theme.AsNullIfWhiteSpace(trim: true) ?? "Cat";
        }

        public static string FormatTitle(string pageTitle, string moduleTitle) {
            return pageTitle + " :: " + moduleTitle;
        }

        private static object GetView(IPage page) {
            // Mvc TODO:make set reference to Master for Mvc
            return page.IsWebViewPage ? (object)page : page.Master;
        }

        public static void RenderSection(IPage page, LayoutSection section, bool sectionDefined, TextWriter writer) {
            var appContext = AppContext.Current;
            var webContext = global::WebContext.Current;

            // Default section renderer
            switch (section) {
                case LayoutSection.HtmlHead:
                    HtmlHeadSection(appContext: appContext, webContext: webContext, page: page, sectionDefined: sectionDefined, writer: writer);
                    break;
                case LayoutSection.ApplicationHeader:
                    ApplicationHeaderSection(appContext: appContext, webContext: webContext, page: page, sectionDefined: sectionDefined, writer: writer);
                    break;
                case LayoutSection.TopPane:
                    TopPaneSection(appContext: appContext, webContext: webContext, page: page, sectionDefined: sectionDefined, writer: writer);
                    break;
                case LayoutSection.SearchPane:
                    SearchPaneSection(appContext: appContext, webContext: webContext, page: page, sectionDefined: sectionDefined, writer: writer);
                    break;
                case LayoutSection.DetailPane:
                    DetailPaneSection(appContext: appContext, webContext: webContext, page: page, sectionDefined: sectionDefined, writer: writer);
                    break;
                case LayoutSection.LeftPane:
                    LeftPaneSection(appContext: appContext, webContext: webContext, page: page, sectionDefined: sectionDefined, writer: writer);
                    break;
                case LayoutSection.RightPane:
                    RightPaneSection(appContext: appContext, webContext: webContext, page: page, sectionDefined: sectionDefined, writer: writer);
                    break;
                case LayoutSection.BottomPane:
                    BottomPaneSection(appContext: appContext, webContext: webContext, page: page, sectionDefined: sectionDefined, writer: writer);
                    break;
                default:
                    throw new NotImplementedException();
            }
        }
    }
}

