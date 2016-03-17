//using System;
//using System.Linq;
//using System.Data;
//using System.Data.SqlClient;
//using System.Collections.Generic;
//using System.Collections.Specialized;
//using Entities.AppState;
//using X.Configuration;
//using X.Data;
//using X;
//using X.Extensions;
//using X.Web.Security;
//using Enums;
//using Entities;
//using IdentityInfo = Entities.IdentityInfo;

//namespace Repositories
//{
//    public class QuoteRepository {
//        public QuoteHeader GetQuoteHeader(int quoteId, int revision, int pageMode)
//        {
//            DataTable dt;
//            QuoteHeader  quoteHeader = null;

//            var data = SqlHelper.ExecuteDataset(
//                "dbo.Quote_Detail_Get"
//                , quoteId
//                , revision
//                , pageMode
//                );

//            dt = GetTableByName( data, "QuoteHeader") ;

//            if (dt != null)
//            {
//                DataRow dr = dt.Rows[0];
//                quoteHeader = new QuoteHeader()
//                {
//                    QuoteId  = dr["QuoteId"].AsInt(),
//                    QuoteNo = dr["QuoteNo"].AsString(   ),
//                    QuoteType = (dr["type"].AsString() == "A")? QuoteTypeEnum.A : QuoteTypeEnum.Q,
//                    QuoteDate = dr["QuoteDate"].AsDateTime( ),
//                    Customer = new Customer() 
//                    {
//                        CustomerNo = dr["customerNo"].AsString(),
//                        CustomerName = dr["CusomterName"].AsString() 
//                    },
//                    EnterUser = new IdentityInfo() 
//                    {
//                        UserID = dr["EnterUserId"].AsInt()
//                    },
//                    EnterDate =  dr["EnterDate"].AsDateTime( ) ,
//                    ChangeUser = new IdentityInfo() 
//                    {
//                        UserID = dr["ChangeUserId"].AsInt()
//                    },
//                    ChangeDate = dr["ChangeDate"].AsDateTime( )
                    

