using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Helpers;

namespace UI.Abstracts
{
	/// <summary>
	/// Summary description for PageBase.
	/// </summary>
    public abstract class PageBase : X.Web.UI.PageBase<WebContext, MasterPageBase>
	{
        //NOTE:Changes for legacy
        public bool IsLegacyPage { get; set; }

        //NOTE:Changes for legacy
        protected override void Render(HtmlTextWriter writer) {
            base.Render(writer);

            //Module title fixup
            if (IsLegacyPage) {
                writer.Write(String.Format(@"
<script type=""text/javascript"">
var oModuleTitleContainer = document.getElementById('moduleTitleContainer');
if(oModuleTitleContainer != null) oModuleTitleContainer.innerHTML = ""{0}"";

document.title = ""{1}"";
</script>", HttpUtility.JavaScriptStringEncode(ModuleTitle), HttpUtility.JavaScriptStringEncode(FormatPageTitle())));    
            }
        }

		#region Overridden Methods 

	    public override string FormatPageTitle() {
			return LayoutHelper.FormatTitle(PageTitle, ModuleTitle);
		}

		protected override void RenderHtmlHeader(HtmlTextWriter writer){
		}

		protected override string GetTemplateFile(string templateName) {
            //NOTE:Changes for legacy
            this.TemplateName = templateName;//TODO:move to X dll

            //TODO: simplify logic to eliminate duplicate logic in PreInit event
            if(IsLegacyPage) {
                if (0 == String.Compare(templateName, "_base", StringComparison.InvariantCultureIgnoreCase)) {
                    templateName = "Legacy";
                }
                else {
                    templateName += "Legacy";
                }
            }

			return "~/library/masterPages/" 
                + templateName
                + ".master";
		}
		#endregion

        protected override void OnPreInit(EventArgs e) {
            if (IsLegacyPage && !DefaultMasterPageFile.EndsWith("legacy.master", StringComparison.InvariantCultureIgnoreCase)) {
                //TODO: simplify logic to eliminate duplicate logic in PreInit event
                if (DefaultMasterPageFile.EndsWith("_base.master", StringComparison.InvariantCultureIgnoreCase)) {
                    DefaultMasterPageFile = DefaultMasterPageFile.Substring(0, DefaultMasterPageFile.Length - 12) + "_legacy.master";
                } 
                else {
                    DefaultMasterPageFile = DefaultMasterPageFile.Substring(0, DefaultMasterPageFile.Length - 7) + "Legacy.master";
                }
            }

            // Set theme
            this.Theme = LayoutHelper.GetThemeName();

            base.OnPreInit(e);
        }

	    protected void SendNotification(bool blnLogNotificationSent, int? iNewQuoteId, int? sNewQuoteNo, string sType, string sCustomerNo, string sCustName, string sDivision)
	    {
	        //throw new NotImplementedException();
	    }
	}
}
