using AppContext = Canam.AppContext;
using System;
using System.Activities.Statements;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using Entities;
using Enums;
using Microsoft.VisualBasic.ApplicationServices;
using Repositories;
using X;
using X.Extensions;
using X.Web.Entities;
using X.Web.Entities.Extensions;
using X.Web.Extensions;
using X.Web.Globalization;
using X.Web.UI;

namespace Helpers
{
    public static partial class LayoutHelper
    {
        private static void TopPaneSection(AppContext appContext, global::WebContext webContext, IPage page, bool sectionDefined, TextWriter writer)
        {
            var menu = new MenuItem(isRoot: true);
            var topMenuItems = new MenuItemGroup();
            menu.Groups.Add(topMenuItems);

            // Quotes 
            var topMenuItem =  topMenuItems.Add(new MenuItem { Text =  Resource.GetString("rkTopPaneMenuItem_Quotes"), ToolTip = Resource.GetString("rkTopPaneToolTip_Quotes"), Enabled = false});
            var topMenuItemGroup = topMenuItem.Groups;
            topMenuItemGroup.Add(new MenuItemGroup(new[] {new MenuItem {Text = Resource.GetString("rkTopPaneDropDownValue_Quote_List"), ToolTip = Resource.GetString("rkTopPaneToolTip_Quote_List"), NavigateUrl = "Modules/Quote/Quote_list.aspx",UrlParams = "F=1"}, }));


            if (AppContext.Current.User.Operation.CreateQuote)
            {
                var topMenuItemGroupsAdded = topMenuItemGroup.Add(new MenuItemGroup(new[]
                                                                                        {
                                                                                            new MenuItem
                                                                                                {
                                                                                                    Text =
                                                                                                        Resource.
                                                                                                        GetString(
                                                                                                            "rkTopPaneDropDownValue_New_Quote"),
                                                                                                    ToolTip =
                                                                                                        Resource.
                                                                                                        GetString(
                                                                                                            "rkTopPaneToolTip_New_Quote"),
                                                                                                    NavigateUrl =
                                                                                                        "Modules/Quote/Quote_AddNew.aspx"
                                                                                                }
                                                                                            //,  // NavigateUrl = "javascript:AddNewQuote();"
                                                                                            //new MenuItem {Text = Resource.GetString("rkTopPaneDropDownValue_Copy_Quote"), ToolTip = Resource.GetString("rkTopPaneToolTip_Copy_Quote"), NavigateUrl = "Modules/Quote/Copy_Quote.aspx",UrlParams = "Type=Q"}   
                                                                                        }));

                if (AppContext.Current.AppSettings.IsTrue("psQuoter.TopMenu.ShowNewQuoteFromWO"))
                    topMenuItemGroupsAdded.Add(
                                        new MenuItem
                                        {
                                            Text = "New Quote From WO",
                                            ToolTip = "New Quote From WO",
                                            NavigateUrl =
                                                "Modules/Quote/Quote_AddNew.aspx?copyfrom=WO"
                                        }
                                        );

                if (AppContext.Current.AppSettings.IsTrue("psQuoter.TopMenu.ShowLinkNewQuoteToWO"))
                        topMenuItemGroupsAdded.Add( 
                                        new MenuItem
                                        {
                                            Text = "Link New Quote To WO",
                                            ToolTip = "Link New Quote To WO",
                                            NavigateUrl =
                                                "Modules/Quote/Quote_AddNew.aspx?copyfrom=LINKWO"
                                        }
                                        );

                topMenuItemGroupsAdded.OwnerGroups.Add(new MenuItemGroup(new[]
                                                                             {
                                                                                 new MenuItem
                                                                                     {
                                                                                         Text =
                                                                                             Resource.GetString(
                                                                                                 "rkTopPaneMenuItem_Quote_Workflow_By_Branch"),
                                                                                         ToolTip =
                                                                                             Resource.GetString(
                                                                                                 "rkTopPaneToolTip_Quote_Workflow_By_Branch"),
                                                                                         NavigateUrl =
                                                                                             "Modules/Quote/Workflow/QuoteWorkflow.aspx",
                                                                                         UrlParams = "RptType=1"
                                                                                     },
                                                                                 new MenuItem
                                                                                     {
                                                                                         Text = "Workflow By Owner",
                                                                                         ToolTip ="Workflow By Owner",
                                                                                         NavigateUrl =
                                                                                             "Modules/Quote/Workflow/QuoteWorkflow.aspx",
                                                                                         UrlParams = "RptType=2"
                                                                                     }
                                                                             }));
            }

            //if (AppContext.Current.User.Operation.TRG)
            // {
            //   topMenuItems.Add(new MenuItem { Text = Resource.GetString("rkTopPaneMenuItem_TRG"), ToolTip =Resource.GetString("rkTopPaneToolTip_TRG"), NavigateUrl = "Modules/TRG_Search/WO_Summary.aspx" });
            // }

            // Repair Option
            //topMenuItems.Add(new MenuItem { Text = Resource.GetString("rkTopPaneMenuItem_Repair_Option"), ToolTip = Resource.GetString("rkTopPaneToolTip_Repair_Option"), NavigateUrl = "Modules/RepairOption/RepairOptions_ByModel.aspx" });
            topMenuItems.Add(new MenuItem { Text = "Standard Jobs", ToolTip = "Standard Jobs", NavigateUrl = "Modules/RepairOption/RepairOptions_ByModel.aspx" });


            if (AppContext.Current.User.Operation.Admin)
            {
                if (AppContext.Current.User.RoleBasedAuthEnabled)
                {
					//Admin  
					//<CODE_TAG_103543> Dav
					if (AppContext.Current.AppSettings.IsTrue("ckglobal.NotificationFramework.Enable"))
					{

						topMenuItems.Add(new MenuItem
						{
							Text = Resource.GetString("rkTopPaneMenuItem_Admin"),
							ToolTip = Resource.GetString("rkTopPaneToolTip_Admin")
						})
							.Groups.Add(new MenuItemGroup(new[]{
								new MenuItem{
									Text = Resource.GetString("rkTopPaneMenuItem_Manage_Users"),
									ToolTip = Resource.GetString("rkTopPaneToolTip_Manage_Users"),
									NavigateUrl = "javascript:manageUser();",
									},
								
								new MenuItem{
									Text = "Manage Notifications",
									ToolTip = "Manage Notifications",
									NavigateUrl = "modules/Admin/Notification/ManageNotifications.aspx",
									}
								
								}
							));
					}
					else
					{
						//</CODE_TAG_103543> Dav
						topMenuItems.Add(new MenuItem
						{
							Text = Resource.GetString("rkTopPaneMenuItem_Admin"),
							ToolTip = Resource.GetString("rkTopPaneToolTip_Admin")
						})
						.Groups.Add(new MenuItemGroup(new[]{
                            new MenuItem{
                                Text = Resource.GetString("rkTopPaneMenuItem_Manage_Users"),
                                ToolTip = Resource.GetString("rkTopPaneToolTip_Manage_Users"),
                                NavigateUrl = "javascript:manageUser();"
                            }
                        }));
					}//<CODE_TAG_103543> Dav

                    writer.Write(@"<script language=javascript>
	                                
                                    function manageUser(iAppId){{
		                                    var iWidth = 660, iHeight = 560;
		                                    var iLeft = (screen.width - iWidth)/2;
		                                    var iTop	= (screen.height - iHeight)/2;

		                                    var x = window.open(""{0}?businessEntityId={1}&appId={2}"", ""xmanageuser"", ""width="" + iWidth + "",height="" + iHeight + "",left="" + iLeft + "",top="" + iTop + "",scrollbars=yes,resizable=yes"");
		                                    x.focus();	
                    	             }}
                                    </script>",
                        /*0*/ConfigurationManager.AppSettings["url.ManageApp"],
                        /*1*/appContext.BusinessEntityId,
                        /*2*/AppContext.Current.ApplicationId);
                }
                else
                {
                    //Admin
                    topMenuItems.Add(new MenuItem { Text = Resource.GetString("rkTopPaneMenuItem_Admin"), ToolTip = Resource.GetString("rkTopPaneToolTip_Admin"), NavigateUrl = "Modules/Admin/default.aspx" });
                }
            }

            //Links
            //<CODE_TAG_101156>
            var menuItem = topMenuItems.Add(new MenuItem { Text = Resource.GetString("rkTopPaneMenuItem_Links"), ToolTip = Resource.GetString("rkTopPaneToolTip_Links") });
            //- My Applications
            menuItem.Groups.Add(new MenuItemGroup(new[] { new MenuItem { Text = Resource.GetString("rkTopPaneDropDownValue_My_Applications"), ToolTip = Resource.GetString("rkTopPaneToolTip_My_Applications"), NavigateUrl = ConfigurationManager.AppSettings["url.siteRootPath"] } }));
            // - Personalization
            menuItem.Groups.Add(new MenuItemGroup(new[] { new MenuItem { Text = Resource.GetString("rkTopPaneDropDownValue_Personalization"), ToolTip = Resource.GetString("rkTopPaneToolTip_Personalization"), NavigateUrl = "Modules/Personalization/default.aspx" } }));
            //</CODE_TAG_101156>

            //Help
            // <CODE_TAG_104643>
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.TopMenu.ShowHelp"))
            {
                menuItem.Groups.Add(new MenuItemGroup(new[] { new MenuItem { Text = "Help", ToolTip = "Help", NavigateUrl = "http://info.toromontcat.com/Default.aspx?DN=549568dc-3c3d-40b6-992e-b93a7320fd9b&l=English" } }));
            }
            // </CODE_TAG_104643>

            // PM Pricing
            //<CODE_TAG_101885> 

            if (AppContext.Current.AppSettings.IsTrue("psQuoter.TopMenu.ShowPMPricing"))
            {
                topMenuItems.Add(new MenuItem { Text = "PM Pricing", ToolTip = "PM Pricing", NavigateUrl = "http://kapur.toromontcat.com/PSQuoter/trg/default.asp?SID=%7B93F3255C%2DAF19%2D4B68%2D8B9F%2D055998DF2F09%7D&MP=modules%2FRepairOption%2FPMPricing%5FByModel%5FReport2%2Easp&LMENU=OFF&SEARCH=OFF" });
            }
            //</CODE_TAG_101885> 
            menu.Render(MenuRenderType.Horizontal, writer);
        }
    }
}

