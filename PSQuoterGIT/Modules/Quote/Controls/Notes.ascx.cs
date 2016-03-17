using AppContext = Canam.AppContext;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using CATPAI;
using DTO;
using X;
using X.Extensions;
using X.Web.Extensions;
using X.Web.UI.WebControls;
using Entities;

public partial class Modules_Quote_Controls_Notes: System.Web.UI.UserControl
{
    protected bool SegmentEdit = false;
    protected int RowsCount = 0;
    protected string Section = "";
    protected string Notes = "";
    protected string MasterIndicators = "";

    protected void Page_Load(object sender, EventArgs e)
    {
    }
    public void Bind(string section, IEnumerable<DataRow> rsNotes, int rowsCount, bool SegmentEditble)  
    {
        SegmentEdit = SegmentEditble;
        RowsCount = rowsCount;
        Section = section;

        StringBuilder sb = new StringBuilder();

        int tabOffset = 2000;
        if (section == "Instructions")
            tabOffset = 3000;

        if (SegmentEditble)
        {
            sb.Append("<table width='100%' class='segmentNote' id='table" + section + "' width='100%' cellpadding='0' cellspacing='0'  >");
            sb.Append("<tr>");
            sb.Append("<th class='tAl' style='width:5%;font-weight:bolder;'>&nbsp;No</th>");
            sb.Append("<th class='tAc' style='width:30%;font-weight:bolder;'>Notes</th>");
            sb.Append("<th class='tAc' style='width:5%;font-weight:bolder;'>" + ((section == "Instructions") ? "" : "I") + "</th>");
            sb.Append("<th class='tAc' style='width:5%;font-weight:bolder;'>" + ((section == "Instructions") ? "" : "E") + "</th>");
            sb.Append("<th class='tAc' style='width:5%;font-weight:bolder;'></th>");
            sb.Append("<th class='tAl' style='width:5%;font-weight:bolder;'>&nbsp;No</th>");
            sb.Append("<th class='tAc'style='width:30%;font-weight:bolder;'>Notes</th>");
            sb.Append("<th class='tAc' style='width:5%;font-weight:bolder;'>" + ((section == "Instructions") ? "" : "I") + "</th>");
            sb.Append("<th class='tAc' style='width:5%;font-weight:bolder;'>" + ((section == "Instructions") ? "" : "E") + "</th>");
            sb.Append("<th class='tAc' style='width:5%;font-weight:bolder;'></th>");
            sb.Append("</tr>");
            for (int i = 1; i <= rowsCount; i++)
            {
                sb.Append("<tr >");
                sb.Append("<td ><span id='span" + section + "Number" + i + "'> </span></td>");
                //!!sb.Append("<td><input id='txt" + section + "Note" + i + "'  onkeyup='note_onkeyup(this);' TabIndex='" + (tabOffset + i * 3) + "' maxlength='50' class='w98p'  /> </td>");
                sb.Append("<td><input id='txt" + section + "Note" + i + "'  onkeyup='note_onkeyup(this);note_defaultChecked(this);' TabIndex='" + (tabOffset + i * 3) + "' maxlength='50' class='w98p'  /> </td>");//<CODE_TAG_102130>
                sb.Append("<td class='tAc'><input  type='checkbox'  id='chk" + section + "MasterIndicatorInternal" + i + "' TabIndex='" + (tabOffset + i * 3 + 1) + "' style='display:" + ((section == "Instructions") ? "none" : "") + ";' ></input></td><td class='tAc'>   <input type='checkbox' id='chk" + section + "MasterIndicatorExternal" + i + "' TabIndex='" + (tabOffset + i * 3 + 2) + "' style='display:" + ((section == "Instructions") ? "none" : "") + ";'  > </input>  </td>");
                sb.Append("<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>");

                sb.Append("<td><span id='span" + section + "Number" + (i + rowsCount) + "'> </span></td>");
                //!!sb.Append("<td><input id='txt" + section + "Note" + (i + rowsCount) + "' onkeyup='note_onkeyup(this);' TabIndex='" + (tabOffset + (i + rowsCount) * 3) + "' maxlength='50' class='w98p' /> </td>");
                sb.Append("<td><input id='txt" + section + "Note" + (i + rowsCount) + "' onkeyup='note_onkeyup(this);note_defaultChecked(this);' TabIndex='" + (tabOffset + (i + rowsCount) * 3) + "' maxlength='50' class='w98p' /> </td>");//<CODE_TAG_102130>
                sb.Append("<td class='tAc'><input type='checkbox' id='chk" + section + "MasterIndicatorInternal" + (i + rowsCount) + "' TabIndex='" + (tabOffset + (i + rowsCount) * 3 + 1) + "' style='display:" + ((section == "Instructions") ? "none" : "") + ";'  ></input></td><td class='tAc'>  <input type='checkbox' id='chk" + section + "MasterIndicatorExternal" + (i + rowsCount) + "' TabIndex='" + (tabOffset + (i + rowsCount) * 3 + 2) + "' style='display:" + ((section == "Instructions") ? "none" : "") + ";'  ></input>  </td>");
                sb.Append("<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>");
                sb.Append("</tr>");
            }

            sb.Append("</table>");
       
            //notes
            if (rsNotes != null)
            {
                foreach (DataRow dr in rsNotes)
                {
                    if (Notes != "") Notes += ((char)5).ToString();
                    if (MasterIndicators != "") MasterIndicators += ((char)5).ToString();

                    //Notes +=   dr["Notes"].ToString().JavaScriptStringEncode();
                    //Notes += dr["Notes"].ToString().HtmlDecode(); //<CODE_TAG_103922>
                    //Notes += dr["Notes"].ToString(); //<CODE_TAG_103922>
                    Notes += dr["Notes"].ToString().HtmlEncode(); ; //<CODE_TAG_103922>
                    MasterIndicators += dr["MasterIndicator"].ToString();
                }
            }
        }
        else
        {
            if (rsNotes != null)
            {
                string masterIndicatorDesc = "";
                int readonlyRowsCount = Math.Ceiling(  rsNotes.Count().AsDecimal()   / 2) .AsInt() ;
                sb.Append("<table width='100%' class='segmentNote' id='table" + section + "' width='100%' cellpadding='0' cellspacing='0'  >");
                for (int i = 1; i <= readonlyRowsCount; i++)
                {
                    DataRow dr;
                    sb.Append("<tr>");
                    string sI = i.ToString();
                    if (sI.Length == 2) sI = "0" + sI;
                    if (sI.Length == 1) sI = "00" + sI;
                    sb.Append("<td style='width:5%'>" + sI + ((section == "Instructions" && i< 5) ?"*":""  ) + "</td>");
                    dr = rsNotes.Skip(i -1).FirstOrDefault( );

                    //sb.Append("<td style='width:35%'>" + dr["Notes"].ToString() + "</td>");
                    sb.Append("<td style='width:35%'>" + dr["Notes"].ToString().HtmlEncode() + "</td>");  //<CODE_TAG_103922>
                    if (section == "Instructions")
                        sb.Append("<td style='width:5%'></td>");
                    else
                    {
                        switch (dr["masterIndicator"].ToString())
                        {
                            case "I": 
                                masterIndicatorDesc = "I"; 
                                break;
                            case "B": 
                                masterIndicatorDesc = "B"; 
                                break;
                            default:  
                                masterIndicatorDesc = "E"; 
                                break;
                        }

                        sb.Append("<td style='width:5%'> (" + masterIndicatorDesc + ")</td>");
                    }
                    sb.Append("<td style='width:5%'>&nbsp;&nbsp;&nbsp;&nbsp;</td>");

                    if (i + readonlyRowsCount <= rsNotes.Count())
                    {
                        sI = (i + readonlyRowsCount).ToString();
                        if (sI.Length == 2) sI = "0" + sI;
                        if (sI.Length == 1) sI = "00" + sI;
                        sb.Append("<td style='width:5%'>" + sI  + ((section == "Instructions" && i + readonlyRowsCount < 5) ? "*" : "") + "</td>");
                        dr = rsNotes.Skip(i + readonlyRowsCount - 1).FirstOrDefault( );
                       // sb.Append("<td style='width:35%'>" + dr["Notes"].ToString() + "</td>");
                        sb.Append("<td style='width:35%'>" + dr["Notes"].ToString().HtmlEncode() + "</td>");  //<CODE_TAG_103922>
                        if (section == "Instructions")
                            sb.Append("<td style='width:5%'></td>");
                        else
                        {
                            switch (dr["masterIndicator"].ToString())
                            {
                                case "I": 
                                    masterIndicatorDesc = "I"; 
                                    break;
                                case "B": 
                                    masterIndicatorDesc = "B"; 
                                    break;
                                default:  
                                    masterIndicatorDesc = "E"; 
                                    break;
                            }

                            sb.Append("<td style='width:5%'> (" + masterIndicatorDesc + ")</td>");
                        }
                        sb.Append("<td style='width:5%'>&nbsp;&nbsp;&nbsp;&nbsp;</td>");
                    }
                    sb.Append("</tr>");
                }
                  sb.Append("</table>");
               
            }

        }
        litNotesList.Text = sb.ToString();
    }
    //<CODE_TAG_103339>
    public void Bind(string section, string multiLineNote, bool SegmentEditble, bool ExteranlNoteOnly = true)
    {

        SegmentEdit = SegmentEditble;
        Section = section;
        if (multiLineNote == null) multiLineNote = "";
        string multiLineNote1 = string.Empty, multiLineNote2 = string.Empty;
        if (ExteranlNoteOnly)
        {
            multiLineNote1 = multiLineNote;
            //multiLineNote1 = multiLineNote.HtmlDecode();//<CODE_TAG_103922>
        }
        else
        {
            string[] arrmultiLineNote = multiLineNote.Split('~');
            multiLineNote1 = arrmultiLineNote[0];
            multiLineNote2 = arrmultiLineNote[1];
            //multiLineNote1 = arrmultiLineNote[0].HtmlDecode();//<CODE_TAG_103922>
            //multiLineNote2 = arrmultiLineNote[1].HtmlDecode();//<CODE_TAG_103922>
        }
        
        StringBuilder sb = new StringBuilder();

        if (SegmentEditble)
        {
            //sb.Append("<textarea id='txt" + Section + "Notes' name='txt" + Section + "Notes' rows='4' cols='230' >text here</textarea>");
            //sb.Append("<textarea id='txt" + Section + "Notes' name='txt" + Section + "Notes' rows='4' cols='230' >" + multiLineNote + "</textarea>");
            if (Section.Contains("ExternalNotes")) //multiple line textboxes for both customer notes and internal notes 
            {
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Notes.MultiLineEdit.InternalNotesTogglableShow"))
                {
                    if (ExteranlNoteOnly)
                        sb.Append("<div ><input id='inputCbxMultiLineNoteTypeSelected' name='inputCbxMultiLineNoteTypeSelected' type='checkbox' checked onclick='toggleDisplayMultilineExternalNote();'/><span style='font-weight: bold;' id='selectedNoteTypeDesc' name='selectedNoteTypeDesc'>Customer Note Only</span></div>");
                    else
                        sb.Append("<div ><input id='inputCbxMultiLineNoteTypeSelected' name='inputCbxMultiLineNoteTypeSelected'  type='checkbox' onclick='toggleDisplayMultilineExternalNote();'/><span style='font-weight: bold;' id='selectedNoteTypeDesc' name='selectedNoteTypeDesc'>Customer Note Only</span></div>");
                }
                
                sb.Append("<div id='divExternalMultilineNote' name='divExternalMultilineNote' >");
                sb.Append("<div style='font-weight: bold;' id='lblMultiLineExternalNote' name='lblMultiLineExternalNote'>Customer Note:</div>");
                sb.Append("<textarea id='txt" + Section + "Notes' name='txt" + Section + "Notes' rows='8' style='width:100%' >" + multiLineNote1 + "</textarea>");
                sb.Append("</div>");

                if (ExteranlNoteOnly)
                    sb.Append("<div id='divInternalMultilineNote' name='divInternalMultilineNote' style='display: none; ' > ");
                else
                    sb.Append("<div id='divInternalMultilineNote' name='divInternalMultilineNote' > ");

                sb.Append("<div style='font-weight: bold;' id='lblMultiLineInternalNote' name='lblMultiLineInternalNote'>Internal Note:</div>");
                sb.Append("<textarea id='txt" + Section + "INotes' name='txt" + Section + "INotes' rows='8' style='width:100%' >" + multiLineNote2 + "</textarea>");
                sb.Append("</div>");

            }
            else //for the special instructions multiple line textbox
            {
                sb.Append("<textarea id='txt" + Section + "Notes' name='txt" + Section + "Notes' rows='8' style='width:100%' >" + multiLineNote + "</textarea>");
            }



        }
        else//read only
        {
            //sb.Append("here is note readonly mode show here");
            //multiLineNote=multiLineNote.Replace( "&#10;","<br>");
            //multiLineNote = multiLineNote.Replace("\n", "<br>");
            if (Section.Contains("ExternalNotes"))
            {
                multiLineNote1 = multiLineNote1.Replace("\n", "<br>");
                
                if (!ExteranlNoteOnly)
                {
                    sb.Append("Customer Note:<br>");
                    sb.Append(multiLineNote1 + "<br><br>");
                    sb.Append("Internal Note:<br>");
                    multiLineNote2 = multiLineNote2.Replace("\n", "<br>");
                    sb.Append(multiLineNote2);

                }
                else
                {
                    sb.Append(multiLineNote1);
                }
            }
            else
            {
                if (!string.IsNullOrEmpty(multiLineNote))
                {
                    multiLineNote = multiLineNote.Replace("\n", "<br>");
                    sb.Append(multiLineNote);
                }
            }

            
        }
        litNotesList.Text = sb.ToString();

    }
    //</CODE_TAG_103339>
}

