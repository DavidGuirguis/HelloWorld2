using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using DTO;
using CATPAI;
using Entities;
using X.Extensions;
using System.Data;

public partial class ImportXMLFileParts : UI.Abstracts.Pages.Plain
{
    protected string RedirectURL = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        RedirectURL = Request.QueryString["RdURL"].AsString("");
    }

   
}

