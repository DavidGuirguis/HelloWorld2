using AppContext = Canam.AppContext;
using System;
using System.Activities.Statements;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Data.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using Enums;
using X;
using X.Data;
using X.Extensions;
using X.Web;
using X.Web.Extensions;

namespace Helpers {
    /// <summary>
    /// Summary description for HtmlHelper
    /// </summary>
    public static class HtmlHelper {
        private static readonly ResourceManager Resource = new ResourceManager(typeof(HtmlHelper));
        
        public static IHtmlString Pager(int startRecordNumber, int totalRecords, string urlStripKeys = null, FormMethod method = FormMethod.Get, string startRecordFieldID = null, string customFunction = null) {
            string lnkNext = "";
            string lnkPrev = "";
            string pagesLink = "";
            int totalPages = 0;
            int currentPageNumber = 0;
            int pageLastRecordNumber = 0;
            int I = 0;
            int startPageNumber = 0;
            int endPageNumber = 0;
            int startRecordId;
            string html = "";
            string urlBase = "";
            string urlPagerSizeHandler = "";
            string psTotalRecords = null;
            string ps10 = null;
            string ps20 = null;
            string ps50 = null;
            string ps100 = null;
            string ps200 = null;
            int? pageSize = 50;
            //string strPagerLinkHandler = null;
            //string strPagerSizeHandler = null;
            //string strStartRecordPattern = null;
            var Request = HttpContext.Current.Request;
            var currentPage = global::X.Web.WebContext.Current.Page;

            //'''''''
            if (method == FormMethod.Get) {
                //'Get Base Url
                urlBase = currentPage.StripKeysFromCurrentPage(urlStripKeys + ",startrecordid", normalizeForAppending: true);
            }
            else {
                if (String.IsNullOrWhiteSpace(startRecordFieldID))
                    //Post
                    throw new ArgumentNullException("startRecordFieldID");

                html = String.Format(@"<script type=""text/javascript"" language=""javascript"">
                    function pagerChg(startRecordId){{
                        var element = document.getElementById(""{0}"");
                        element = frmTRG.hdnStartRecordId;
                            element.value = startRecordId; {1}
                    }}</script>",
                    /*0*/startRecordFieldID,
                    /*1*/(String.IsNullOrWhiteSpace(customFunction)) ? " Search(); " : customFunction); //1-element.form.submit();
            }
            
                //get the number of records per page to display
               
            if (((Request.QueryString["RecordNo"]).As<int?>() == null) && (Request.Form["RecordNo"].As<int?>() == null))
            {
                pageSize = 50;
            }
            //else if (Request.QueryString["RecordNo"].As<int?>() != null)
            //{
            //    pageSize = Request.QueryString["RecordNo"].As<int>();
            //}
            //else
            //{
            //    pageSize = Request.Form["RecordNo"].As<int>();
            //}
             
            //<CODE_TAG_101930>
            else if (Request.Form["RecordNo"].As<int?>() != null)
            {
                pageSize = Request.Form["RecordNo"].As<int>();
            }
            else
            {
                pageSize = Request.QueryString["RecordNo"].As<int>();
            }
             //</CODE_TAG_101930>
            //'Get current page num
            currentPageNumber = (int) ((startRecordNumber - 1)/pageSize + 1);
            //'Get total pages for the search
            totalPages = (int) ((totalRecords - 1)/pageSize + 1);
            //'Get the pages link
            pagesLink = "";
            //'Get the last rec number in the page
            pageLastRecordNumber = (int) (startRecordNumber + pageSize - 1);
            if (pageLastRecordNumber > totalRecords) {
                pageLastRecordNumber = totalRecords;
            }
            //'''''''''''
            startPageNumber = ((currentPageNumber - 1)/10)*10 + 1;
            endPageNumber = startPageNumber + 9;
            for (I = startPageNumber; I <= endPageNumber; I += 1) {
                if (I <= totalPages) {
                    //'In right range
                    if (I == currentPageNumber) {
                        //'Disp underline for current page number
                        pagesLink = pagesLink + "<span class=\"tb\">" + I + "</span>&nbsp;";
                    }
                    else {
                        startRecordId = (int) ((I - 1) * pageSize + 1);
                        if(method == FormMethod.Get) {
                            pagesLink = pagesLink + "<a href=\"" + urlBase + "StartRecordId=" + startRecordId + "\" class=\"t\">" + I + "</a>&nbsp;";
                        }
                        else
                            pagesLink = pagesLink + "<a href=\"javascript:;\" class=\"t\" onclick=\"pagerChg(" + startRecordId + ");\">" + I + "</a>&nbsp;";
                    }
                }
            }
           
                //'Prev link
                startRecordId = (int)(startRecordNumber - pageSize);
                lnkPrev = String.Format("<a href=\"{0}\" class=\"t\"{1}>{2}</a>&nbsp;&nbsp;",
                    /*0*/method == FormMethod.Get ? urlBase + "StartRecordId=" + startRecordId : "javascript:;",
                    /*1*/method == FormMethod.Get ? String.Empty : " onclick=\"pagerChg(" + startRecordId + ");\"",
                    /*2*/Resource.GetString("rkText_Prev").HtmlEncode()
                );
                if (currentPageNumber == 1)
                {
                    lnkPrev = "";
                }
                //'Next link
                startRecordId = (int)(startRecordNumber + pageSize);
                lnkNext = String.Format("&nbsp;<a href=\"{0}\" class=\"t\"{1}>{2}</a>",
                    /*0*/method == FormMethod.Get ? urlBase + "StartRecordId=" + startRecordId : "javascript:;",
                    /*1*/method == FormMethod.Get ? String.Empty : " onclick=\"pagerChg(" + startRecordId + ");\"",
                    /*2*/Resource.GetString("rkText_Next").HtmlEncode()
                );
                if (currentPageNumber == totalPages)
                {
                    lnkNext = "";
                }

            
            switch(pageSize)
            {
                case 10:
                    ps10 = "selected=\"true\"";
                    break;
                case 20:
                    ps20 = "selected=\"true\"";
                    break;
                case 50:
                    ps50 = "selected=\"true\"";
                    break;
                case 100:
                    ps100 = "selected=\"true\"";
                    break;
                case 200:
                    ps200 = "selected=\"true\"";
                    break;
                default:
                    ps10 = "selected=\"true\"";
                    break;
            }

            if(pageSize == totalRecords)
            {
                psTotalRecords = "selected=\"true\"";
            }

            if ((totalPages != 1))
            {
                html += "<span id=\"spnPagingNavBar\">" + lnkPrev + pagesLink + lnkNext;
            }

            html += "<span class=\"t\" style=\"margin-left:5px;\">(" + startRecordNumber + " " + Resource.GetString("rkText_to") + " " + pageLastRecordNumber + " " + Resource.GetString("rkText_of") + " " + totalRecords + ")&nbsp;</span>";

            if ((totalPages != 1))
            {
                html += "</span>";
            }

            if (method == FormMethod.Get)
            {
                html += "<br />" + Resource.GetString("rkDropDown_ResultsPerPage_Get") + "<select name=\"RecordNo\" onChange=\"document.location.href='" + currentPage.StripKeysFromCurrentPage("RecordNo, startrecordid", normalizeForAppending: true) + "RecordNo=' + this.value;" + "\" ><option " + ps10 + " value=\"10\">10</option><option " + ps20 + " value=\"20\">20</option><option " + ps50 + " value=\"50\">50</option><option " + ps100 + " value=\"100\">100</option><option " + ps200 + " value=\"200\">200</option><option " + psTotalRecords + " value=\"" + totalRecords + "\">" + Resource.GetString("rkPager_PageSize_All").HtmlEncode() + "</option></select>";
            }

            else
            {
                //html += "<tr><td>" + Resource.GetString("rkDropDown_ResultsPerPage_Post") + "<select name=\"RecordNo\" onChange=\"Search()" + "\" ><option " + ps10 + " value=\"10\">10</option><option " + ps20 + " value=\"20\">20</option><option " + ps50 + " value=\"50\">50</option><option " + ps100 + " value=\"100\">100</option><option " + ps200 + " value=\"200\">200</option><option " + psTotalRecords + " value=\"" + totalRecords + "\">All</option></select></td></tr>";
                //html += "<br /><td>" + Resource.GetString("rkDropDown_ResultsPerPage_Post") + "<select name=\"RecordNo\" onChange=\"Search()" + "\" ><option " + ps10 + " value=\"10\">10</option><option " + ps20 + " value=\"20\">20</option><option " + ps50 + " value=\"50\">50</option><option " + ps100 + " value=\"100\">100</option><option " + ps200 + " value=\"200\">200</option><option " + psTotalRecords + " value=\"" + totalRecords + "\">All</option></select></td>";
                html += "<br />" + Resource.GetString("rkDropDown_ResultsPerPage_Post") + "<select name=\"RecordNo\" onChange=\"Search()" + "\" ><option " + ps10 + " value=\"10\">10</option><option " + ps20 + " value=\"20\">20</option><option " + ps50 + " value=\"50\">50</option><option " + ps100 + " value=\"100\">100</option><option " + ps200 + " value=\"200\">200</option><option " + psTotalRecords + " value=\"" + totalRecords + "\">" + Resource.GetString("rkPager_PageSize_All").HtmlEncode() + "</option></select>";
            }


            return new HtmlString(html);
        }

