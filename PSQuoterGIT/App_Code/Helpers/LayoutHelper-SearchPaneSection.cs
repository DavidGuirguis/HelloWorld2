using AppContext = Canam.AppContext;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using Helpers;
using Entities.AppState.Extensions;
using Enums;
using X.Extensions;
using X.Web.Extensions;
using X.Web.UI;

namespace Helpers {
    public static partial class LayoutHelper {
        private static void SearchPaneSection(AppContext appContext, global::WebContext webContext, IPage page, bool sectionDefined, TextWriter writer) {
            var Request = page.Context.Request;
            int? intKeywordType = null; /*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
            int? intOperatorType = null; /*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
            string strSearchCustomerScope = null; /*DONE:review - check if it's using correct type*/
            string strKeyword = null; /*DONE:review - check if it's using correct type*/
            string strSearchDivisionView = null; /*DONE:review - check if it's using correct type*/
            bool blnSeparateCityState = false;
            string strSearchType = null; /*DONE:review - check if it's using correct type*/

            intKeywordType = Request.QueryString["KeywordType"].AsInt(appContext.AppSettings["psQuoter.SearchBar.LookFor.Default"].AsInt());
            intOperatorType = Request.QueryString["OperatorType"].AsInt(3);
            strSearchCustomerScope = Request.QueryString["SearchCustomerScope"];
            strKeyword = Request.QueryString["keyword"];
            strSearchDivisionView = Request.QueryString["SearchDivisionView"];
            strSearchType = Request.QueryString["SearchDivision"];   //SearchType

            writer.Write("<table cellspacing=0 cellpadding=0 border=0>");
            writer.Write("<tr class=\"t12 tSb\">");
            writer.Write("<td nowrap>" + Resource.GetString("rkSearchPaneFrmLabel_Look_for") + "&nbsp;</td>");

            //Populating KeywordType DropDown
           writer.Write("<td><select name=\"searchKeywordType\"  id=\"searchKeywordType\" class=\"f\" >");
           writer.Write(SearchPaneHelper.SearchKeywordTypeItems(intKeywordType));
           writer.Write("</select></td>");

            writer.Write("<td nowrap>&nbsp;" + Resource.GetString("rkSearchPaneDropDownLabel_that") + "&nbsp;</td>");

            //Populating operatorType DropDown
            writer.Write("<td><select name=\"searchOperatorType\" id=\"searchOperatorType\"  class=\"f\">");
            writer.Write(SearchPaneHelper.SearchOperatorTypeItems(intOperatorType));
            writer.Write("</select></td>");

            writer.Write("<td><input class=\"f w75\" type=\"text\" name=\"searchKeyword\" id=\"searchKeyword\" value=\"" + strKeyword + "\" maxlength=30></td>");
            writer.Write("<td nowrap>&nbsp;&nbsp;" + Resource.GetString("rkSearchPaneFrmLabel_View") + "&nbsp;</td>");

            writer.Write("<td nowrap>&nbsp;" + Resource.GetString("rkSearchPaneDropDownLabel_that") + "&nbsp;</td>");

            //Populating searchType DropDown
            writer.Write("<td><select name=\"searchTypes\" id=\"searchTypes\"  class=\"f\">");
            writer.Write(SearchPaneHelper.SearchTypeItems(strSearchType));
            writer.Write("</select></td>");

            writer.Write("<td><button type=\"submit\" name=\"btnSearch\" onclick=\"doSearch(); return false;\" style=\"margin-left:5px;\" class=\"f btn\">" + Resource.GetString("rkSearchPaneBtnText_Search") + "</button></td>");
            writer.Write("<td>");
            if (appContext.AppSettings.IsTrue("psQuoter.SearchBar.ShowAdvancedSearch"))
                writer.Write("<button type=\"button\" name = \"btnAdvancedSearch\" onclick=\"doAdvancedSearch();\" style=\"margin-left:5px;\" class=\"f btn\">Advanced Search</button>");
            
            writer.Write("</td>");
            writer.Write("<td>");
            //writer.Write("<button type=\"button\" name = \"btnPrint\" onclick=\"printCurrentPage();\" style=\"margin-left:5px;\" class=\"f btn\">" + Resource.GetString("rkSearchPaneBtnText_Print_Current_Page") + "</button>");
             //<CODE_TAG_104981>
            if (AppContext.Current.AppSettings.IsTrue("psquoter.QuoteList.ShowPrintCurrentPage"))
            {
                writer.Write("<button type=\"button\" name = \"btnPrint\" onclick=\"printCurrentPage();\" style=\"margin-left:5px;\" class=\"f btn\">" + Resource.GetString("rkSearchPaneBtnText_Print_Current_Page") + "</button>");
            }
            //</CODE_TAG_104981>
            writer.Write("</td>");
            writer.Write("</tr>");
            writer.Write("</table>");

            writer.Write(@"	<script language=""javascript"" type=""text/javascript"">
                                $(""#searchKeyword"").keypress(function (e) {{if(e.which === 13) {{e.preventDefault(); doSearch(); }}       }});
                                function doSearch(){{
                                var elOperatorType = document.getElementById(""searchOperatorType"");
                                var elKeyword = document.getElementById(""searchKeyword"");
                                
                    		    if(elOperatorType.value != 0){{
			                    if(Trim(elKeyword.value).length < 3)
                                {{
                				    alert(""{0}"".format(""3""));
				                    elKeyword.focus();
				                    return false;				
			                    }}				
		                    }}
                                
                                var keywordType = document.getElementById(""searchKeywordType"") == null ? """" : document.getElementById(""searchKeywordType"").value;
                                var keyword = elKeyword == null ? """" : elKeyword.value;
                                var operatorType = elOperatorType == null ? """" : elOperatorType.value;
                                var customerScope = document.getElementById(""searchCustomerScope"") == null ? """" : document.getElementById(""searchCustomerScope"").value;
                                var divType = document.getElementById(""searchTypes"") == null ? """" : document.getElementById(""searchTypes"").value;

                                document.location.href = ""{1}"" + ""KeywordType="" + encodeURIComponent(keywordType) + ""&keyword="" + encodeURIComponent(keyword) + ""&operatorType="" + encodeURIComponent(operatorType) + ""&searchDivision="" + encodeURIComponent(divType);
    
                                return true;
	
                               }}
                        
                               function doAdvancedSearch(){{
                                  document.location.href = ""{3}"";
                               }}

                               function printCurrentPage(){{
                                   var   popup = window.open('{2}' , 'print', 'left=0, top=0, width=800, height=600, menubar=yes, statusbar=yes, toolbar=yes, addressbar=yes, scrollbars=yes, resizable=yes');
                                   popup.focus();
                               }}
                                </script>",
                                /*0*/Resource.GetString("rkSearchPaneMsg_Please_enter_the_keyword_at_least_characters_long").JavaScriptStringEncode(),
                                /*1*/page.CreateUrl("Modules/search/default.aspx", normalizeForAppending: true),
                                /*2*/page.StripKeysFromCurrentPage("tt", normalizeForAppending: true) + "TT=print",
                                /*3*/page.CreateUrl("Modules/search/advancedsearch.aspx", normalizeForAppending: true)
                                );
        }

    }
}

