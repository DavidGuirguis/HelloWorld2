using System;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using System.Linq;
using System.Net.Mail;
using System.Web;
using Microsoft.VisualBasic;
using X.Extensions;
using X.Web;
using System.Text.RegularExpressions;

namespace Helpers {
    public static class Util {
        private static readonly ResourceManager Resource = new ResourceManager(typeof(Util));

        //-- Get Extension Name
        public static string GetExtName(string fileName)
        {
            if(fileName == null) throw new ArgumentNullException("fileName");

            int iPos = fileName.LastIndexOf(".");
            if (iPos == -1)
                return fileName;

            return fileName.Substring(iPos + 1);
        }

        //-- Get Icon Name
        public static string GetIconName(string fileName)
        {
            string strExtName = "";
            string iconName = "";
            strExtName = (GetExtName(fileName)).ToLower();
            switch (strExtName)
            {
                case "html":
                case "htm":
                    iconName = "icon_doctype_html.gif";
                    break;
                case "xml":
                    iconName = "icon_doctype_xml.gif";
                    break;
                case "doc":
                    iconName = "icon_doctype_word.gif";
                    break;
                case "xls":
                case "csv":
                    iconName = "icon_doctype_excel.gif";
                    break;
                case "tif":
                    iconName = "icon_doctype_tif.gif";
                    break;
                case "png":
                case "jpg":
                case "jpeg":
                case "gif":
                case "bmp":
                    iconName = "icon_doctype_image.gif";
                    break;
                case "pdf":
                    iconName = "icon_doctype_pdf.gif";
                    break;
                case "ppt":
                    iconName = "icon_doctype_ppt.gif";
                    break;
                case "txt":
                    iconName = "icon_doctype_text.gif";
                    break;
                case "msg":
                    iconName = "icon_doctype_email.gif";
                    break;
                default:
                    iconName = "icon_doctype_doc.gif";
                    break;
            }
            return iconName;
        }

        //-- Get Icon
        public static string GetIcon(string fileName)
        {
            return "<img src=\"" + global::X.Web.WebContext.Current.Page.RelativeApplicationPath + "library/images/" + GetIconName(fileName) + "\" align=absmiddle>";
        }
        

        //**********************************************Format service Meter*****************************************************
        public static string FormatServiceMeter(double? serviceMeter, string serviceMeterInd, DateTime? serviceMeterDate) {
            switch (serviceMeterInd) {
                case "H":
                    serviceMeterInd = "Hrs";
                    break;
                case "M":
                    serviceMeterInd = "Mi";
                    break;
                case "K":
                    serviceMeterInd = "Km";
                    break;
            }

            if (serviceMeterDate != null)
            {
                return String.Format("{0} {1} on {2}", NumberFormat(serviceMeter, 2, null, -1, null, true), serviceMeterInd, DateFormat(serviceMeterDate)).Trim();
            }

            return String.Format("{0} {1}", NumberFormat(serviceMeter, 2, null, -1, null, true), serviceMeterInd).Trim();
        }
        // ServiceMeterDate = oRs.Fields["ServiceMeterDate"].Value.As<DateTime?>();
        //***********************************************Format Number*********************************************************************
        public static string NumberFormat(double? iValue, int iNumOfDigits, int? iIncludeLeadingDigits = -2, int? iNegativeParens = -2, int? iGroupDigits = -2, bool? iShowZero = true) {
            iShowZero = iShowZero ?? false;

            if (iIncludeLeadingDigits == null) {
                iIncludeLeadingDigits = -2;
            }
            if (iNegativeParens == null) {
                iNegativeParens = -2;
            }
            if (iGroupDigits == null) {
                iGroupDigits = -2;
            }
            if (iValue != null && (iShowZero.Value || iValue != 0)) {
                return Strings.FormatNumber(iValue.Value, iNumOfDigits, (TriState)iIncludeLeadingDigits, (TriState)iNegativeParens, (TriState)iGroupDigits);
            }

            return null;
        }

