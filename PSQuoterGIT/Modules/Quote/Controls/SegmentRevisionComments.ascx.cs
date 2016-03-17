using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using X;
using X.Extensions;
using X.Web.Extensions;
using X.Web.UI.WebControls;
using Entities;
using Helpers;

public partial class Modules_Quote_Controls_SegmentRevisionComments : System.Web.UI.UserControl
{
    protected string SegmentRevisionComment;
    protected void Page_Load(object sender, EventArgs e)
    {
        SegmentRevisionComment = "test";
    }
}