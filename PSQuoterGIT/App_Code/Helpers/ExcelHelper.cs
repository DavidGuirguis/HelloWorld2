using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using X.Web.Extensions;


namespace Helpers {
    /// <summary>
    /// Summary description for ExcelHelper
    /// </summary>
    public static class ExcelHelper {
        public const string urlKey_ExcelExport = "excelExport";

        public static string GetExportIcon(string text, string toolTip, string attributes, string postBackFormName) {
            var context = HttpContext.Current;
            var Response = context.Response;
            var currentPage = global::X.Web.WebContext.Current.Page;

            string sHtml = "";
            bool blnAddClass = false;
            //Text
            if (String.IsNullOrWhiteSpace(text))
            {
                text = "Export to Excel";//TODO:localize
            }
            if (String.IsNullOrWhiteSpace(toolTip))
            {
                toolTip = "Export to Excel.";//TODO:localize
            }
            //Attributes
            blnAddClass = String.IsNullOrWhiteSpace(attributes);
            if (!blnAddClass)
            {
                blnAddClass = attributes.ToLower().IndexOf("class=") == 0;
            }
            if (blnAddClass)
            {
                attributes = attributes + " class=\"t\"";
            }
            ///Attributes
            sHtml = "<a " + attributes;
            if (String.IsNullOrWhiteSpace(postBackFormName))
            {
                sHtml = sHtml + " href=\"" + currentPage.StripKeysFromCurrentPage(urlKey_ExcelExport, normalizeForAppending: true) + urlKey_ExcelExport + "=1" + "\"";
            }
            else
            {
                sHtml = sHtml + " href=\"javascript:;\" onclick=\"export2Excel();return false;\"";

                if (context.Items["_excelHelper:scriptReg"] == null) {
                    context.Items["_excelHelper:scriptReg"] = 1;

                    Response.Write("<script language=\"javascript\" type=\"text/javascript\">\r\n");
                    Response.Write("            function export2Excel()\r\n");
                    Response.Write("            {\r\n");
                    Response.Write("                var thisForm = ");
                    Response.Write(postBackFormName);
                    Response.Write(";\r\n");
                    Response.Write("                if(thisForm.method.toUpperCase() == \"GET\")\r\n");
                    Response.Write("                {\r\n");
                    Response.Write("                    if(!thisForm.elements[\"");
                    Response.Write(urlKey_ExcelExport);
                    Response.Write("\"])\r\n");
                    Response.Write("                    {\r\n");
                    Response.Write("                        var element = document.createElement(\"<input type='hidden' name='");
                    Response.Write(urlKey_ExcelExport);
                    Response.Write("' value='1' />\");\r\n");
                    Response.Write("                        thisForm.insertAdjacentElement(\"beforeEnd\", element);\r\n");
                    Response.Write("                    }\r\n");
                    Response.Write("                    thisForm.elements[\"");
                    Response.Write(urlKey_ExcelExport);
                    Response.Write("\"].value = \"1\";\r\n");
                    Response.Write("                    thisForm.submit();\r\n");
                    Response.Write("                    thisForm.elements[\"");
                    Response.Write(urlKey_ExcelExport);
                    Response.Write("\"].value = \"0\";\r\n");
                    Response.Write("                }\r\n");
                    Response.Write("                else\r\n");
                    Response.Write("                {\r\n");
                    Response.Write("                    var oldAction = thisForm.action.length == 0 ? document.location.href : thisForm.action;\r\n");
                    Response.Write("                    var newAction = oldAction.replace(/((&|&amp;)");
                    Response.Write(urlKey_ExcelExport);
                    Response.Write("=[^&]*)|(");
                    Response.Write(urlKey_ExcelExport);
                    Response.Write("=[^&]*(&|&amp;))/g, \"\");\r\n");
                    Response.Write("                    if(newAction == \"\" || newAction.indexOf(\"?\") == -1)\r\n");
                    Response.Write("                        newAction += \"?\"\r\n");
                    Response.Write("                    else {\r\n");
                    Response.Write("                        switch(newAction.charAt(newAction.length-1))\r\n");
                    Response.Write("                        {\r\n");
                    Response.Write("                            case \"?\":\r\n");
                    Response.Write("                            case \"&\":\r\n");
                    Response.Write("                                break;\r\n");
                    Response.Write("                            default:\r\n");
                    Response.Write("                                newAction   += \"&\";\r\n");
                    Response.Write("                        }\r\n");
                    Response.Write("                    }\r\n");
                    Response.Write("                    thisForm.action = newAction + \"");
                    Response.Write(urlKey_ExcelExport);
                    Response.Write("=1\";\r\n");
                    Response.Write("                    thisForm.submit();\r\n");
                    Response.Write("                    thisForm.action = oldAction;\r\n");
                    Response.Write("                }\r\n");
                    Response.Write("            }\r\n");
                    Response.Write("		</script>");
                }
            }
            sHtml = sHtml + "><img src=\"/library/images/icon_doctype_excel.gif\" border=\"0\" align=\"absmiddle\" alt=\"" + toolTip + "\" />&nbsp;" + text + "</a>";
            return sHtml;
        }

