<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SegmentRevisionComments.ascx.cs" Inherits="Modules_Quote_Controls_SegmentRevisionComments" %>
<div>
    <div id="divSegmentRevisionComments">
        <table>
            <tr>
                <td>Comment:</td>
            </tr>
            <tr>
                <td>
                    <span id="spnLabel">
                        <label id="lblSegmentRevisionComment"><%=SegmentRevisionComment%></label>                        
                    </span>
                    <span id="spnEdit">
                        <textarea id="txtSegmentRevisionComment" rows="4"><%=SegmentRevisionComment%></textarea>                        
                    </span>
                </td>
            </tr>
        </table>
    </div>
</div>

<script type="text/javascript">
    
</script>
