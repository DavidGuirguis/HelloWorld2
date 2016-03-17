using System;

namespace UI.Abstracts.Pages
{
	/// <summary>
	/// Summary description for Popup.
	/// </summary>
	public abstract class Popup : Plain {
		#region Private Variables
		private string _openerUrlField = "__openerUrl";
		private string _openerUrl = null;
		#endregion

	    public Popup()
	    {
            DefaultMasterPageFile = GetTemplateFile("Popup");
        }
	    
		#region Properties

		#region OpenerUrl 
		public string OpenerUrl {
			get { return _openerUrl; }
		}
		#endregion
		#endregion

		protected override void OnInit(EventArgs e) {
			base.OnInit (e);

			#region Opener Url
			ClientScript.RegisterHiddenField(_openerUrlField, Request.Form[_openerUrlField]);			
			ClientScript.RegisterClientScriptBlock(this.GetType(), "_openerUrl", "try{document.getElementById('" + _openerUrlField + "').value = opener.document.location.href;}catch(e){}", true);

			_openerUrl	= Request.Form[_openerUrlField];
			#endregion
		}

		#region RefreshOpener
		public enum RefreshOpenerAction {
			None,
			CloseWindow,
			RemoveFormPost
		}

		public void RefreshOpener() {
			RefreshOpener(RefreshOpenerAction.None, null, string.Empty);
		}

		public void RefreshOpener(RefreshOpenerAction action) {
			RefreshOpener(action, null, string.Empty);
		}

		public void RefreshOpener(RefreshOpenerAction action, string newOpenerUrl) {
			RefreshOpener(action, newOpenerUrl, string.Empty);
		}

		public void RefreshOpener(string newOpenerUrl, string additionalScript) {
			RefreshOpener(RefreshOpenerAction.None, newOpenerUrl, additionalScript);
		}

		public void RefreshOpener(string additionalScript) {
			RefreshOpener(RefreshOpenerAction.None, null, additionalScript);
		}

		public void RefreshOpener(RefreshOpenerAction action, string newOpenerUrl, string additionalScript) {
			string actionScript = null;

			// resolve action script
			switch(action) {
				case RefreshOpenerAction.None:
					break;
				case RefreshOpenerAction.CloseWindow:
					actionScript	= "window.close();";
					break;
				case RefreshOpenerAction.RemoveFormPost:
					actionScript	= "document.location.href = document.location.href;" + Environment.NewLine;
					break;
			}

			// construct opener url
			if(newOpenerUrl == null) 
				newOpenerUrl = "opener.document.location.href";
			else
				newOpenerUrl = "\"" + newOpenerUrl + "\"";

			ClientScript.RegisterStartupScript(
				this.GetType(),
				"refresh", 
				additionalScript + @"
				try {
					opener.document.location.href = " + newOpenerUrl  + @";
				} catch(e) {
				}
				" + actionScript,
				true
				);
		}
		#endregion

		#region CloseWindow
		public void CloseWindow() {
			ClientScript.RegisterStartupScript(this.GetType(), "closeWin", "window.close();", true);
		} // CloseWindow
		#endregion
	}
}