        //**************************************************Row Shading******************************************************/
        public static string RowClass(int elValue) {
            string strRowClass = "";
            switch (Math.Abs(elValue % 2)) {
                case 0:
                    strRowClass = "class=\"rl\"";
                    break;
                case 1:
                    strRowClass = "class=\"rd\"";
                    break;
            }
            return strRowClass;
        }

        public static string RowClass(ref int rowIndex, string[] rowClasses) {
            if (rowClasses == null) throw new ArgumentNullException("rowClasses");

            return rowClasses[rowIndex++%2];
        }

        public static string DateFormat(DateTime? date) {
            if (date == null) return null;

            return date.Value.ToString("MMM dd, yyyy");//TODO:localize
        }

        public static string DateFormat(int? numericDate) {
            if (numericDate == null) return null;

            var dateString = numericDate.ToString();

            //Invalid date time
            if (dateString.Length < 7) return null;

            var days = dateString.Right(3).AsInt();
            var year = dateString.Left(4).AsInt();
            var date = new DateTime(year, 1, 1)
                .AddDays(days);

            return date.ToString("MMM dd, yyyy");//TODO:localize
        }

        public static string ExtractUserName(string credentialName) {
            if (String.IsNullOrWhiteSpace(credentialName)) return null;

            credentialName = credentialName.Replace('/', '\\');

            var pos = credentialName.IndexOf('\\');

            if (pos == -1)
                return credentialName;

            return credentialName.Substring(pos + 1);
        }

        /// <summary>
        /// Compare two values with specified type.
        /// </summary>
        /// <param name="newValue"></param>
        /// <param name="oldValue"></param>
        /// <param name="hasChanged"></param>
        /// <returns></returns>
        public static T CompareValue<T>(object newValue, object oldValue, ref bool hasChanged) {
            var type = typeof(T);
            Type baseType = type;

            //Check for IComparable
            if (!typeof(IComparable).IsAssignableFrom(type)
                && (
                    !type.IsGenericType
                    || type.GetGenericTypeDefinition() != typeof(Nullable<>)
                    || !typeof(IComparable).IsAssignableFrom(baseType = type.GetGenericArguments()[0])
                )
            ) {
                throw new ArgumentOutOfRangeException("<T> does not implement IComparable interface.");
            }

            //Check for of type 'numeric'
            var fullTypeName = baseType.FullName;
            var isNumericType = fullTypeName == "System.Int32"
                || fullTypeName == "System.Double"
                || fullTypeName == "System.Decimal"
                || fullTypeName == "System.Int16"
                || fullTypeName == "System.Single"
                || fullTypeName == "System.Byte"
                || fullTypeName == "System.Int64"
                || fullTypeName == "System.SByte"
                || fullTypeName == "System.UInt16"
                || fullTypeName == "System.UInt32"
                || fullTypeName == "System.UInt64"
            ;

            if (isNumericType && !newValue.IsNumeric()) return oldValue.As<T>();

            //Check for of type 'string'
            if (!isNumericType && baseType == typeof(string)) {
                //Trim values
                if (newValue != null) newValue = newValue.ToString().Trim();
                if (oldValue != null) oldValue = oldValue.ToString().Trim();
            }

            var castNewValue = newValue.As<T>();
            var castOldValue = oldValue.As<T>();

            hasChanged = hasChanged
                || (castNewValue == null && castOldValue != null)
                || (castNewValue != null && castOldValue == null)
                || (castNewValue != null && castOldValue != null && ((IComparable)castNewValue).CompareTo(castOldValue) != 0);

            return castNewValue;
        }

        public static string FormatFullName(string firstName, string lastName, bool showLastNameFirst = false) {
            if (String.IsNullOrWhiteSpace(firstName) && String.IsNullOrWhiteSpace(lastName)) return String.Empty;

            string format = showLastNameFirst ? "{1}, {0}" : "{0} {1}";//TODO:move to '_global' resource file
            
            return String.Format(format, /*0*/firstName, /*1*/lastName);
        }

        public static string FormatCodeDesc(string code, string codeDesc, string emptyText = null) {
            if (String.IsNullOrWhiteSpace(code) && String.IsNullOrWhiteSpace(codeDesc))
                return emptyText;
            
            if (String.IsNullOrWhiteSpace(code) || String.IsNullOrWhiteSpace(codeDesc))
                return code + codeDesc;

            return codeDesc + " (" + code + ")";
        }