//                }
//                //Revision
//                dt = GetTableByName( data, "QuoteRevision");
//                if (dt != null)
//                {
//                    foreach (DataRow dr in dt.Rows)
//                    {
//                        quoteHeader.Revisions.Add( new QuoteRevision() { Revision = dr["Revision"].AsInt(), Selected = dr["selected"].AsInt( ) == 2  } )
//                    }
//                }
//                //Summary
//                dt = GetTableByName(data, "QutoeSummary");
//                if (dt != null)
//                {
//                    dr = dt.Rows[0];
//                    quoteHeader.Summary = new Summary() { 
//                        WorkOrderNo = dr["WorkOrderNo"].ToString(), 
//                        PurchaseOrderNo = dr["PurchaseOrderNo"].ToString(), 
//                        Division = dr["Division"].ToString() , 
//                        BranchNo = dr["BranchNo"].ToString(), 
//                        Make = dr["Make"].ToString(),
//                        Model = dr["Model"].ToString(), 
//                        SerialNo = dr["SerialNo"].ToString(), 
//                        UnitNo = dr["UnitNo"].ToString(),
//                        SMU = dr["SMU"].AsDouble( ), 
//                        EstimatedRepairTime = dr["EstimatedRepairTime"].AsDateTime( ), 
//                        GSTRate = dr["GSTRate"].AsDouble(), 
//                        PSTRate = dr["PSTRate"].AsDouble(), 
//                        PSTOnGST = dr["PSTOnGST"].AsDouble(), 
//                        NewCompletionDate = dr["NewCompletionDate"].AsDateTime( ),
//                        EnvironmentalCharge = dr["EnvironmentalCharge"].AsDouble( ),
//                        QuoteTotal = dr["QuoteTotal"].AsDouble( ),
//                        EmailSent = dr["EmailSent"].AsInt( ) == 2, 
//                        SchedulerAppointmentId = dr["SchedulerAppointmentId"].AsInt( ), 
//                        EnterUserId = new IdentityInfo() { UserID = dr["EnterUserId"].AsInt()}, 
//                        EnterDate = dr["EnterDate"].AsDateTime(), 
//                        ChangeUserId = new IdentityInfo() { UserID = dr["ChangeUserId"].AsInt()}, 
//                        ChangeDate = dr["ChangeDate"].AsDateTime(), 
//                        QuoteDescription = dr["QuoteDescription"].ToString(), 
//                        AcceptedDate = dr["AcceptedDate"].AsDateTime(), 
//                        Comments = dr["Comments"].ToString()
//                    }
//                }
//                // Segment
//                dt = GetTableByName( data, "QutoeSegment");
//                DataTable dtParts = GetTableByName( data, "Parts");
//                DataTable dtLabor = GetTableByName( data, "Labor");
//                DataTable dtMiscellaneous = GetTableByName( data, "Miscessaneous" );
//                if (dt != null)
//                {
//                    foreach (DataRow dr in dt.Rows)
//                    {
//                        Segment s = new Segment() 
//                        {
//                            SegmentId = dr["QuoteSegmentId"].AsInt( ),
//                            SegmentNo = dr["SegmentNo"].AsString( ),
//                            //Description = dr["Description"].AsString( ),
//                            //HiddenDescription = dr["HiddenDescription"].AsString( ),
//                            DBSRepairOptionId = dr["DBSRepairOptionId"].AsInt( ),
//                            EnterUser = new IdentityInfo() 
//                            {
//                                UserID = dr["EnterUserId"].AsInt()
//                            },
//                            EnterDate =  dr["EnterDate"].AsDateTime( ) ,
//                            ChangeUser = new IdentityInfo() 
//                            {
//                                UserID = dr["ChangeUserId"].AsInt()
//                            },
//                            ChangeDate = dr["ChangeDate"].AsDateTime( )
//                        };
//                        // parts
//                       if (dtParts != null)
//                       {
//                           foreach (DataRow dr in dtParts.Rows)
//                           {
//                               s.Parts.Add( new Part( ){QuoteDetailId = dr["QuoteDetailId"].AsInt( ),
//                                                        Quantity = dr["Quantity"].AsInt( ),
//                                                        SOS = dr["SOS"].AsString( ),
//                                                        PartNo = dr["PartNo"].AsString( ),
//                                                        Description = dr["Description"].AsString(),
//                                                        UnitDiscPrice = dr["UnitDiscPrice"].AsString(),
//                                                        UnitSellPrice = dr["UnitSellPrice"].AsString(),
//                                                        NetSellPrice = dr["NetSellPrice"].AsString(),
//                                                        UnitPrice = dr["UnitPrice"].AsDouble( ),
//                                                        ExtendedPrice = dr["ExtendedPrice"].AsDouble( ),
//                                                        RepairOptionId = dr["RepairOptionId"].AsInt(),
//                                                        Discount = dr["Discount"].AsDouble( ),
//                                                        UpdateStatus = dr["UpdateStatus"].AsInt( ),
//                                                        COREDetailId = dr["COREDetailId"].AsInt( ),
//                                                        SortOrder = dr["SortOrder"].AsInt( ),
//                                                        EnterUser = new IdentityInfo() 
//                                                        {
//                                                           UserID = dr["EnterUserId"].AsInt()
//                                                        },
//                                                        EnterDate =  dr["EnterDate"].AsDateTime( ) ,
//                                                        ChangeUser = new IdentityInfo() 
//                                                        {
//                                                           UserID = dr["ChangeUserId"].AsInt()
//                                                        },
//                                                        ChangeDate = dr["ChangeDate"].AsDateTime( )
//                               })
//                           }
//                       }
//                        //labor
//                       if (dtLabor != null)
//                       {
//                           foreach (DataRow dr in dtLabor.Rows)
//                           {
//                               s.Labor.Add( new Labor( ){QuoteDetailId = dr["QuoteDetailId"].AsInt( ),
//                                                        Quantity = dr["Quantity"].AsInt( ),
//                                                        ItemNo  = dr["ItemNo"].AsString( ),
//                                                        Description = dr["Description"].AsString(),
//                                                        UnitDiscPrice = dr["UnitDiscPrice"].AsDouble(),
//                                                        UnitSellPrice = dr["UnitSellPrice"].AsDouble(),
//                                                        NetSellPrice = dr["NetSellPrice"].AsDouble(),
//                                                        UnitPrice = dr["UnitPrice"].AsDouble( ),
//                                                        ExtendedPrice = dr["ExtendedPrice"].AsDouble( ),
//                                                        RepairOptionId = dr["RepairOptionId"].AsInt(),
//                                                        Discount = dr["Discount"].AsDouble( ),
//                                                        SortOrder = dr["SortOrder"].AsInt( ),
//                                                        EnterUser = new IdentityInfo() 
//                                                        {
//                                                           UserID = dr["EnterUserId"].AsInt()
//                                                        },
//                                                        EnterDate =  dr["EnterDate"].AsDateTime( ) ,
//                                                        ChangeUser = new IdentityInfo() 
//                                                        {
//                                                           UserID = dr["ChangeUserId"].AsInt()
//                                                        },
//                                                        ChangeDate = dr["ChangeDate"].AsDateTime( )
//                               })
//                           }
//                       }