		//<CODE_TAG_103543> Dav
		public static IHtmlString RecipientFinder(string title, string idFullName, string idUserId, string titleMagnifier, string titleClear, bool useIFrameDialog = false)
		{
			var htmlWriter = new StringBuilder();
			var currentPage = X.Web.WebContext.Current.Page;

			//Client script
			if (HttpContext.Current.Items["UserFinder:ClientRes:Reg"] == null)
			{
				HttpContext.Current.Items["UserFinder:ClientRes:Reg"] = true;

				htmlWriter.Append("<script type=\"text/javascript\">\r\n");
				htmlWriter.Append("	");
				htmlWriter.Append("<!--\r\n");
				htmlWriter.Append("		var curUserFinder = {\r\n");
				htmlWriter.Append("				userFullNameElement: null\r\n");
				htmlWriter.Append("				,userIDElement: null\r\n");
				htmlWriter.AppendLine("         ,useIframe: false");
				htmlWriter.Append("				,initialize: function(obj, idFullName, idUserID, useIframe){\r\n");				
				htmlWriter.Append("					var selectedTr = $j(obj).closest(\"tr\");");
				htmlWriter.Append("					this.userFullNameElement = $j('#'+idFullName, selectedTr);\r\n");
				htmlWriter.Append("					this.userIDElement = $j('#'+idUserID, selectedTr);\r\n");
				htmlWriter.AppendLine("             this.useIframe = useIframe;");
				htmlWriter.Append("				}\r\n");
				htmlWriter.Append("				,find: function(obj, title, idFullName, idUserID, useIframe){\r\n");
				htmlWriter.Append("					this.initialize(obj, idFullName, idUserID, useIframe);\r\n");
				htmlWriter.Append("					\r\n");
				htmlWriter.AppendLine("             if(this.useIframe == true) {");
				htmlWriter.Append("                     openIFrameDialog();\r\n");
				htmlWriter.AppendLine("             }");
				htmlWriter.AppendLine("             else {");
				htmlWriter.Append("					    openWin(\"" + Url.ApplicationPath + "modules/admin/User_Search.aspx?finderType=3&title=\" + escape(title), null, null, \"userFinder\");\r\n");
				htmlWriter.AppendLine("             }");
				htmlWriter.Append("			    }\r\n");
				htmlWriter.Append("				,clear: function(obj, idFullName, idUserID){\r\n");
				htmlWriter.Append("					this.initialize(obj, idFullName, idUserID);\r\n");
				htmlWriter.Append("					\r\n");
				htmlWriter.Append("					this.userFullNameElement.text(\"\");\r\n");
				htmlWriter.Append("					this.userIDElement.val(\"\");\r\n");
				htmlWriter.Append("				}\r\n");
				htmlWriter.Append("				,setUser: function(userID, fullName) {\r\n");
				htmlWriter.Append("					this.userFullNameElement.text(fullName);\r\n");
				htmlWriter.Append("					this.userIDElement.val(userID);\r\n");
				htmlWriter.AppendLine("             if (this.useIframe == true) $j(\"#dlgIFrameDialog\").dialog(\"close\");");
				htmlWriter.Append("				}\r\n");
				htmlWriter.Append("			};\r\n");
				htmlWriter.Append("	//-->\r\n");
				htmlWriter.Append("	</script>");
			}

			htmlWriter.AppendFormat("<img id=test src=\"{0}library/images/magnifier.gif\" style=\"margin-left:5px;\" align=\"absmiddle\" alt=\"{2}\" class=\"imgBtn\" onclick=\"curUserFinder.find(this,'{1}','{4}','{5}',{6});\" />&nbsp;<img src=\"{0}library/images/icon_x.gif\" align=\"absmiddle\" alt=\"{3}\" class=\"imgBtn\" onclick=\"curUserFinder.clear(this,'{4}','{5}');\" />",
				/*0*/Url.ApplicationPath,
				/*1*/title.JavaScriptStringEncode(),
				/*2*/titleMagnifier.HtmlAttributeEncode(),
				/*3*/titleClear.HtmlAttributeEncode(),
				/*4*/idFullName.JavaScriptStringEncode(),
				/*5*/idUserId.JavaScriptStringEncode(),
				/*6*/useIFrameDialog.ToString().ToLower()
				);

			return new HtmlString(htmlWriter.ToString());
		}
		//</CODE_TAG_103543> Dav

