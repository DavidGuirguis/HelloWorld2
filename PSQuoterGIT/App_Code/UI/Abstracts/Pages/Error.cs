using System;

namespace UI.Abstracts.Pages
{
	/// <summary>
	/// Summary description for Plain.
	/// </summary>
	public abstract class Error: UI.Abstracts.PageBase
	{
        public Error()
        {
            DefaultMasterPageFile = GetTemplateFile("Error");
        }	
	}
}
