<%@ WebHandler Language="C#" Class="CommonFunctionAjaxHandler" %>
using System;
using System.Web;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using Entities;
using X.Extensions;
using CATPAI;
using DTO;
using System.Text;
using Helpers;
using System.Data;
using System.Text;
using System.IO;
using System.Web.UI.HtmlControls;

public class CommonFunctionAjaxHandler : IHttpHandler
{
    DataSet ds;
    DataTable dt;
    
    public void ProcessRequest(HttpContext context)
    {
        //Local variables
        string cuno;
        
        string spiltChar1 = ((char)5).ToString();
        
        string operation = context.Request.QueryString["OP"].AsString("").ToUpper();
        string rtData = "";

        switch (operation)
        {

            case "GETDIVISIONSLIST":
                cuno = context.Request.QueryString["cuno"].AsString("");
                ds = DAL.Quote.QuoteGetInfluencers(cuno);
                dt = ds.Tables[0];

                foreach (DataRow dr in dt.Rows)
                {
                    if (rtData != "")
                        rtData += ",";
                    rtData += dr["Division"].ToString().Trim() + "|" + dr["DivisionName"].ToString().Trim();
                }
                break;

                
            case "GETINFLUENCERLIST":
                cuno = context.Request.QueryString["cuno"].AsString("");
                ds = DAL.Quote.QuoteGetInfluencers(cuno);
                dt = ds.Tables[1];
                
                foreach (DataRow dr in dt.Rows)
                {
                    if (rtData != "")
                        rtData += spiltChar1;
                    rtData += dr["Division"].ToString().Trim() + "-" + dr["InfluencerId"].ToString().Trim() + "-" + dr["InfluencerType"].ToString().Trim() + "-" + dr["InfluencerName"].ToString().Trim() + "-" + dr["phoneNumber"].ToString().Trim().Replace("-", "@") + "-" + dr["fax"].ToString().Trim().Replace("-", "@") + "-" + dr["email"].ToString().Trim() + "-";
                }
                break;
                
            case "GETSEGMENTCUSTOMERSHTML":
               var segmentId = context.Request.QueryString["SegmentId"].AsInt(0);
                System.Web.UI.Page page = new Page() ;
                HtmlForm form = new HtmlForm { ID = "theForm" };
                UserControl uc = new UserControl();
                UcSegmentCustomerDisplay ucSegmentCustomers = (UcSegmentCustomerDisplay)uc.LoadControl("~/Modules/Quote/Controls/SegmentCustomersDisplay.ascx");
                form.Controls.Add(uc);
                page.Controls.Add(form); 
                
                ucSegmentCustomers.SegmentId = segmentId;
                ucSegmentCustomers.SegmentEdit = true;
                ucSegmentCustomers.Render();
               TextWriter tw = new StringWriter();
               HtmlTextWriter hw = new HtmlTextWriter(tw);
               ucSegmentCustomers.RenderControl(hw);

               rtData = tw.ToString();
              
                break;
                
                
            case "GETOPPINFO":
                var oppNo = context.Request.QueryString["OppNo"].AsInt(0);
                ds = DAL.Quote.QuoteGetOppInfo(oppNo);
                dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    DataRow dr = dt.Rows[0];
                    StringBuilder sb = new StringBuilder();
                    sb.Append("{");
                    sb.Append("\"ResultCode\":\"0\",");
                    sb.Append("\"CustNo\":\"" + StringUtils.JSONEscape(dr["CustomerNo"].ToString()) + "\",");
                    sb.Append("\"CustName\":\"" + StringUtils.JSONEscape(dr["CustomerName"].ToString()) + "\",");
                    sb.Append("\"DeliveryYear\":\"" + dr["DeliveryYear"].ToString() + "\",");
                    sb.Append("\"DeliveryMonth\":\"" + dr["DeliveryMonth"].ToString() + "\",");
                    sb.Append("\"Description\":\"" + StringUtils.JSONEscape(dr["oppdescription"].ToString()) + "\",");
                    sb.Append("\"QuoteTypeId\":\"" + dr["QuoteTypeId"].ToString() + "\",");
                    sb.Append("\"OppTypeId\":\"" + dr["OppTypeId"].ToString() + "\",");
                    sb.Append("\"Division\":\"" + dr["Division"].ToString() + "\",");
                    sb.Append("\"DivisionName\":\"" + StringUtils.JSONEscape(dr["DivisionName"].ToString()) + "\",");
                    sb.Append("\"CustomerContactName\":\"" + StringUtils.JSONEscape(dr["CustomerContactName"].ToString()) + "\",");
                    sb.Append("\"CommodityCategoryId\":\"" + StringUtils.JSONEscape(dr["CommodityCategoryId"].ToString()) + "\",");
                    sb.Append("\"OppSourceId\":\"" + StringUtils.JSONEscape(dr["OppSourceId"].ToString()) + "\",");
                    sb.Append("\"CampaignId\":\"" + StringUtils.JSONEscape(dr["CampaignId"].ToString()) + "\",");
                    
                    sb.Append("\"ProbabilityOfClosing\":\"" + dr["ProbabilityOfClosing"].ToString() + "\"");
                    // <CODE_TAG_103716>
                    sb.Append(",\"SerialNo\":\"" + dr["SerialNo"].ToString() + "\"");
                    sb.Append(",\"Make\":\"" + dr["Make"].ToString() + "\"");
                    // <CODE_TAG_103716>
                    //<CODE_TAG_103814>
                    sb.Append(",\"Phone\":\"" + dr["Phone"].ToString() + "\"");
                    sb.Append(",\"PostalCode\":\"" + dr["PostalCode"].ToString() + "\"");
                    sb.Append(",\"Email\":\"" + dr["Email"].ToString() + "\"");
                    sb.Append(",\"BranchNo\":\"" + dr["BranchNo"].ToString() + "\"");
                    sb.Append(",\"XUId\":\"" + dr["XUId"].ToString() + "\"");
                    //</CODE_TAG_103814>
                    sb.Append("}");
                    
                    rtData = sb.ToString();
                }
                else
                {
                    rtData = "{\"ResultCode\":\"-1\"}";
                }
                
                break;     

                                    
            default:
                break;    
        }
        context.Response.ContentType = "text/plain";
        context.Response.Clear();
        context.Response.Write(rtData);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}