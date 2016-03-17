using System;

namespace UI.Abstracts.Pages
{
	/// <summary>
	/// Summary description for FullGUI.
	/// </summary>
	public abstract class PrintPage: FullGUI
	{
	    public PrintPage(string templateName = null)
	    {
            DefaultMasterPageFile = GetTemplateFile(templateName ?? "Print");
        }
	}
}