        public static IHtmlString SortableColumn(string headerText, string headerTooltip, object alignOrAttributes, string sortField, string oldSortField, string oldSortDirection) {
            return SortableColumn(headerText, headerTooltip, alignOrAttributes, sortField, null, oldSortField, oldSortDirection, null);
        }

        public static IHtmlString SortableColumn(string headerText, object iAlign, string sSortField, string sOldField, string oldSortDirection) {
            return SortableColumn(headerText, null, iAlign, sSortField, null, sOldField, oldSortDirection, null);
        }

        public static IHtmlString SortableColumn(string headerText, string headerTooltip, object alignOrAttributes, string sortField, string defaultSortDirection, string oldSortField, string oldSortDirection) {
            return SortableColumn(headerText, headerTooltip, alignOrAttributes, sortField, defaultSortDirection, oldSortField, oldSortDirection, null);
        }

        public static IHtmlString SortableColumn(string headerText, string headerTooltip, object alignOrAttributes, string sortField, string defaultSortDirection, string oldSortField, string oldSortDirection, string stripUrlKeys) {
            return SortableColumn(headerText, headerTooltip, alignOrAttributes, sortField, defaultSortDirection, oldSortField, oldSortDirection, sortFieldUrlKey: null, sortDirectionUrlKey: null, stripUrlKeys: stripUrlKeys);
        }

