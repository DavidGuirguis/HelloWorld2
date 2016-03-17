<%@ Page Title="" Language="C#" MasterPageFile="~/Library/MasterPages/iFrame.master" AutoEventWireup="true" CodeFile="WaitingRedirect.aspx.cs" Inherits="ImportXMLFileParts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMP" Runat="Server">

 
    <div id="div_Waiting" style="position: absolute; left: 50%; top: 40%; display: ;">
        <img id="img_Waiting" src="../../../library/images/waiting.gif" />
    </div>
    <script type="text/javascript">

        $(function () {
            setTimeout("UpdateImg('img_Waiting','../../../library/images/waiting.gif');", 50);
            var redirectURL = "<%= RedirectURL %>";
            if (redirectURL != "")
                document.location.href = redirectURL;
        });

        function UpdateImg(ctrl, imgsrc) {
            $("#" + ctrl).attr("src", imgsrc);
        }
    </script>
    
</asp:Content>