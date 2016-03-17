using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using Microsoft.VisualBasic;

namespace Helpers {
    /// <summary>
    /// Summary description for DateTimeHelper
    /// </summary>
    public static class DateTimeHelper {
        public static string ToISODateString(this DateTime? date) {
            if (date == null) return null;

            return date.Value.ToString("yyyy-MM-dd");
        }

        public static string ToISODateString(this DateTime date) {
            return date.ToString("yyyy-MM-dd");
        }
        
        public static string ToISODateTimeString(this DateTime? date) {
            if (date == null) return null;

            return date.Value.ToString("yyyy-MM-dd HH:mm:ss");
        }

        public static string ToISODateTimeString(this DateTime date) {
            return date.ToString("yyyy-MM-dd HH:mm:ss");
        }

        public static string FormatDate(DateTime? date, bool useLongFormat = false, bool? useLongTimeFormat = null)
        {
            string sFormatDate = "";
            string sTime = "";
            if (date != null)
            {
                if (useLongFormat)
                {
                    sFormatDate = Strings.FormatDateTime(date.Value, DateFormat.LongDate);
                }
                else
                {
                    sFormatDate = date.Value.ToString("MMM dd, yyyy");//TODO:get from global resource
                }
                if (useLongTimeFormat != null)
                {
                    if (useLongTimeFormat.Value)
                    {
                        sFormatDate = sFormatDate + " " + Strings.FormatDateTime(date.Value, DateFormat.LongTime);//TODO:get from global resource
                    }
                    else
                    {
                        sFormatDate = sFormatDate + " " + date.Value.ToString("hh:mm tt");//TODO:get from global resource
                    }
                }
            }
            return sFormatDate;
        }

        public static string FormatYearMonth(DateTime? date) {
            if (date == null) return null;

            return date.Value.ToString("MM/yyyy");
        }

        public static string FormatYearMonth(int? year, int? month) {
            if (year == null || month == null) return null;

            return FormatYearMonth(new DateTime(year.Value, month.Value, 1));
        }

        public static string MonthName(int? month, bool abbreviate) {
            if(month == null || month < 1 || month > 12) return null;

            if (abbreviate)
                return DateTimeFormatInfo.CurrentInfo.GetAbbreviatedMonthName(month.Value);

            return DateTimeFormatInfo.CurrentInfo.GetMonthName(month.Value);
        }
    }
}