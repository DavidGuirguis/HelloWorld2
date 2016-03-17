using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Resources;
using System.Web;
using System.Web.UI.WebControls;
using X.Web.Extensions;
using X.Extensions;
using X;
using Helpers;
using Entities.AppState.Extensions;
using Enums;
using System.Data;

namespace Helpers {
    public static class SearchPaneHelper
    {
        private static readonly X.Web.ResourceManager Resource = new X.Web.ResourceManager(typeof(SearchPaneHelper));

        public static string SearchKeywordTypeItems(int? keywordTypeParam)
        {
            TextWriter writer = HttpContext.Current.Response.Output;
            string searchKeywordString = null;

            var keywordTypes = new List<ListItem> {
                
                new ListItem(Resource.GetString("rkDropDown_QuoteNo"), "1"),
                new ListItem(Resource.GetString("rkDropDown_QuoteDesc"), "13"),
                new ListItem(Resource.GetString("rkDropDown_CustNumber"), "2"),
                new ListItem(Resource.GetString("rkDropDown_CustName"), "3"),
                //new ListItem(Resource.GetString("rkDropDown_SalesRep"), "7"),
                new ListItem("Owner", "7"),
                //new ListItem(Resource.GetString("rkDropDown_EquipNum"), "7"),
                //new ListItem(Resource.GetString("rkDropDown_QuoteOriginator"), "12"),
                new ListItem("Creator", "12"),
                new ListItem(Resource.GetString("rkDropDown_Make"), "4"),
                new ListItem(Resource.GetString("rkDropDown_Model"), "5"),
                new ListItem(Resource.GetString("rkDropDown_SerialNum"), "6"),
                new ListItem(Resource.GetString("rkDropDown_WorkOrderNum"), "8"),
                //<CODE_TAG_101861>
                //new ListItem(Resource.GetString("rkDropDown_SegmentDesc"), "9"),
                //new ListItem(Resource.GetString("rkDropDown_HiddenSegmentDesc"), "10"),
                new ListItem(Resource.GetString("rkDropDown_UnitNumber"), "11")
                ,new ListItem(Resource.GetString("rkDropDown_Comment"), "14")
                ,new ListItem(Resource.GetString("rkDropDown_QuoteLevelNote"), "15")
                ,new ListItem(Resource.GetString("rkDropDown_SegmentLevelNote"), "16")
                ,new ListItem(Resource.GetString("rkDropDown_QuoteLevelInstruction"), "17")
                ,new ListItem(Resource.GetString("rkDropDown_SegmentLevelInstruction"), "18")
                //</CODE_TAG_101861>
            };

          
            var selectedKeywordType = keywordTypes.SingleOrDefault(i => i.Value == keywordTypeParam.ToString());

            if (selectedKeywordType != null)
            {
                selectedKeywordType.Selected = true;
            }

            foreach (var keywordType in keywordTypes)
            {
                searchKeywordString += String.Format("<option value=\"{0}\"{2}>{1}</option>",
                                                     /*0*/keywordType.Value,
                                                     /*1*/keywordType.Text.HtmlEncode(),
                                                     /*2*/keywordType.Selected ? " selected=\"true\"" : String.Empty);
            }

            return searchKeywordString;

        }


        public static string SearchOperatorTypeItems(int? operatorTypeParam)
        {
            TextWriter writer = HttpContext.Current.Response.Output;
            string searchOperatorString = null;

            var operatorTypes = new List<ListItem> {
                new ListItem(Resource.GetString("rkDropDown_Contains"), "2"),
                new ListItem(Resource.GetString("rkDropDown_Equals"), "0"),
                new ListItem(Resource.GetString("rkDropDown_StartsWith"), "1"),
            };

            var selectedOperatorType = operatorTypes.SingleOrDefault(i => i.Value == operatorTypeParam.ToString());

            if (selectedOperatorType != null)
            {
                selectedOperatorType.Selected = true;
            }

            foreach (var operatorType in operatorTypes)
            {
                searchOperatorString += String.Format("<option value=\"{0}\"{2}>{1}</option>",
                                                      /*0*/operatorType.Value,
                                                      /*1*/operatorType.Text.HtmlEncode(),
                                                      /*2*/operatorType.Selected ? " selected=\"true\"" : String.Empty);
            }

            return searchOperatorString;

        }


        public static string SearchTypeItems(string searchTypeParam)
        {
            TextWriter writer = HttpContext.Current.Response.Output;
            string searchTypeString = null;

            var searchTypes = new List<ListItem>{
                new ListItem(Resource.GetString("rkDropDown_AllDivisions"), "%")//,
                //new ListItem(Resource.GetString("rkDropDown_Agriculture"), "1"),
                //new ListItem(Resource.GetString("rkDropDown_BuildingConstProducts"), "2"),
                //new ListItem(Resource.GetString("rkDropDown_PowerSystems"), "3"),
                //new ListItem(Resource.GetString("rkDropDown_GeneralLine"), "4"),
                //new ListItem(Resource.GetString("rkDropDown_Forestry"), "5"),
                //new ListItem(Resource.GetString("rkDropDown_CATRentalStore"), "6"),
                //new ListItem(Resource.GetString("rkDropDown_RentalServices"), "7"),
                //new ListItem(Resource.GetString("rkDropDown_Truck"), "8")
            };

            var ds = DAL.Quote.QuoteListDivision();
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                searchTypes.Add(new ListItem(dr["divisionName"].AsString(), dr["division"].AsString( )));

            }


            var selectedSearchType =
                searchTypes.SingleOrDefault(i => i.Value == searchTypeParam)
                    ?? /*default option*/ searchTypes.SingleOrDefault(i =>
                    {
                        return false;
                    });

            if (selectedSearchType != null)
            {
                selectedSearchType.Selected = true;
            }

            foreach (var searchType in searchTypes)
            {
                searchTypeString += String.Format("<option value=\"{0}\"{2}>{1}</option>",
                    /*0*/searchType.Value,
                    /*1*/searchType.Text.HtmlEncode(),
                    /*2*/searchType.Selected ? " selected=\"true\"" : String.Empty
                    );
            }

            return searchTypeString;
        }



    }
}

