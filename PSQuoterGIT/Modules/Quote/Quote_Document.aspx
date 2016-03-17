<%@ Page Title="" Language="C#" MasterPageFile="~/Library/MasterPages/_base.master"
    AutoEventWireup="true" CodeFile="Quote_Document.aspx.cs" Inherits="Modules_Quote_Document" %>

<%@ Import Namespace="System.Data" %>
<%@ Register Src="Controls/QuoteHeader.ascx" TagName="QutoeHeader" TagPrefix="uc1" %>
<asp:Content ID="Content5" ContentPlaceHolderID="cntMP" runat="Server">
    <uc1:QutoeHeader ID="quoteHeader" runat="server"></uc1:QutoeHeader>
    <table width="100%">
        <tr class="reportHeader">
            <td class="tCb">
                Customer
            </td>
            <td class="tCb">
                Segments
            </td>
            <td class="tCb">
                Internal<!--CODE_TAG_105435-->
            </td>
            <td class="tCb">
                Customer<!--CODE_TAG_105435-->
            </td>
             <td class="tCb" style="display:none"><!--CODE_TAG_103368-->
                Email
            </td>
            <td class="tAr">
             <% if ( CanModify )  %>
                <asp:LinkButton ID="linkPrintConfig" runat="server" OnClick="linkPrintConfig_Click">Edit Document Layout</asp:LinkButton>
             <% %>
            </td>
        </tr>
        <%// <CODE_TAG_101481> %>
        <asp:Repeater ID="repCustomers" runat="server">
            <ItemTemplate>
                <tr class="reportContentOddRow">
                    <td>
                        <asp:Label ID="lblCustomer" Text='<%# ((DataRowView) Container.DataItem)["CustomerNo"].ToString() +   (   (((DataRowView) Container.DataItem)["CustomerNo"].ToString()=="")?"": " - "   ) +  ((DataRowView) Container.DataItem)["CustomerName"].ToString() %> '
                            runat="server"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="lblUse" Text='<%# ((DataRowView) Container.DataItem)["Uses"].ToString()  %> '
                            runat="server"></asp:Label>
                    </td>
                    <td>
                        <!--CODE_TAG_105435--><!--Internal Icons Begin-->
                        <a href="javascript:print('Pdf','<%# ((DataRowView) Container.DataItem)["CustomerNo"].ToString() %>' , 1)"> <img src="../../Library/images/icon_doctype_pdf.gif" title="Internal PDF Document" /></a>
                        <!--CODE_TAG_104248--><!--control to hide the interanl word document output-->
                        <% if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Print.Document.Format.Word.Hide.Internal")) {%>
                        <a href="javascript:print('Word','<%# ((DataRowView) Container.DataItem)["CustomerNo"].ToString() %>' , 1)"> <img src="../../Library/images/icon_doctype_word.gif"  title="Internal Word Document" /></a>
                        <% } %>
                        <!--/CODE_TAG_104248-->
                        <a href="javascript:print('Email','<%# ((DataRowView) Container.DataItem)["CustomerNo"].ToString() %>' , 1)"> <img src="../../Library/images/email.png"  title="Internal Email"  /></a><!--CODE_TAG_103368-->
                        <!--Internal Icons End--><!--/CODE_TAG_105435-->
                    </td>
                    <td>
                        <!--CODE_TAG_105435--><!--Customer Icons Begin-->
                        <a href="javascript:print('Pdf','<%# ((DataRowView) Container.DataItem)["CustomerNo"].ToString() %>' , 0)"> <img src="../../Library/images/icon_doctype_pdf.gif"  title="Customer PDF Document" /></a>
                        <!--CODE_TAG_104248--><!--control to hide the customer word document output-->
                        <% if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Print.Document.Format.Word.Hide.Customer"))  {%>
                        <a href="javascript:print('Word','<%# ((DataRowView) Container.DataItem)["CustomerNo"].ToString() %>' , 0)"> <img src="../../Library/images/icon_doctype_word.gif"  title="Customer Word Document" /></a>
                        <%} %>
                        <!--/CODE_TAG_104248--><!--/CODE_TAG_105435-->
                        <a href="javascript:print('Email','<%# ((DataRowView) Container.DataItem)["CustomerNo"].ToString() %>' , 0)"> <img src="../../Library/images/email.png"  title="Customer Email"  /></a><!--CODE_TAG_103368-->
                        <!--Customer Icons End--><!--/CODE_TAG_105435-->	
                    </td>
                    <td style="display:none"><!--CODE_TAG_103368-->
                    </td>
                    <td></td>
                </tr>
            </ItemTemplate>
            <AlternatingItemTemplate>
                <tr class="reportContentEvenRow">
                    <td>
                        <asp:Label ID="lblCustomer" Text='<%# ((DataRowView) Container.DataItem)["CustomerNo"].ToString() +   (   (((DataRowView) Container.DataItem)["CustomerNo"].ToString()=="")?"": " - "   ) +  ((DataRowView) Container.DataItem)["CustomerName"].ToString() %> '
                            runat="server"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="lblUse" Text='<%# ((DataRowView) Container.DataItem)["Uses"].ToString()  %> '
                            runat="server"></asp:Label>
                    </td>
                    <td>
                        <!--CODE_TAG_105435--><!--Internal Icons Begin-->
                        <a href="javascript:print('Pdf','<%# ((DataRowView) Container.DataItem)["CustomerNo"].ToString() %>' , 1)"> <img src="../../Library/images/icon_doctype_pdf.gif"  title="Internal PDF Document"/></a>
                        <!--CODE_TAG_104248--><!--control to hide the interanl word document output-->
                        <% if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Print.Document.Format.Word.Hide.Internal")) {%>
                        <a href="javascript:print('Word','<%# ((DataRowView) Container.DataItem)["CustomerNo"].ToString() %>' , 1)"> <img src="../../Library/images/icon_doctype_word.gif" title="Internal Word Document"  /></a>
                        <% } %>
                        <!--/CODE_TAG_104248-->
                        <a href="javascript:print('Email','<%# ((DataRowView) Container.DataItem)["CustomerNo"].ToString() %>' , 1)"> <img src="../../Library/images/email.png" title="Internal Email" /></a><!--CODE_TAG_103368-->
                        <!--Internal Icons End--><!--/CODE_TAG_105435-->
                    </td>
                    <td>
                        <!--CODE_TAG_105435--><!--Customer Icons Begin-->
                        <a href="javascript:print('Pdf','<%# ((DataRowView) Container.DataItem)["CustomerNo"].ToString() %>' , 0)"> <img src="../../Library/images/icon_doctype_pdf.gif"  title="Customer PDF Document"/></a>
                        <!--CODE_TAG_104248--><!--control to hide the customer word document output-->
                        <% if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Print.Document.Format.Word.Hide.Customer"))  {%>
                        <a href="javascript:print('Word','<%# ((DataRowView) Container.DataItem)["CustomerNo"].ToString() %>' , 0)"> <img src="../../Library/images/icon_doctype_word.gif"  title="Customer Word Document"/></a>
                        <%} %>
                        <!--/CODE_TAG_104248-->
                        <a href="javascript:print('Email','<%# ((DataRowView) Container.DataItem)["CustomerNo"].ToString() %>' , 0)"> <img src="../../Library/images/email.png" title="Customer Email" /></a><!--CODE_TAG_103368-->
                        <!--Customer Icons End--><!--/CODE_TAG_105435-->
                    </td>
                    <td style="display:none"><!--CODE_TAG_103368-->
                    </td>
                    <td></td>
                </tr>
            </AlternatingItemTemplate>
            
        </asp:Repeater>
    </table>
     <%// </CODE_TAG_101481> %>
    <br />
    <br />
    <br />
    <br />
    <asp:Button ID="btnfpNew" Text="New" runat="server" OnClientClick="HideAddDocumentButton(); return false;" />
    <table id="tblAddDocument" style="display: none;">
        <tr>
            <td class="t12b">
                File:
            </td>
            <td>
                <asp:FileUpload ID="fuDocument" runat="server" Width="300px" />
            </td>
        </tr>
        <tr>
            <td class="t12b">
                Description:
            </td>
            <td>
                <asp:TextBox ID="txtDescription" runat="server" Width="300px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:Button ID="btnfpUpload" Text="Upload" runat="server" OnClick="btnfpUpload_Click" />
                <asp:Button ID="btnfpCancel" Text="Cancel" runat="server" OnClientClick="ShowAddDocumentButton(); return false;" />
            </td>
        </tr>
    </table>
    <script language="javascript">
        function ShowAddDocumentButton() {
            $j('#<%=btnfpNew.ClientID %>').show();
            $j('#tblAddDocument').hide();
        }

        function HideAddDocumentButton() {
            $j('#<%=btnfpNew.ClientID %>').hide();
            $j('#tblAddDocument').fadeIn();
        }
    </script>
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table class="documentsList" cellspacing="0">
                <tr>
                    <th style="width: 30%; color:black">
                        File Name
                    </th>
                    <th style="width: 50%; color:black">
                        Description
                    </th>
                    <th style="width: 10%; color:black">
                        Updated On
                    </th>
                    <th style="width: 10%; color:black">
                    </th>
                </tr>
                <asp:Repeater ID="repDocuments" runat="server" OnItemDataBound="repDocuments_ItemDataBound">
                    <HeaderTemplate>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr class="reportContentOddRow">
                            <td>
                                <a href="javascript:downloadDocument('<%# ((DataRow) Container.DataItem)["imageId"] %>'); ">
                                    <%# ((DataRow) Container.DataItem)["FileName"] %>
                                </a>
                            </td>
                            <td>
                                <asp:Label ID="lblDescription" Text='<%# ((DataRow) Container.DataItem)["Description"] %>'
                                    runat="server"></asp:Label>
                                <asp:TextBox ID="txtDescription" Text='<%# ((DataRow) Container.DataItem)["Description"] %>'
                                    runat="server" Style="width: 95%"></asp:TextBox>
                            </td>
                            <td>
                                <asp:Label ID="lblUpdatedOn" Text='<%#  DateTimeHelper.FormatDate(((DataRow) Container.DataItem)["ChangeDate"].AsDateTime( )  ) %>'
                                    runat="server"></asp:Label>
                            </td>
                            <td>
                                <asp:Button ID="btnEdit" Text="Edit" runat="server" OnClick="btnEdit_Click" />
                                <asp:Button ID="btnDelete" Text="Delete" runat="server" OnClientClick="return confirmDeleteFile();"
                                    OnClick="btnDelete_Click" />
                                <asp:Button ID="btnSave" Text="Save" runat="server" OnClick="btnSave_Click" />
                                <asp:Button ID="btnCancel" Text="Cancel" runat="server" />
                            </td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                        <tr class="reportContentEvenRow">
                            <td>
                                <a href="javascript:downloadDocument('<%# ((DataRow) Container.DataItem)["imageId"] %>'); ">
                                    <%# ((DataRow) Container.DataItem)["FileName"] %>
                                </a>
                            </td>
                            <td>
                                <asp:Label ID="lblDescription" Text='<%# ((DataRow) Container.DataItem)["Description"] %>'
                                    runat="server"></asp:Label>
                                <asp:TextBox ID="txtDescription" Text='<%# ((DataRow) Container.DataItem)["Description"] %>'
                                    runat="server" Style="width: 95%"></asp:TextBox>
                            </td>
                            <td>
                                <asp:Label ID="lblUpdatedOn" Text='<%#  DateTimeHelper.FormatDate(((DataRow) Container.DataItem)["ChangeDate"].AsDateTime( )  ) %>'
                                    runat="server"></asp:Label>
                            </td>
                            <td>
                                <asp:Button ID="btnEdit" Text="Edit" runat="server" OnClick="btnEdit_Click" />
                                <asp:Button ID="btnDelete" Text="Delete" runat="server" OnClientClick="return confirmDeleteFile();"
                                    OnClick="btnDelete_Click" />
                                <asp:Button ID="btnSave" Text="Save" runat="server" OnClick="btnSave_Click" />
                                <asp:Button ID="btnCancel" Text="Cancel" runat="server" />
                            </td>
                        </tr>
                    </AlternatingItemTemplate>
                    <FooterTemplate>
                    </FooterTemplate>
                </asp:Repeater>
            </table>
        </ContentTemplate>
        <Triggers>
        </Triggers>
    </asp:UpdatePanel>
    <asp:HiddenField ID="hdnDownloadFileId" Value="" runat="server" ClientIDMode="Static" />
    <asp:Button ID="btnDownload" Text="download" runat="server" ClientIDMode="Static"
        OnClick="btnFileDownload_Click" Style="display: none" />
    <script type="text/javascript">
        function downloadDocument(strFileId) {
            $("#hdnDownloadFileId").val(strFileId);
            var btn = document.getElementById("btnDownload");
            btn.click();
        }

        function confirmDeleteFile() {
            if (confirm("Are you sure to delete this file?")) {
                return true;
            }
            else {
                return false;
            }
        }

        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
        function EndRequestHandler() {
            _initPage();
        }
    </script>
</asp:Content>