//                                                //labor
//                       if (dtMiscellaneous != null)
//                       {
//                           foreach (DataRow dr in dtMiscellaneous.Rows)
//                           {
//                               s.Miscellaneous .Add( new Miscellaneous( ){QuoteDetailId = dr["QuoteDetailId"].AsInt( ),
//                                                        Quantity = dr["Quantity"].AsInt( ),
//                                                        ItemNo  = dr["ItemNo"].AsString( ),
//                                                        Description = dr["Description"].AsString(),
//                                                        UnitDiscPrice = dr["UnitDiscPrice"].AsDouble(),
//                                                        UnitSellPrice = dr["UnitSellPrice"].AsDouble(),
//                                                        NetSellPrice = dr["NetSellPrice"].AsDouble(),
//                                                        UnitPrice = dr["UnitPrice"].AsDouble( ),
//                                                        ExtendedPrice = dr["ExtendedPrice"].AsDouble( ),
//                                                        RepairOptionId = dr["RepairOptionId"].AsInt(),
//                                                        Discount = dr["Discount"].AsDouble( ),
//                                                        SortOrder = dr["SortOrder"].AsInt( ),
//                                                        EnterUser = new IdentityInfo() 
//                                                        {
//                                                           UserID = dr["EnterUserId"].AsInt()
//                                                        },
//                                                        EnterDate =  dr["EnterDate"].AsDateTime( ) ,
//                                                        ChangeUser = new IdentityInfo() 
//                                                        {
//                                                           UserID = dr["ChangeUserId"].AsInt()
//                                                        },
//                                                        ChangeDate = dr["ChangeDate"].AsDateTime( )
//                               })
//                           }
//                       }
                    
//                        //Add to Quote Header
//                        quoteHeader.Segments.Add( s);

//                    }
               
//                //Document
//                dt = GetTableByName( data, "QuoteDocument");
//                if (dt != null)
//                {
//                    foreach (DataRow dr in dt.Rows)
//                    {
//                        quoteHeader.Documents.Add( new Documents() { 
//                            DocumentId = dr["documentId"].AsInt( ),
//                            DocumentName = dr["DocumentName"].AsString( ),
//                            Description = dr["Description"].AsString(),
//                            Size = dr["Size"].AsInt()
                        
                        
//                        } )
//                    }
//                }




//                }
                    
                 
            
//            }
        

//            return quoteHeader;
//        }

//        public void UpdateQuoteHeader(QuoteHeader quoteHeader)
//        {
//            SqlHelper.ExecuteNonQuery("Quote_Edit_QuoteHeader", quoteHeader.QuoteId, quoteHeader.Comments);

//        }



//        public DataTable  GetTableByName(DataSet ds, string tableName)
//        {
//            foreach (DataTable dt in ds)
//            {
//                if (dt.Rows.Count > 0)
//                {
//                    if (dt.Rows[0]["RS_Type"].ToString() == tableName )
//                        return dt;
//                }
//            }
//            return null;
//        }



//    }
//}