        public static IHtmlString SortableColumn(string headerText, string headerTooltip, object alignOrAttributes, string sortField, string defaultSortDirection, string oldSortField, string oldSortDirection, string sortFieldUrlKey = null, string sortDirectionUrlKey = null, string stripUrlKeys = null, string customOnClickFunctionName = null, FormMethod method = FormMethod.Get) {
            string sortDirection = "";
            string strId = "";

            if(sortField.IndexOf(',') == -1 && sortField.IndexOf('[') == -1)
                sortField = '[' + sortField + ']';

            //Direction Logic
            if (0 != String.Compare(sortField, oldSortField, StringComparison.InvariantCultureIgnoreCase)) //NOTE:Manual fixup - ToLower() != ToLower()
        {
                if (defaultSortDirection == null) /*TODO:review - converted to 'Convert.IsDBNull()'*/ {
                    sortDirection = "asc";
                } else {
                    sortDirection = defaultSortDirection;
                }
            } else {
                if (oldSortDirection.ToLower() == "asc") {
                    sortDirection = "desc";
                } else {
                    sortDirection = "asc";
                }
            }
            //Display Logic
            if (alignOrAttributes.IsNumeric()) {
                switch (Convert.ToInt32(alignOrAttributes)) {
                    case 0:
                        strId = " id=\"rshl\" ";
                        break;
                    case 1:
                        strId = " id=\"rshc\" ";
                        break;
                    case 2:
                        strId = " id=\"rshr\" ";
                        break;
                }
            } else {
                strId = Convert.ToString(alignOrAttributes);
            }
            //Tooltip
            if (headerTooltip == null) /*TODO:review - converted to 'Convert.IsDBNull()'*/ {
                headerTooltip = headerText;
            }

            sortFieldUrlKey = sortFieldUrlKey.AsNullIfWhiteSpace(true) ?? "SortField";
            sortDirectionUrlKey = sortDirectionUrlKey.AsNullIfWhiteSpace(true) ?? "SortDirection";

            string onclickEventHandler = null;

            if (!String.IsNullOrWhiteSpace(customOnClickFunctionName))
                onclickEventHandler = String.Format("if({0}('{1}','{2}') == false) return false;"
                    ,/*0*/customOnClickFunctionName
                    ,/*1*/sortField.JavaScriptStringEncode()
                    ,/*2*/sortDirection.JavaScriptStringEncode()
                );

            if (method == FormMethod.Get) {
                var url = Url.UrlStripper(sortFieldUrlKey + "," + sortDirectionUrlKey + "," + stripUrlKeys);
                if (url != "") {
                    url += "&";
                }

                onclickEventHandler = String.Format("{0}document.location.href='{1}?{2}{3}={4}&{5}={6}';"
                    /*0*/, onclickEventHandler
                    /*1*/, HttpContext.Current.Request.ServerVariables["SCRIPT_NAME"]
                    /*2*/, url

                    /*3*/, sortFieldUrlKey
                    /*4*/, sortField.UrlEncode()

                    /*5*/, sortDirectionUrlKey
                    /*6*/, sortDirection.UrlEncode()
                );
            } 

            //Create Header Cell HTML
            return new HtmlString(String.Format("<td {0} title=\"{1}\" style=\"cursor: pointer;\" nowrap=\"nowrap\" onclick=\"{3}\">{2}</td>"
                /*0*/, strId
                /*1*/, headerTooltip
                /*2*/, headerText
                /*3*/, onclickEventHandler
            )); //TODO:Localize
        }

