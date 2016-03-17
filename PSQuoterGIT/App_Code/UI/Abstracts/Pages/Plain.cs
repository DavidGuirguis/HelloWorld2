using System;

namespace UI.Abstracts.Pages
{
	/// <summary>
	/// Summary description for Plain.
	/// </summary>
	public abstract class Plain: UI.Abstracts.PageBase {
	    public Plain(string templateName = null) {
            DefaultMasterPageFile = GetTemplateFile(templateName ?? "Plain");  //_base
	    }
	}
}
