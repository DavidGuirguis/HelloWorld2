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
        private static void ApplicationHeaderSection(AppContext appContext, global::WebContext webContext, IPage page, bool sectionDefined, TextWriter writer) {
            var isViewForChangersAndDevInfo = !(page is Popup);
            var clientRes = new StringBuilder();

            writer.Write("<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">");
            writer.Write("<tr>");
            // Application Name
            writer.Write("<td style=\"padding-left:5px;\"><span class=\"appTitle\">{0}</span>", webContext.Application.ApplicationName.HtmlEncode());

            var showBusinessEntitySelector = appContext.AppSettings.IsTrue("psQuoter.BusinessEntity.ApplicationHeaderTitle.Show");
            var showDivisionSelector = appContext.User.IsAuthenticated;
            
            if (isViewForChangersAndDevInfo
                && (showBusinessEntitySelector || showDivisionSelector)) {
                writer.Write("<span class=\"globalFilters\">");

                // Business Entity
                if (showBusinessEntitySelector) {
                    writer.Write("<span id=\"bizEntity\">");
                    if (appContext.User.IsAuthenticated && appContext.BusinessEntities.Count > 1) {
                        appContext.BusinessEntities.Values
                            .Select(item => new ListItem(item.BusinessEntityName, item.BusinessEntityId.ToString()){Selected = item.BusinessEntityId == appContext.BusinessEntityId})
                            .DropDownList("BizEntId", cssClass: "f", attributes: new { onchange = "changeGlobalBizEnt(this);" }, writer: writer);
                            
                        // scripts
                        clientRes.AppendFormat(@"<script type=""text/javascript"">
function changeGlobalBizEnt(element){{
    fGlobalBizEnt.businessEntityId.value = element.value;
    fGlobalBizEnt.submit();
}}
</script><form id=""fGlobalBizEnt"" name=""fGlobalBizEnt"" method=""post"" action=""{0}""><input type=""hidden"" name=""businessEntityId"" /></form>"
                            , /*0*/page.GetRouteUrl(AreaRoutes.Util, new {controller = "Context", action = "ChangeBusinessEntity"})
                        );
                    } 
                    else {
                        writer.Write(appContext.BusinessEntity.BusinessEntityName.HtmlEncode());
                    }
                    writer.Write("</span>");
                }

                writer.Write("</span>");
            }
            writer.Write("</td>");

            writer.Write("<td align=\"right\">");
            // Dev info
            if (isViewForChangersAndDevInfo && (X.Configuration.EnvironmentSettings.Current.IsDevelopment || webContext.User.IsDebugger)) {
                writer.Write("<span style=\"padding-right:5px;\" class=\"devInfo\">");
                writer.Write("Dev Info <img src=\"{4}library/images/rarrow_left.gif\" onclick=\"toggleDevInfo(this);\" style=\"cursor:pointer;\" /><span style=\"display:none;\"><b>DB:</b> {0} / {1}&nbsp;&nbsp;{3}<b>URL:</b> {2}&nbsp;&nbsp;<b>Elpsd:</b> <span id=\"spnElpsd\"></span></span>"
                    /*0*/, X.Data.Connections.Current.ApplicationDb.DataSource
                    /*1*/, X.Data.Connections.Current.ApplicationDb.Catalog

                    /*2*/, webContext.Request.ScriptName
                    /*3*/, (page == null || page.MasterPageFile == null ? null : String.Format("<b>Master:</b> {0}&nbsp;&nbsp;", Regex.Replace(page.MasterPageFile.Substring(page.MasterPageFile.LastIndexOf('/') + 1), "\\.master", "", RegexOptions.IgnoreCase)))
                    /*4*/, page.RelativeApplicationPath
                    );
                clientRes.Append(@"<script language=""javascript"" type=""text/javascript"">
function toggleDevInfo(element){
    var jElement = $j(element);
    var expr = /(^.*\/)[^/]+.gif/gi;

    if(element.src.indexOf('rarrow_left.gif') == -1){
        jElement.next().hide('slow');
        element.src = element.src.replace(expr, '$1rarrow_left.gif');
    }
    else {
        jElement.next().show('slow');
        element.src = element.src.replace(expr, '$1rarrow.gif');
    }
}
</script>");
                writer.Write("</span>");
            }//- Dev Info

            //// Lang selector
            //if (isViewForChangersAndDevInfo) GlobalizationContext.Current.Languages.RenderSelector(new { @class = "f", style = "margin-left:20px;margin-right:20px;" });

            // Display Name
            var displayName = webContext.User.IdentityEx.IsAuthenticated ? AppContext.Current.User.DisplayName : (string)null;
            writer.Write("<span class=\"userDisplayName\">{0}</span>", displayName);
            writer.Write("</td>");
            writer.Write("</tr>");
            writer.Write("</table>");

            // Client Resources/Forms
            writer.Write(clientRes.ToString());
        }
    }
}