        public static string FormatPhoneNumber(string phoneNumber) {
            if (String.IsNullOrWhiteSpace(phoneNumber)) return null;

            return phoneNumber;
        }

        //---- Clean ADODB.Recordset ---
        public static void CleanUp(ADODB.Command cmd = null, ADODB.Recordset rs = null)
        {
            if (rs != null && rs.State == (int)ADODB.ObjectStateEnum.adStateOpen) rs.Close();

            if (cmd != null && cmd.ActiveConnection != null) cmd.ActiveConnection.Close();
        }

        public static string SendEmail(string sTo, string sCc, string sBcc, string sFrom, string sSubject, string sBody, string sAlert)
        {
            SmtpClient objMail = new SmtpClient(System.Configuration.ConfigurationManager.AppSettings["mail.smtpServer"]);
            string recipents = null;
            string alert = null;

            if(!(sTo.IsNullOrWhiteSpace()) &&!(sFrom.IsNullOrWhiteSpace()))
            {
                recipents = recipents + sTo;

                if(!(sCc.IsNullOrWhiteSpace()))
                {
                    recipents = recipents + sCc;
                }

                if (!(sBcc.IsNullOrWhiteSpace()))
                {
                    recipents = recipents + sBcc;
                }
                objMail.Send(ConfigurationManager.AppSettings["mail.from"], recipents, sSubject, sBody);
            }           

            if(sCc.IsNullOrWhiteSpace())
            {
                alert = "<" + "script" + ">\r\n"; 
                alert = alert + "alert(\"Email has been sent to \"" + sAlert + "\");\r\n" ;
                alert = alert + "</script>";
            }
            else
            {
                alert = "<" + "script" + ">\r\n";
                alert = alert + "alert(\"Email has been sent to \"" + sAlert + "\"and Cc \"" + sCc + "\");\r\n";
                alert = alert + "</script>";
            }

            return alert;

        }

        //<CODE_TAG_103629>
        public static void SendEmail(string sTo, string sSubject, string sBody)
        {
            if (string.IsNullOrEmpty(sTo)) return;  //no send email when email address is empty

            SmtpClient objMail = new SmtpClient(System.Configuration.ConfigurationManager.AppSettings["mail.smtpServer"]);
            MailMessage message = new MailMessage();
            message.To.Add(new MailAddress(sTo));
            message.Subject = sSubject;
            message.Body = sBody;
            message.IsBodyHtml = true;
            message.From = new MailAddress( ConfigurationManager.AppSettings["mail.from"].AsString());
            objMail.Send(message);

        }
        //</CODE_TAG_103629>
        //------ Check if the object is open recordset ----------------
        public static bool IsLoopableRecordset(ADODB.Recordset vRs)
        {
            bool bLoopable = false;
            if (vRs != null)
            {
                if (vRs.State == (int)ADODB.ObjectStateEnum.adStateOpen)
                {
                    //- Open ADODB.Recordset
                    bLoopable = !(vRs.EOF || vRs.BOF);
                }
            }
            return bLoopable;
        }


        public static string FormatCurrency(double? figure)
        {
            if(figure!=null)
            {
                
                if(figure == 0)
                {
                    return "0.00";
                }

                return String.Format("{0:n2}", figure.As<double>());
            }

            return null;
        }

 

    }
    // <CODE_TAG_104057>
    public static class DataDelimiter
    {
        public class MatrixDataDelimeter
        {
            #region General Matrix Data Delimiter Pair
            public static string rowDelimiter = "~";
            public static string columnDelimiter = "|";
            #endregion

            #region influencer Matrix Data Delimiter Pair
            public static string influencer_RowDelimiter = "~";
            public static string influencer_ColumnDelimiter = "|";
            #endregion
        }

        public class SingleDimensionalArrayDataDelimeter
        {
            //General Matrix Data Delimiter 
            public static string delimiter = Convert.ToString((char)5);
            public static string influencer_Delimiter = Convert.ToString((char)5);

        }
    }
    // </CODE_TAG_104057>
}