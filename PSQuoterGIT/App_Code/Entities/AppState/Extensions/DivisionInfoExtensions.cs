using AppContext = Canam.AppContext;
using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using X.Web.Extensions;

namespace Entities.AppState.Extensions {
    public static class DivisionInfoExtensions {
        public static void RenderDropDownListByVisibility(this IDictionary<string, DivisionInfo> divisions, bool abbreviate, string fieldName, ref string selectedValue, string attributes = null, ListItem[] beginningItems = null, Func<DivisionInfo, string> textFormatter = null, TextWriter writer = null) {
            var selectedText = String.Empty;
            RenderDropDownListByVisibility(divisions, abbreviate, fieldName, ref selectedValue, ref selectedText, attributes: attributes, beginningItems: beginningItems, textFormatter: textFormatter, writer: writer);
        }

        public static void RenderDropDownListByVisibility(this IDictionary<string, DivisionInfo> divisions, bool abbreviate, string fieldName, ref string selectedValue, ref string selectedText, string attributes = null, ListItem[] beginningItems = null, Func<DivisionInfo, string> textFormatter = null, TextWriter writer = null) {
            if(writer == null) writer = HttpContext.Current.Response.Output;
            
            if (textFormatter == null) textFormatter = DefaultDivisionDropDownListTextFormatter;
            
            var listItems = divisions.Values.Where(item => (item.BusinessEntityVisibilityFlags & AppContext.Current.BusinessEntityId) != 0).ToListItem(textFormatter, item => item.DivisionCode);

            if(beginningItems != null && beginningItems.Length > 0) listItems.InsertRange(0, beginningItems);

            var value = selectedValue;
            var selectedItems = listItems.Where(item => item.Value == value);

            if (selectedItems.Count() == 0) {
                selectedValue = null;
                selectedText = null;
            } 
            else {
                var firstItem = selectedItems.First();

                selectedValue = firstItem.Value;
                selectedText = firstItem.Text;

                foreach (var selectedItem in selectedItems) {
                    selectedItem.Selected = true;
                }
            }

            writer.Write(String.Format("<select name=\"{0}\" {1}>", fieldName, attributes));
            foreach (var listItem in listItems) {
                writer.Write("<option value=\"{0}\"{2}>{1}</option>",
                    /*0*/listItem.Value.HtmlEncode(),
                    /*1*/listItem.Text.HtmlEncode(),
                    /*2*/listItem.Selected ? " selected=\"true\"" : String.Empty
                );
            }
            writer.Write("</select>");
        }
        
        private static string DefaultDivisionDropDownListTextFormatter(DivisionInfo divisionInfo) {
            return String.Format("{0} ({1})", divisionInfo.DivisionName, divisionInfo.DivisionCode);
        }

        public static string ToXmlString(this IDictionary<string, DivisionInfo> divisions) {
            StringBuilder xmlWriter = new StringBuilder();
            xmlWriter.Append("<ROOT>");
            foreach (var divisionInfo in divisions) {
                xmlWriter.AppendFormat("<Division>{0}</Division>", divisionInfo.Value.DivisionCode.HtmlEncode());
            }
            xmlWriter.Append("</ROOT>");

            return xmlWriter.ToString();
        }
    }

    //TODO:move to X
    public static class ListExtensions {
        public static List<ListItem> ToListItem<T>(this IEnumerable<T> items, Func<T, string> textFormatter, Func<T, string> valueFormatter, Func<T, bool> selectItemDelegate = null) {
            var list = items
                .Select(item => new ListItem(textFormatter(item), valueFormatter(item)) {
                    Selected = selectItemDelegate == null ? false : selectItemDelegate(item)
                })
                .ToList();
            return list;
        }
    }
}

