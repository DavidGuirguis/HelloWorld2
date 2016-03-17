<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Notes.ascx.cs" Inherits="Modules_Quote_Controls_Notes" %>
<div class="SegmentNotes">
    <div>
        
        <asp:Literal ID="litNotesList" runat="server"></asp:Literal>
        <% if (SegmentEdit && (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Notes.MultiLineEdit.Show"))) //<!--CODE_TAG_103339-->
           { %>
        <table width="100%">
            <tr>
            <td>
                 <img alt="" id="img<%=Section %>First" src='../../Library/Images/first_arrow.png' onclick="SegmentNoteFirst('<%=Section %>');" />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <img alt="" id="img<%=Section %>Previous" src='../../Library/Images/previous_arrow.png'
                        onclick="SegmentNotePrevious('<%=Section %>');" />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <img alt="" id="img<%=Section %>Next" src='../../Library/Images/next_arrow.png' onclick="SegmentNoteNext('<%=Section %>');" />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <img alt="" id="img<%=Section %>Last" src='../../Library/Images/last_arrow.png' onclick="SegmentNoteLast('<%=Section %>');" />

            </td>
                <td class="tAr">
                    <img  alt="" id="img<%=Section %>Add" src='../../Library/Images/plus_icon.png' onclick="SegmentNoteAdd('<%=Section %>');" />
                </td>
            </tr>
        </table>
        <% } %>
    </div>
</div>
<script type="text/javascript">
    var <%=Section %>Offset = 0;
    var <%=Section %>RowsCount = <%= RowsCount %>;
    var <%=Section %>Notes = '<%= Notes %>';
    var <%=Section %>MasterIndicators = '<%= MasterIndicators %>';

    function note_onkeyup(node){
      var prefix ="";
      var ix = 0; 
      if ($(node).val().length>= 50)
      {  
              if (node.id.indexOf("txtExternalNotesNote") >= 0)
                 prefix = "txtExternalNotesNote";
              else
                prefix = "txtInstructionsNote";
              ix = parseInt(node.id.replace(prefix, ""));
              processTheLastWord(ix, prefix);  // <CODE_TAG_104430>

              //ix ++;
      
              //$("#" + prefix + ix).focus();
        }

        pageDataChanged = true;
    }

    // <CODE_TAG_104430>
    function processTheLastWord(nodeIndex, prefix) {
        
        var lastWord = "";
        var textVal = "";
        textVal = $("#" + prefix + nodeIndex).val();
        var pos = textVal.lastIndexOf(" "); //the position of last " " in the textbox
        var lengthOfString = textVal.length; //the text length of the textbox
        lastWord = textVal.substring(pos + 1, lengthOfString); //last word
        var textVal2 = textVal.substring(0, pos + 1); //remove the last word
        $("#" + prefix + nodeIndex).val(textVal2); //the current line get the last word removed
        $("#" + prefix + (nodeIndex + 1)).focus();
        $("#" + prefix + (nodeIndex + 1) ).val(lastWord); //put the last word to the next line

    }
    // </CODE_TAG_104430>
    
    //<CODE_TAG_102130>
    function note_defaultChecked(node){
      var prefix1 ="";
      var prefix2 ="";
      var ix = 0;

            if (node.id.indexOf("txtExternalNotesNote") >= 0)
            {
                prefix1 = "chkExternalNotesMasterIndicatorInternal";
                prefix2 = "chkExternalNotesMasterIndicatorExternal";
                ix = parseInt(node.id.replace("txtExternalNotesNote", ""));

                if ($("#" + prefix1 + ix).prop("checked")==false && $("#" + prefix2 + ix).prop("checked")==false)

                {
                    
                    //$("#" + prefix1 + ix).prop("checked", true);
                    //$("#" + prefix2 + ix).prop("checked", true);
                    //<CODE_TAG_105075>
                    <%
                        string noteDefaultTypeInd = AppContext.Current.AppSettings["psQuoter.Quote.Segment.Note.DefaultAs"].ToString();  //1: Internal 2: External 3: Both
                        if (noteDefaultTypeInd == "1") //to select "Internal" checkbox 
                        { %>
                            $("#" + prefix1 + ix).prop("checked", true);
                        <%}
                        else if (noteDefaultTypeInd == "2") //to select "External" checkbox 
                        { %>
                            $("#" + prefix2 + ix).prop("checked", true);
                        <%}
                        else if (noteDefaultTypeInd == "3") //to select both "Internal" and "External" checkbox 
                        { %>
                            $("#" + prefix1 + ix).prop("checked", true);
                            $("#" + prefix2 + ix).prop("checked", true);
                    <%  } %>
                    //<CODE_TAG_105075>

                }
                
            }
 
        pageDataChanged = true;
    }
    //</CODE_TAG_102130>
    //<CODE_TAG_103339>
    function toggleDisplayMultilineExternalNote()
    {

        if ($("#inputCbxMultiLineNoteTypeSelected").prop("checked"))
           {
            $("#divInternalMultilineNote").hide();

            //$("#selectedNoteTypeDesc").text("External Note Only");
           }
        else
           {
            $("#divInternalMultilineNote").show();

            //$("#selectedNoteTypeDesc").text("Internal Notes");
            //$("#txtExternalNotesINotes").val($("#txtExternalNotesNotes").val()); //<Ticket 27307>
            

           }

    }
    //</CODE_TAG_103339>



</script>
