using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text.RegularExpressions;//<CODE_TAG_101731>

/// <summary>
/// Summary description for StringUtils
/// </summary>
public static class StringUtils
{
    public static string JSONEscape(string data) {
        if (data == null) return "";

        return data
            .Replace("\\", "\\\\")
            .Replace("\"", "\\\"")
            .Replace("'", "\\'")
        ;
    }

    //<CODE_TAG_101731>
    public static string ConvertCarriageReturnToBR(string str)
    {

        if (!string.IsNullOrWhiteSpace(str))
        {
            Regex regex = new Regex(@"(\r\n|\r|\n)+");
            return regex.Replace(str, "<br />");
        }

        return str;
    }
    //</CODE_TAG_101731>
}
