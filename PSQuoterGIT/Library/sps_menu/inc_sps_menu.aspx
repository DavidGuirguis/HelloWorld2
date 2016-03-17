<%@ Import Namespace = "ADODB" %>
<script language="C#" runat="server">

    void WriteSpsMenuHeader() 
    {
        Response.Write("<meta name=\"microsoft theme\" content=\"default\">\r\n");
        Response.Write("<" + "script language=javascript src=\"" + RelativeApplicationPath + "library/sps_menu/scripts/ie55up.js\">\r\n");
        Response.Write("</" + "script>\r\n");
        Response.Write("<LINK href=\"" + RelativeApplicationPath + "library/sps_menu/styles/Menu.css\" rel=stylesheet />\r\n");
        Response.Write("<LINK href=\"" + RelativeApplicationPath + "library/sps_menu/styles/ows.css\" rel=stylesheet />\r\n");
        Response.Write("<style>\r\n");
        Response.Write("	.ms-SrvMenuUI				{BEHAVIOR: url(\"" + RelativeApplicationPath + "library/sps_menu/behaviours/Menu.htc\")}\r\n");
        Response.Write("	.ms-HoverCellActiveDark		{background-color: #FEAF4F;}\r\n");
        Response.Write("</style>\r\n");
        Response.Write("<" + "script language=JavaScript type=text/JavaScript>\r\n");
        Response.Write("var L_Menu_BaseUrl = \"" + RelativeApplicationPath + "library/sps_menu/\";");
        Response.Write("var L_Menu_LCID=\"1033\";");
        Response.Write("var L_Menu_SiteTheme=\"\";");
        Response.Write("var ctxMnu_CurOpenMenuSrcElement = null;");
        Response.Write("function OpenMenu(MenuToOpen,SourceElement)");
        Response.Write("{");
        Response.Write("	try	{");
        Response.Write("		if (!MenuToOpen.isOpen() ");
        Response.Write("			|| (ctxMnu_CurOpenMenuSrcElement != null ");
        Response.Write("				&& ctxMnu_CurOpenMenuSrcElement != SourceElement");
        Response.Write("			)");
        Response.Write("		) {");
        Response.Write("			MenuToOpen.show(SourceElement, true,false);");
        Response.Write("			ctxMnu_CurOpenMenuSrcElement = SourceElement;");
        Response.Write("		}");
        Response.Write("	}");
        Response.Write("	catch(e)");
        Response.Write("	{");
        Response.Write("	}");
        Response.Write("}");
        Response.Write("</" + "script>");
    }

</script>