        public static void WriteHeader(string fileName = null) {
            var context = HttpContext.Current;
            var Response = context.Response;
            
            Response.Buffer = true;
            Response.Clear();
            Response.Expires = -1;
            Response.ContentType = "application/vnd.ms-excel";
            //Response.AddHeader "Pragma", "no-cache" ##GT20080529 comment out, otherwise will fail in IE6##
            //Popup the Save As dialog
            if (!String.IsNullOrWhiteSpace(fileName)) {
                Response.AddHeader("content-disposition", "attachment; filename=" + fileName);
            }
            Response.Write("	<html xmlns:o=\"urn:schemas-microsoft-com:office:office\"\r\n");
            Response.Write("	xmlns:x=\"urn:schemas-microsoft-com:office:excel\"\r\n");
            Response.Write("	xmlns=\"http://www.w3.org/TR/REC-html40\">\r\n");
            Response.Write("	<head>\r\n");
            Response.Write("	<meta http-equiv=Content-Type content=\"text/html; charset=windows-1252\">\r\n");
            Response.Write("	<meta name=ProgId content=Excel.Sheet>\r\n");
            Response.Write("	<meta name=Generator content=\"Microsoft Excel 10\">\r\n");
            Response.Write("	");
            Response.Write("<!--[if gte mso 9]><xml>\r\n");
            Response.Write("	<o:DocumentProperties>\r\n");
            Response.Write("	<o:Author>");
            Response.Write(WebContext.Current.User.IdentityEx.Company);
            Response.Write("</o:Author>\r\n");
            Response.Write("	<o:Created>2004-10-04T12:11:55Z</o:Created>\r\n");
            Response.Write("	<o:LastSaved>2004-10-04T12:28:42Z</o:LastSaved>\r\n");
            Response.Write("	<o:Company>");
            Response.Write(WebContext.Current.User.IdentityEx.Company);
            Response.Write("</o:Company>\r\n");
            Response.Write("	<o:Version>10.3501</o:Version>\r\n");
            Response.Write("	</o:DocumentProperties>\r\n");
            Response.Write("	<o:OfficeDocumentSettings>\r\n");
            Response.Write("	<o:DownloadComponents/>\r\n");
            Response.Write("	</o:OfficeDocumentSettings>\r\n");
            Response.Write("	</xml><![endif]-->\r\n");
            Response.Write("	<style>\r\n");
            Response.Write("	");
            Response.Write("<!--table");
            Response.Write("		{mso-displayed-decimal-separator:\"\\.\";");
            Response.Write("		mso-displayed-thousand-separator:\"\\,\";}");
            Response.Write("	@page");
            Response.Write("		{margin:1.0in .75in 1.0in .75in;");
            Response.Write("		mso-header-margin:.5in;");
            Response.Write("		mso-footer-margin:.5in;}");
            Response.Write("	tr");
            Response.Write("		{mso-height-source:auto;}");
            Response.Write("	col");
            Response.Write("		{mso-width-source:auto;}");
            Response.Write("	br");
            Response.Write("		{mso-data-placement:same-cell;}");
            Response.Write("	.style0");
            Response.Write("		{mso-number-format:General;");
            Response.Write("		text-align:general;");
            Response.Write("		vertical-align:bottom;");
            Response.Write("		white-space:nowrap;");
            Response.Write("		mso-rotate:0;");
            Response.Write("		mso-background-source:auto;");
            Response.Write("		mso-pattern:auto;");
            Response.Write("		color:windowtext;");
            Response.Write("		font-size:10.0pt;");
            Response.Write("		font-weight:400;");
            Response.Write("		font-style:normal;");
            Response.Write("		text-decoration:none;");
            Response.Write("		font-family:Arial;");
            Response.Write("		mso-generic-font-family:auto;");
            Response.Write("		mso-font-charset:0;");
            Response.Write("		border:none;");
            Response.Write("		mso-protection:locked visible;");
            Response.Write("		mso-style-name:Normal;");
            Response.Write("		mso-style-id:0;}");
            Response.Write("	td");
            Response.Write("		{mso-style-parent:style0;");
            Response.Write("		padding-top:1px;");
            Response.Write("		padding-right:1px;");
            Response.Write("		padding-left:1px;");
            Response.Write("		mso-ignore:padding;");
            Response.Write("		color:windowtext;");
            Response.Write("		font-size:10.0pt;");
            Response.Write("		font-weight:400;");
            Response.Write("		font-style:normal;");
            Response.Write("		text-decoration:none;");
            Response.Write("		font-family:Arial;");
            Response.Write("		mso-generic-font-family:auto;");
            Response.Write("		mso-font-charset:0;");
            Response.Write("		mso-number-format:\"\\@\";");
            Response.Write("		text-align:general;");
            Response.Write("		vertical-align:bottom;");
            Response.Write("		border:none;");
            Response.Write("		mso-background-source:auto;");
            Response.Write("		mso-pattern:auto;");
            Response.Write("		mso-protection:locked visible;");
            Response.Write("		white-space:nowrap;");
            Response.Write("		mso-rotate:0;}");
            Response.Write("	.xl24");
            Response.Write("		{mso-style-parent:style0;");
            Response.Write("		font-size:8.0pt;");
            Response.Write("		font-family:Arial, sans-serif;");
            Response.Write("		mso-font-charset:0;}");
            Response.Write("	.xl25");
            Response.Write("		{mso-style-parent:style0;");
            Response.Write("		font-size:8.0pt;");
            Response.Write("		font-family:Arial, sans-serif;");
            Response.Write("		mso-font-charset:0;");
            Response.Write("		text-align:left;}");
            Response.Write("	.xl26");
            Response.Write("		{mso-style-parent:style0;");
            Response.Write("		font-size:8.0pt;");
            Response.Write("		font-family:Arial, sans-serif;");
            Response.Write("		mso-font-charset:0;");
            Response.Write("		text-align:right;}");
            Response.Write("	.xl27");
            Response.Write("		{mso-style-parent:style0;");
            Response.Write("		font-size:8.0pt;");
            Response.Write("		font-family:Arial, sans-serif;");
            Response.Write("		mso-font-charset:0;");
            Response.Write("		mso-number-format:\"\\@\";");
            Response.Write("		text-align:left;}");
            Response.Write("	.xl28");
            Response.Write("		{mso-style-parent:style0;");
            Response.Write("		font-size:8.0pt;");
            Response.Write("		font-weight:700;");
            Response.Write("		font-family:Arial, sans-serif;");
            Response.Write("		mso-font-charset:0;}");
            Response.Write("	.xl29");
            Response.Write("		{mso-style-parent:style0;");
            Response.Write("		font-size:8.0pt;");
            Response.Write("		font-weight:700;");
            Response.Write("		font-family:Arial, sans-serif;");
            Response.Write("		mso-font-charset:0;");
            Response.Write("		text-align:left;}");
            Response.Write("	.xl30");
            Response.Write("		{mso-style-parent:style0;");
            Response.Write("		font-size:8.0pt;");
            Response.Write("		font-weight:700;");
            Response.Write("		font-family:Arial, sans-serif;");
            Response.Write("		mso-font-charset:0;");
            Response.Write("		text-align:center;}");
            Response.Write("	.xl31");
            Response.Write("		{mso-style-parent:style0;");
            Response.Write("		font-size:8.0pt;");
            Response.Write("		font-weight:700;");
            Response.Write("		font-family:Arial, sans-serif;");
            Response.Write("		mso-font-charset:0;");
            Response.Write("		mso-number-format:\"\\@\";");
            Response.Write("		text-align:center;}");
            Response.Write("	.xl32");
            Response.Write("		{mso-style-parent:style0;");
            Response.Write("		color:black;");
            Response.Write("		font-size:8.0pt;");
            Response.Write("		font-family:Arial, sans-serif;");
            Response.Write("		mso-font-charset:0;");
            Response.Write("		text-align:left;");
            Response.Write("		white-space:normal;}");
            Response.Write("	.xl33");
            Response.Write("		{mso-style-parent:style0;");
            Response.Write("		font-size:8.0pt;");
            Response.Write("		font-family:Arial, sans-serif;");
            Response.Write("		mso-font-charset:0;");
            Response.Write("		text-align:left;");
            Response.Write("		white-space:normal;}");
            Response.Write("	.xl34");
            Response.Write("		{mso-style-parent:style0;");
            Response.Write("		font-size:8.0pt;");
            Response.Write("		font-family:Arial, sans-serif;");
            Response.Write("		mso-font-charset:0;");
            Response.Write("		mso-number-format:\"\\0022$\\0022\\#\\,\\#\\#0\\.00_\\)\\;\\[Red\\]\\\\\\(\\0022$\\0022\\#\\,\\#\\#0\\.00\\\\\\)\";");
            Response.Write("		text-align:right;");
            Response.Write("		white-space:normal;}");
            Response.Write("	.thc {");
            Response.Write("		mso-style-parent:style0;");
            Response.Write("		font-weight:700;}");
            Response.Write("	.rl {");
            Response.Write("	");
            Response.Write("		}");
            Response.Write("	.rd {");
            Response.Write("		}");
            Response.Write("	.ftCurrency {");
            Response.Write("		mso-style-parent:style0;");
            Response.Write("		mso-number-format:\"\\0022$\\0022\\#\\,\\#\\#0\\.00_\\)\\;\\\\\\(\\0022$\\0022\\#\\,\\#\\#0\\.00\\\\\\)\";}");
            Response.Write("	.ftDate {");
            Response.Write("		mso-style-parent:style0;");
            Response.Write("		mso-number-format:\"mmm\\\\ dd\\\\\\,\\\\ yyyy\";}");
            Response.Write("	.rowDiv {");
            Response.Write("		border-top:1pt solid windowtext}");
            Response.Write("	.rowSubDiv {");
            Response.Write("		border-top:.5pt solid windowtext}");
            Response.Write("	#rsl{");
            Response.Write("		mso-style-parent:style0;");
            Response.Write("		text-align:left;}");
            Response.Write("	#rsc{");
            Response.Write("		mso-style-parent:style0;");
            Response.Write("		text-align:center;}");
            Response.Write("	#rsr{");
            Response.Write("		mso-style-parent:style0;");
            Response.Write("		text-align:right;}");
            Response.Write("	#rshl{");
            Response.Write("		mso-style-parent:style0;");
            Response.Write("		text-align:left;");
            Response.Write("		font-weight:700;}");
            Response.Write("	#rshc{");
            Response.Write("		mso-style-parent:style0;");
            Response.Write("		text-align:center;");
            Response.Write("		font-weight:700;}");
            Response.Write("	#rshr{");
            Response.Write("		mso-style-parent:style0;");
            Response.Write("		text-align:right;");
            Response.Write("		font-weight:700;}");
            Response.Write("	-->");
            Response.Write("	</style>\r\n");
            Response.Write("	");
            Response.Write("<!--[if gte mso 9]><xml>");
            Response.Write("	<x:ExcelWorkbook>");
            Response.Write("	<x:ExcelWorksheets>");
            Response.Write("	<x:ExcelWorksheet>");
            Response.Write("		<x:Name>Sheet1</x:Name>");
            Response.Write("		<x:WorksheetOptions>");
            Response.Write("		<x:DefaultRowHeight>225</x:DefaultRowHeight>");
            Response.Write("		<x:Print>");
            Response.Write("		<x:ValidPrinterInfo/>");
            Response.Write("		<x:HorizontalResolution>600</x:HorizontalResolution>");
            Response.Write("		<x:VerticalResolution>600</x:VerticalResolution>");
            Response.Write("		</x:Print>");
            Response.Write("		<x:Selected/>");
            Response.Write("		<x:Panes>");
            Response.Write("		<x:Pane>");
            Response.Write("		<x:Number>3</x:Number>");
            Response.Write("		<x:ActiveRow>5</x:ActiveRow>");
            Response.Write("		<x:ActiveCol>5</x:ActiveCol>");
            Response.Write("		</x:Pane>");
            Response.Write("		</x:Panes>");
            Response.Write("		<x:ProtectContents>False</x:ProtectContents>");
            Response.Write("		<x:ProtectObjects>False</x:ProtectObjects>");
            Response.Write("		<x:ProtectScenarios>False</x:ProtectScenarios>");
            Response.Write("		</x:WorksheetOptions>");
            Response.Write("	</x:ExcelWorksheet>");
            Response.Write("	<x:ExcelWorksheet>");
            Response.Write("		<x:Name>Sheet2</x:Name>");
            Response.Write("		<x:WorksheetOptions>");
            Response.Write("		<x:ProtectContents>False</x:ProtectContents>");
            Response.Write("		<x:ProtectObjects>False</x:ProtectObjects>");
            Response.Write("		<x:ProtectScenarios>False</x:ProtectScenarios>");
            Response.Write("		</x:WorksheetOptions>");
            Response.Write("	</x:ExcelWorksheet>");
            Response.Write("	<x:ExcelWorksheet>");
            Response.Write("		<x:Name>Sheet3</x:Name>");
            Response.Write("		<x:WorksheetOptions>");
            Response.Write("		<x:ProtectContents>False</x:ProtectContents>");
            Response.Write("		<x:ProtectObjects>False</x:ProtectObjects>");
            Response.Write("		<x:ProtectScenarios>False</x:ProtectScenarios>");
            Response.Write("		</x:WorksheetOptions>");
            Response.Write("	</x:ExcelWorksheet>");
            Response.Write("	</x:ExcelWorksheets>");
            Response.Write("	<x:WindowHeight>13170</x:WindowHeight>");
            Response.Write("	<x:WindowWidth>19020</x:WindowWidth>");
            Response.Write("	<x:WindowTopX>120</x:WindowTopX>");
            Response.Write("	<x:WindowTopY>60</x:WindowTopY>");
            Response.Write("	<x:ProtectStructure>False</x:ProtectStructure>");
            Response.Write("	<x:ProtectWindows>False</x:ProtectWindows>");
            Response.Write("	</x:ExcelWorkbook>");
            Response.Write("	</xml><![endif]-->");
            Response.Write("	</head>\r\n");
            Response.Write("	<body link=blue vlink=purple class=xl24>");
        }

        //WriteHeader
        public static void WriteFooter(bool endResponse) {
            HttpContext.Current.Response.Write("</body></html>");
            if (endResponse) {
                HttpContext.Current.Response.End();
            }
        }

        public static bool IsScreenView {
            get { return !IsExcelView; }
        }

        public static bool IsExcelView {
            get {
                var excelView = HttpContext.Current.Items["_excelHelper:IsExcelView"];

                if (excelView == null) {
                    excelView = "1" == (HttpContext.Current.Request.QueryString[urlKey_ExcelExport] ?? HttpContext.Current.Request.Form[urlKey_ExcelExport]);
                    HttpContext.Current.Items["_excelHelper:IsExcelView"] = excelView;
                }

                return (bool) excelView;
            }
        }

        public static string CellFormatNumberGeneral {
            get {
                if (IsExcelView) 
                    return " x:num";
                
                return null;
            }
        }

        public static string CellFormatNumberCurrency{
            get {
                if (IsExcelView) 
                    return @" x:num class=""ftCurrency""";
                
                return null;
            }
        }

        public static string CellFormatDate{
            get {
                if (IsExcelView)
                    return @" class=""ftDate""";
                
                return null;
            }
        }
    } 
}