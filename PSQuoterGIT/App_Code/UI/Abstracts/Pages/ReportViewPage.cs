using System;

namespace UI.Abstracts.Pages
{
	/// <summary>
	/// Summary description for FullGUI.
	/// </summary>
	public abstract class ReportViewPage: FullGUI
	{
	    public ReportViewPage(string templateName = null)
	    {
            DefaultMasterPageFile = GetTemplateFile(templateName ?? "Report");
        }
	}
}