        public static bool IsInteractivePostBack() {
            var interactiveModeCookie = HttpContext.Current.Request.Cookies["x:interactiveMode"];
            return interactiveModeCookie == null || interactiveModeCookie.Value.AsInt() == 1;
        }

        public static bool IsAccountRequiredField(string keyName, int accountType) {
            var value = AppContext.Current.AppSettings[keyName].AsInt();

            return (value & accountType) != 0;
        }

        public static string WrapFormFieldTitle(bool isMandatory = false, bool editMode = true, string title = null) {
            string html = String.Empty;

            if (isMandatory) html += String.Format("<span class=\"{0}requiredWrapper-Title\">", (editMode ? String.Empty : "display-"));
            html += title;
            if (isMandatory) html += String.Format("<span class=\"{0}required\"> *</span></span>", (editMode ? String.Empty : "display-"));

            return html;
        }

        public static string WrapFormField(bool isMandatory, bool editMode, string content) {
            return FormFieldWrapperBegin(isMandatory, editMode) + content + FormFieldWrapperEnd(isMandatory, editMode);
        }

        public static string FormFieldWrapperBegin(bool isMandatory, bool editMode = true) {
            string html = String.Empty;

            if (isMandatory)
                html = String.Format("<span class=\"{0}requiredWrapper-Field\">", (editMode ? String.Empty : "display-"));

            return html;
        }

        public static string FormFieldWrapperEnd(bool isMandatory, bool editMode = true) {
            string html = String.Empty;

            if (isMandatory)
                html = "</span>";

            return html;
        }

        //public static IHtmlString ApplicationCodeDropDownList(string selectedValue) {
        //    var data = SqlHelper.ExecuteDataset("dbo.SalesLink_List_ApplicationCode", AppContext.Current.SystemId, AppContext.Current.DivisionCode);

        //    IEnumerable<ListItem> items = data == null || data.Tables.Count == 0
        //        ? new List<ListItem>()
        //        : data.Tables[0].Rows.OfType<DataRow>()
        //            .Select(row => new ListItem(row.Field<string>("ApplicationCodeDesc"), row.Field<string>("ApplicationCode")) {
        //                Selected = 0 == String.Compare(row.Field<string>("ApplicationCode"), selectedValue, StringComparison.InvariantCultureIgnoreCase)
        //            });

        //    items
        //        .Insert(0, new ListItem(Resource.GetString("rkText_Select"), String.Empty))
        //        .DropDownList(name: "ApplicationCode", cssClass: "f");

        //    //Mandatory
        //    if (AppContext.Current.AppSettings["ckCommon.Customer.Equipment.ApplicationCode.Show"] == "3")
        //        X.Web.WebContext.Current.Page.Output.Write("<span class=\"required\">*</span>");

        //    return null;
        //}

        public static IHtmlString HyperLink(object text, string href, string attributes = null, string emptyText = null, bool? zeroDrillable = null) {
            bool blnDrillable = false;
            
            //empty
            if (text.IsNullOrWhiteSpace()) {
                return new HtmlString(emptyText);
            }

            if (zeroDrillable != null) {
                //numeric link
                if (text.IsNumeric()) {
                    blnDrillable = zeroDrillable.Value || CType.ToDouble(text, 0.0) != 0.0;
                } 

                if (!blnDrillable) {
                    return new HtmlString(text.ToString());
                }
            }
            
            return new HtmlString(String.Format(
                "<a {0} href=\"{1}\">{2}</a>",
                /*0*/attributes,
                /*1*/href,
                /*2*/text.HtmlEncode()
            ));
        }
    } 
}

