using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using X;
using X.Extensions;
using X.Data;

/// <summary>
/// Summary description for Quote
/// </summary>
namespace DAL
{
    public class Quote
    {
        public Quote()
        {
        }

        public static DataSet QuoteDetailGet(int quoteId, int revision, int pageMode, int segmentId, bool segmentEdit)
        {

            var data = SqlHelper.ExecuteDataset(
                        "dbo.Quote_Get_Detail"
                        , quoteId
                        , revision
                        , pageMode
                        , segmentId
                        , (segmentEdit) ? 1: 0
                        , X.Web.WebContext.Current.User.IdentityEx.UserID
                        );
            return data;
        }

        public static DataSet QuoteDocumentGet(int quoteId, int revision)
        {
            var data = SqlHelper.ExecuteDataset(
                        "dbo.Quote_Get_Detail_Document"
                        , quoteId
                        , revision
                        );
            return data;
        }

        public static DataSet QuoteHeaderGet(int quoteId, int revision, int appointmentId = 0)
        {
            var data = SqlHelper.ExecuteDataset(
                  "dbo.Quote_Get_Header"
                         , quoteId
                         , 1
                         , X.Web.WebContext.Current.User.IdentityEx.UserID
                         , revision
                         , appointmentId
                );
            return data;
        }

        public static void QuoteHeaderEdit(int quoteId,
                                             int revision,
                                           string quoteNo,
                                           int quoteStatusId,
                                           int salesRepUserId,
                                           string branchNo,
                                           string quoteDescription,
                                           string customerNo,
                                           string customerName,
                                           string division,
                                           int influencerId,
                                           string influencerType,
                                           string contactName,
                                           string newContactFlag,
                                           string phoneNo,
                                           string faxNo,
                                           string email,
                                           string po,
                                           string make,
                                           string model,
                                           string serialNo,
                                           string unitNo,
                                          string stockNo,
                                           double? smu,
                                           int estDeliaryYear,
                                           int estDeliveryMonth,
                                           int probabilityOfClosing,
            //int oppTypeId,
                                           int commodityCategoryId,
                                           int oppSourceId,
                                           int oppNo,
                                           int campaign,
                                           int reason,
                                           string oppComments,
                                           string promiseDate,
                                        string unittoArriveDate,
                                        int plannedIndicatorId,
                                        int urgencyIndicatorId,
                                        int smuIndicatorId,
                                        string smuLastRead,
                                         int quoteTypeId,
                                           int hasOppInd,
                                    int oppAddOrExistingInd,
                                     string jobControlCode,
                                     string estimatedRepairTime,
                                     string salesRepPhoneNo,
                                     string salesRepCellPhoneNo,
                                     string salesRepFaxNo,
                                     string estimatedByName,
                                     string comments, //<CODE_TAG_101731> 
                                     string cabtypecode
                                     , string printQuoteDate  //<CODE_TAG_103674>
                                    , string stageType  //<CODE_TAG_105235> lwang
            )
        {
            SqlHelper.ExecuteNonQuery("Quote_Edit_Header",
                                      quoteId,
                                      revision,
                                      quoteNo,
                                      quoteStatusId,
                                      salesRepUserId,
                                      branchNo,
                                      quoteDescription,
                                      customerNo,
                                      customerName,
                                      division,
                                      influencerId,
                                      influencerType,
                                      contactName,
                                      newContactFlag,
                                      phoneNo,
                                      faxNo,
                                      email,
                                      po,
                                      make,
                                      model,
                                      serialNo,
                                      unitNo,
                                      stockNo,
                                      smu,
                                      estDeliaryYear,
                                      estDeliveryMonth,
                                      probabilityOfClosing,
                //oppTypeId,
                                      commodityCategoryId,
                                      oppSourceId,
                                      oppNo,
                                      campaign,
                                      reason,
                                      oppComments,
                                      promiseDate,
                                      unittoArriveDate,
                                      plannedIndicatorId,
                                      urgencyIndicatorId,
                                      smuIndicatorId,
                                      smuLastRead,
                                      quoteTypeId,
                                      hasOppInd,
                                      oppAddOrExistingInd,
                                      jobControlCode,
                                      estimatedRepairTime,
                                      salesRepPhoneNo,
                                      salesRepCellPhoneNo,
                                      salesRepFaxNo,
                                      estimatedByName,
                                      X.Web.WebContext.Current.User.IdentityEx.UserID,
                                      comments, //<CODE_TAG_101731> 
                                      cabtypecode
                                     , printQuoteDate   //<CODE_TAG_103674>
                                     , stageType    //<CODE_TAG_105235> lwang
                                      );



        }

        public static int QuoteAdd(int salesRepUserId,
                                    string branchNo,
                                    string srPhone,
                                    string srCellPhone,
                                    string srFax,
                                    string quoteDescription,
                                    string customerNo,
                                    string customerName,
                                    string division,
                                    int influencerId,
                                    string influencerType,
                                    string contactName,
                                    string newContactFlag,
                                    string phoneNo,
                                    string faxNo,
                                    string email,
                                    string make,
                                    string model,
                                    string serialNo,
                                    string unitNo,
                                    string stockNo,
                                    double? smu,
                                    int estDeliaryYear,
                                    int estDeliveryMonth,
                                    int probabilityOfClosing,
            //int oppTypeId,
                                    int commodityCategoryId,
                                    int oppSourceId,
                                    int oppNo,
                                    int campaign,
            //int reason,
            //string oppComments,
                                    string promiseDate,
                                    string unittoArriveDate,
                                    int plannedIndicatorId,
                                    int urgencyIndicatorId,
                                    int smuIndicatorId,
                                    string smuLastRead,
                                    int quoteTypeId,
                                    int hasOppInd,
                                    int oppAddOrExistingInd,
                                    int newSegmentSourceType,
                                    string newSegmentData,
                                    string DBSROId,   //<CODE_TAG_104228>
                                    string DBSROPId,  //<CODE_TAG_104228>
                                    string sType,
                                    string DBSROSelectedGroup,
                                    string jobControlCode,
                                    string estimatedRepairTime,
                                    string wono,
                                    string pono,
                                    string estimatedByName,
                                    int appointmentId,
                                    int copyNotes,
                                    out int newQuoteId,
                                    out string newQuoteNo,
                                    string comments, //<CODE_TAG_101731> 
                                    string cabtypecode
                                   ,string stageType// <CODE_TAG_105235> lwang
           )
        {
            SqlParameter RV = new SqlParameter("RetValue", SqlDbType.Int);
            RV.Direction = ParameterDirection.ReturnValue;

            SqlParameter sqlNewQuoteId = new SqlParameter("@NewQuoteId", SqlDbType.Int);
            sqlNewQuoteId.Direction = ParameterDirection.Output;

           SqlParameter sqlNewQuoteNo = new SqlParameter("@NewQuoteNo", SqlDbType.VarChar,20);
            sqlNewQuoteNo.Direction = ParameterDirection.Output;

            DBSROSelectedGroup = DBSROSelectedGroup.Replace("&", "&#38;"); //!!
            SqlHelper.ExecuteNonQuery(CommandType.StoredProcedure,
                                     "Quote_Add",
                                      RV,
                                      new SqlParameter("@SalesRepUserId", salesRepUserId),
                                      new SqlParameter("@BranchNo", branchNo),
                                      new SqlParameter("@SrPhone", srPhone),
                                      new SqlParameter("@SrCellPhone", srCellPhone),
                                      new SqlParameter("@SrFax", srFax),
                                      new SqlParameter("@QuoteDescription", quoteDescription),
                                      new SqlParameter("@CustomerNo", customerNo),
                                      new SqlParameter("@CustomerName", customerName),
                                      new SqlParameter("@division", division),
                                      new SqlParameter("@InfluencerId", influencerId),
                                      new SqlParameter("@InfluencerType", influencerType),
                                      new SqlParameter("@ContactName", contactName),
                                      new SqlParameter("@NewContactFlag", newContactFlag),
                                      new SqlParameter("@PhoneNo", phoneNo),
                                      new SqlParameter("@faxNo", faxNo),
                                      new SqlParameter("@Email", email),
                                      new SqlParameter("@Make", make),
                                      new SqlParameter("@Model", model),
                                      new SqlParameter("@SerialNo", serialNo),
                                      new SqlParameter("@UnitNo", unitNo),
                                      new SqlParameter("@StockNo", stockNo),
                                      new SqlParameter("@SMU", smu),
                                      new SqlParameter("@EstDeliveryYear", estDeliaryYear),
                                      new SqlParameter("@EstDeliveryMonth", estDeliveryMonth),
                                      new SqlParameter("@ProbabilityOfClosing", probabilityOfClosing),
                //new SqlParameter("@OppTypeId", oppTypeId),
                                      new SqlParameter("@CommodityCategoryId", commodityCategoryId),
                                      new SqlParameter("@OppSourceId", oppSourceId),
                                      new SqlParameter("@OppNo", oppNo),
                                      new SqlParameter("@Campaign", campaign),
                //new SqlParameter("@Reason", reason),
                //new SqlParameter("@OppComments", oppComments),
                                      new SqlParameter("@PromiseDate", promiseDate),
                                      new SqlParameter("@UnitToArriveDate", unittoArriveDate),
                                      new SqlParameter("@PlannedIndicatorId", plannedIndicatorId),
                                      new SqlParameter("@UrgencyIndicatorId", urgencyIndicatorId),
                                      new SqlParameter("@SMUIndicatorId", smuIndicatorId),
                                      new SqlParameter("@SMULastRead", smuLastRead),
                                      new SqlParameter("@QuoteTypeId", quoteTypeId),
                                      new SqlParameter("@HasOppInd", hasOppInd),
                                      new SqlParameter("@OppAddOrExistingInd", oppAddOrExistingInd),
                                      new SqlParameter("@NewSegmentSourceType", newSegmentSourceType),
                                      new SqlParameter("@NewSegmentData", newSegmentData),
                                      new SqlParameter("@DBSRepairOptionId", DBSROId),
                                      new SqlParameter("@RepairOptionPricingID", DBSROPId),
                                      new SqlParameter("@SourceType", sType),
                                      new SqlParameter("@DBSROSelectedGroup", DBSROSelectedGroup),
                                      new SqlParameter("@JobControlCode", jobControlCode),
                                      new SqlParameter("@estimatedRepairTime", estimatedRepairTime),
                                      new SqlParameter("@wono", wono),
                                      new SqlParameter("@pono", pono),
                                      new SqlParameter("@estimatedByName", estimatedByName),
                                      new SqlParameter("@appointmentId", appointmentId),
                                     new SqlParameter("@CopyNotes",copyNotes),
                                      new SqlParameter("@EnterUserId", X.Web.WebContext.Current.User.IdentityEx.UserID),
                                      sqlNewQuoteId,
                                      sqlNewQuoteNo,
                                     new SqlParameter("@Comments",comments),  //<CODE_TAG_101731> 
                                      new SqlParameter("@CabTypeCode", cabtypecode)
                                    , new SqlParameter("@StageTypeCode", stageType) // <CODE_TAG_105235> lwang
                                     );
           newQuoteId  = sqlNewQuoteId.Value.AsInt();
            newQuoteNo = sqlNewQuoteNo.Value.AsString();
            return RV.Value.AsInt();


        }

        public static void QuoteStatusChange(int quoteId, int revision, int statusId, int createTicket = 0)
        {
            SqlHelper.ExecuteNonQuery("Quote_Edit_Status",
                                     quoteId,
                                     revision,
                                     statusId,
                                     createTicket,
                                     X.Web.WebContext.Current.User.IdentityEx.UserID);
        }

       public static void QuoteDocumentAddNew( int quoteId,
                                             int revision,
                                             byte[] byteFile,
                                             string fileName,
                                             long fileSize,
                                             string description)
        {
            var enterUserId = X.Web.WebContext.Current.User.IdentityEx.UserID;
            SqlHelper.ExecuteNonQuery("Quote_Add_Document", quoteId, revision, fileName, fileSize, byteFile, description, enterUserId);
        }

       public static DataSet  QuoteDocumentGet(int fileId)
        {

            var ds = SqlHelper.ExecuteDataset("Quote_Get_Document", fileId);
            return ds;
        }

        public static void QuoteDocumentDelete(int fileId)
        {
            SqlHelper.ExecuteNonQuery("Quote_Delete_Document", fileId);
        }

        public static void QuoteDocumentEdit(int fileId, string desc)
        {
            var changeUserId = X.Web.WebContext.Current.User.IdentityEx.UserID;
            SqlHelper.ExecuteNonQuery("Quote_Edit_Document", fileId, desc, changeUserId);
        }

        public static int CopyRevision(int quoteId, int revision, out int newRevision)
        {
            SqlParameter RV = new SqlParameter("RetValue", SqlDbType.Int);
            RV.Direction = ParameterDirection.ReturnValue;

            SqlParameter sqlNewRevision = new SqlParameter("@NewRevision", SqlDbType.Int);
            sqlNewRevision.Direction = ParameterDirection.Output;


            SqlHelper.ExecuteNonQuery(CommandType.StoredProcedure,
                                      "Quote_Copy_Revision",
                                     RV,
                                     new SqlParameter("@fromQuoteId", quoteId),
                                     new SqlParameter("@FromRevision", revision),
                                     new SqlParameter("@toQuoteId", quoteId),
                                     new SqlParameter("@CreatedUserId", X.Web.WebContext.Current.User.IdentityEx.UserID),
                                     sqlNewRevision);

            newRevision = sqlNewRevision.Value.AsInt();
            return RV.Value.AsInt();
        }


        public static int LinkWOToNewRevision(int quoteId, int revision, out int newRevision)
        {
            SqlParameter RV = new SqlParameter("RetValue", SqlDbType.Int);
            RV.Direction = ParameterDirection.ReturnValue;

            SqlParameter sqlNewRevision = new SqlParameter("@NewRevision", SqlDbType.Int);
            sqlNewRevision.Direction = ParameterDirection.Output;


            SqlHelper.ExecuteNonQuery(CommandType.StoredProcedure,
                                      "Quote_LinkWO_To_NewRevision",
                                     RV,
                                     new SqlParameter("@QuoteId", quoteId),
                                     new SqlParameter("@FromRevision", revision),
                                     new SqlParameter("@CreatedUserId", X.Web.WebContext.Current.User.IdentityEx.UserID),
                                     sqlNewRevision);

            newRevision = sqlNewRevision.Value.AsInt();
            return RV.Value.AsInt();
        }


        public static int CopyQuote(int fromQuoteId, int fromRevision, out int newQuoteId)
        {
            SqlParameter RV = new SqlParameter("RetValue", SqlDbType.Int);
            RV.Direction = ParameterDirection.ReturnValue;

            SqlParameter sqlNewQuoteId = new SqlParameter("@NewQuoteId", SqlDbType.Int);
            sqlNewQuoteId.Direction = ParameterDirection.Output;


            SqlHelper.ExecuteNonQuery(CommandType.StoredProcedure,
                                      "Quote_Copy_Quote",
                                     RV,
                                     new SqlParameter("@fromQuoteId", fromQuoteId),
                                     new SqlParameter("@FromRevision", fromRevision),
                                     new SqlParameter("@CreatedUserId", X.Web.WebContext.Current.User.IdentityEx.UserID),
                                     sqlNewQuoteId);

            newQuoteId = sqlNewQuoteId.Value.AsInt();
            return RV.Value.AsInt();
        }

        public static void DeleteRevision(int quoteId, int revision, out int latestRevision)
        {
            SqlParameter sqlLatestRevision = new SqlParameter("@LatestRevision", SqlDbType.Int);
            sqlLatestRevision.Direction = ParameterDirection.Output;


            SqlHelper.ExecuteNonQuery(CommandType.StoredProcedure,
                                      "Quote_Delete_Revision",
                                     new SqlParameter("@QuoteId", quoteId),
                                     new SqlParameter("@Revision", revision),
                                      new SqlParameter("@changeUserId", X.Web.WebContext.Current.User.IdentityEx.UserID),
                                     sqlLatestRevision);

            latestRevision = sqlLatestRevision.Value.AsInt();
        }

        public static void DeleteAllPart(int quoteSegmentId)
        {
            SqlHelper.ExecuteNonQuery("Quote_delete_AllPart", quoteSegmentId);
        }

        //<CODE_TAG_101750>
        public static void QuoteSgementEdit(int quoteSegmentId,
                                 string segmentNo,
                                 int dbsRepairOptionId,
                                 string jobCode,
                                 string componentCode,
                                 string modifierCode,
                                 string businessGroupCode,
                                 string quantityCode,
                                 string workApplicationCode,
                                 string branchCode,
                                 string costCentreCode,
                                 string cabTypeCode,
                                 string shopfield,
                                 string jobLocationCode,
                                 string partFlatRateInd,
                                 double partFlatRateAmount,
                                 int autoPartsCalculate,
                                 string laborFlatRateInd,
                                 double laborFlatRateAmount,
                                 double laborFlatRateQty,
                                 int autoLaborCalculate,
                                 string miscFlatRateInd,
                                 double miscFlatRateAmount,
                                 int autoMiscCalculate,
                                 string totalFlatRateInd,
                                 double totalFlatRateAmount,
                                 int segmentQty = 1,
                                 float StdHours = 0//<CODE_TAG_101936>
            //string partsCustomerNo,
            //double partsPercent,
            //string laborCustomerNo,
            //double laborPercent,
            //string miscCustomerNo,
            //double miscPercent
                                 )
        {
            var changeUserId = X.Web.WebContext.Current.User.IdentityEx.UserID;
            SqlHelper.ExecuteNonQuery("Quote_Edit_QuoteSegment",
                                     quoteSegmentId,
                                     segmentNo,
                                     dbsRepairOptionId,
                                     jobCode,
                                     componentCode,
                                     modifierCode,
                                     businessGroupCode,
                                     quantityCode,
                                     workApplicationCode,
                                     branchCode,
                                     costCentreCode,
                                     cabTypeCode,
                                     shopfield,
                                     jobLocationCode,
                                     partFlatRateInd,
                                     partFlatRateAmount,
                                     autoPartsCalculate,
                                     laborFlatRateInd,
                                     laborFlatRateAmount,
                                     laborFlatRateQty,
                                     autoLaborCalculate,
                                     miscFlatRateInd,
                                     miscFlatRateAmount,
                                     autoMiscCalculate,
                                     totalFlatRateInd,
                                     totalFlatRateAmount,
                                     segmentQty,
                                     StdHours,//<CODE_TAG_101936>
                //partsCustomerNo,
                //partsPercent ,
                //laborCustomerNo,
                //laborPercent ,
                //miscCustomerNo ,
                //miscPercent ,
                                     changeUserId);
        }

        public static void AddPart(int quoteSegmentId,
                                   string sos,
                                   string partNo,
                                   double quantity,
                                   int qtyOnhand,
                                   int availableQty,
                                   double? unitWeight,
                                   string description,
                                   double unitSellPrice,
                                   double unitDiscPrice,
                                   double netSellPrice,
                                   double unitPrice,
                                   double extendedPrice,
                                   int repairOptionId,
                                   double disCount,
                                   double CorePartPrice,
                                   int Lock,
                                   int sortOrder,
                                   string backorders
                                     , double? coreDiscount = null  //<CODE_TAG_104131> 
                                 )
        {
            var userId = X.Web.WebContext.Current.User.IdentityEx.UserID;
            SqlHelper.ExecuteNonQuery("Quote_Add_Part",
                                     quoteSegmentId,
                                     sos,
                                     partNo,
                                     quantity,
                                     qtyOnhand,
                                     availableQty,
                                     unitWeight,
                                     description,
                                     unitSellPrice,
                                     unitDiscPrice,
                                     netSellPrice,
                                     unitPrice,
                                     extendedPrice,
                                     repairOptionId,
                                     disCount,
                                     CorePartPrice,
                                     Lock,
                                     sortOrder,
                                     userId,
                                     backorders
                                     , coreDiscount //<CODE_TAG_104131> 
                                     );

        }

        public static void DeleteAllLabor(int quoteSegmentId)
        {
            SqlHelper.ExecuteNonQuery("Quote_delete_AllLabor", quoteSegmentId);
        }

        public static void AddLabor(int quoteSegmentId,
                           string itemNo,
                           double quantity,
                           string description,
                           string shift,
                           double unitPrice,
                           double disCount,
                           double extendedPrice,
                           int Lock,
                           int sortOrder)
        {
            var userId = X.Web.WebContext.Current.User.IdentityEx.UserID;
            SqlHelper.ExecuteNonQuery("Quote_Add_Labor",
                                     quoteSegmentId,
                                     itemNo,
                                     quantity,
                                     description,
                                     shift,
                                     unitPrice,
                                     disCount,
                                     extendedPrice,
                                     Lock,
                                     sortOrder,
                                     userId);

        }

        public static void DeleteAllMisc(int quoteSegmentId)
        {
            SqlHelper.ExecuteNonQuery("Quote_delete_AllMisc", quoteSegmentId);
        }

        public static void AddMisc(int quoteSegmentId,
                           string itemNo,
                           double quantity,
                           string description,
                           double unitPrice,
                           double unitCost,
                           double unitPercentRate,
                           double unitSell,
                           double disCount,
                           double extendedPrice,
                           int Lock,
                           int unitPriceLock,
                           int sortOrder)
        {
            var userId = X.Web.WebContext.Current.User.IdentityEx.UserID;
            SqlHelper.ExecuteNonQuery("Quote_Add_Misc",
                                     quoteSegmentId,
                                     itemNo,
                                     quantity,
                                     description,
                                     unitPrice,
                                     unitCost,
                                     unitPercentRate,
                                    unitSell ,
                                     disCount,
                                     extendedPrice,
                                     Lock,
                                     unitPriceLock,
                                     sortOrder,
                                     userId);

        }

        public static void ChangeRevisionStatus(int quoteId, int revision, int revisionStatusId)
        {
            SqlHelper.ExecuteNonQuery("Quote_Edit_RevisionStatus", quoteId, revision, revisionStatusId, X.Web.WebContext.Current.User.IdentityEx.UserID);
        }
        public static void CreateWorkorder(int quoteId, int revision)
        {
            SqlHelper.ExecuteNonQuery("ERP_API_WO_WorkOrder_Create", quoteId, revision, X.Web.WebContext.Current.User.IdentityEx.UserID);
        }
        public static void LinkWorkorder(int quoteId, int revision, string wono)
        {
            SqlHelper.ExecuteNonQuery("Quote_Edit_RevisionWONO", quoteId, revision, wono, X.Web.WebContext.Current.User.IdentityEx.UserID);
        }
        //<CODE_TAG_103366> start
        public static void UnlinkWorkorder(int quoteId, int revision)
        {
            SqlHelper.ExecuteNonQuery("Quote_Delete_RevisionWONO", quoteId, revision, X.Web.WebContext.Current.User.IdentityEx.UserID);
        }
        //<CODE_TAG_103366> end
        public static void OpenWorkorder(int quoteId, int revision)
        {
            SqlHelper.ExecuteNonQuery("ERP_API_WO_WorkOrder_Open", quoteId, revision, X.Web.WebContext.Current.User.IdentityEx.UserID);
        }
        public static int UpdateWorkorder(int quoteId, int revision)
        {
            //SqlHelper.ExecuteNonQuery("ERP_API_WO_WorkOrder_Update", quoteId, revision, X.Web.WebContext.Current.User.IdentityEx.UserID);
            SqlParameter RV = new SqlParameter("RetValue", SqlDbType.Int);
            RV.Direction = ParameterDirection.ReturnValue;

            SqlHelper.ExecuteNonQuery(CommandType.StoredProcedure,
                                    "ERP_API_WO_WorkOrder_Update",
                                   RV,
                                   new SqlParameter("@QuoteId", quoteId),
                                   new SqlParameter("@Revision", revision),
                                   new SqlParameter("@changeUserId", X.Web.WebContext.Current.User.IdentityEx.UserID));
            return RV.Value.AsInt(0);

        }
        public static int DeleteWorkorder(int quoteId, int revision)
        {
            //   SqlHelper.ExecuteNonQuery("ERP_API_WO_WorkOrder_Delete", quoteId, revision, X.Web.WebContext.Current.User.IdentityEx.UserID);

            SqlParameter RV = new SqlParameter("RetValue", SqlDbType.Int);
            RV.Direction = ParameterDirection.ReturnValue;

            SqlHelper.ExecuteNonQuery(CommandType.StoredProcedure,
                                    "ERP_API_WO_WorkOrder_Delete",
                                   RV,
                                   new SqlParameter("@QuoteId", quoteId),
                                   new SqlParameter("@Revision", revision),
                                   new SqlParameter("@changeUserId", X.Web.WebContext.Current.User.IdentityEx.UserID));
            return RV.Value.AsInt(0);


        }


        public static int AddSegmentFromManual(int quoteId, int revision, string newSegmentData,
                                                 out int quoteSegmentId, out string errMsg)
        {
            SqlParameter RV = new SqlParameter("RetValue", SqlDbType.Int);
            RV.Direction = ParameterDirection.ReturnValue;

            SqlParameter sqlNewSegmentId = new SqlParameter("@quoteSegmentId", SqlDbType.Int);
            sqlNewSegmentId.Direction = ParameterDirection.Output;
           SqlParameter sqlErrMsg = new SqlParameter("@ErrMsg", SqlDbType.NVarChar,200);
            sqlErrMsg.Direction = ParameterDirection.Output;

            SqlHelper.ExecuteNonQuery(CommandType.StoredProcedure,
                                      "Quote_Add_SegmentFromManual",
                                     RV,
                                     new SqlParameter("@QuoteId", quoteId),
                                     new SqlParameter("@Revision", revision),
                                     new SqlParameter("@NewSegmentData", newSegmentData),
                                     new SqlParameter("@EnterUserId", X.Web.WebContext.Current.User.IdentityEx.UserID),
                                     sqlNewSegmentId,
                                     sqlErrMsg);

            quoteSegmentId = sqlNewSegmentId.Value.AsInt();
            errMsg = sqlErrMsg.Value.AsString();
            return RV.Value.AsInt(0);
        }

        public static void DeleteSegment(int quoteSegmentId)
        {
            SqlHelper.ExecuteNonQuery("Quote_delete_Segment", quoteSegmentId, X.Web.WebContext.Current.User.IdentityEx.UserID);
        }

        public static int AddSegmentFromQuote(int quoteId, int revision, string newSegmentData, int copyNotes, out string errMsg)
        {
            SqlParameter RV = new SqlParameter("RetValue", SqlDbType.Int);
            RV.Direction = ParameterDirection.ReturnValue;

            SqlParameter sqlErrMsg = new SqlParameter("@ErrMsg", SqlDbType.NVarChar, 200);
            sqlErrMsg.Direction = ParameterDirection.Output;

            SqlHelper.ExecuteNonQuery(CommandType.StoredProcedure,
                                      "Quote_Add_SegmentFromQuoteSegments",
                                     RV,
                                     new SqlParameter("@QuoteId", quoteId),
                                     new SqlParameter("@Revision", revision),
                                     new SqlParameter("@NewSegmentData", newSegmentData),
                                     new SqlParameter("@CopyNotes", copyNotes),
                                     new SqlParameter("@EnterUserId", X.Web.WebContext.Current.User.IdentityEx.UserID),
                                     sqlErrMsg);

            errMsg = sqlErrMsg.Value.AsString();
            return RV.Value.AsInt(0);
        }
        public static int AddSegmentFromWorkorder(int quoteId, int revision, string newSegmentData, int copyNotes, out string errMsg)
        {
            SqlParameter RV = new SqlParameter("RetValue", SqlDbType.Int);
            RV.Direction = ParameterDirection.ReturnValue;

            SqlParameter sqlErrMsg = new SqlParameter("@ErrMsg", SqlDbType.NVarChar, 200);
            sqlErrMsg.Direction = ParameterDirection.Output;

            SqlHelper.ExecuteNonQuery(CommandType.StoredProcedure,
                                      "Quote_Add_SegmentFromWOSegments",
                                     RV,
                                     new SqlParameter("@QuoteId", quoteId),
                                     new SqlParameter("@Revision", revision),
                                     new SqlParameter("@NewSegmentData", newSegmentData),
                                     new SqlParameter("@LockPart", 1),
                                     new SqlParameter("@CopyHeaderNotes", 0),
                                     new SqlParameter("@CopyNotes", copyNotes),
                                     new SqlParameter("@EnterUserId", X.Web.WebContext.Current.User.IdentityEx.UserID),
                                     sqlErrMsg);

            errMsg = sqlErrMsg.Value.AsString();
            return RV.Value.AsInt(0);
        }

        //<CODE_TAG_101936>
        public static int AddSegmentFromStandardJob(int quoteId, int revision, string NewSegmentData, int copyNotes, string sType, out string errMsg)
        {
            SqlParameter RV = new SqlParameter("RetValue", SqlDbType.Int);
            RV.Direction = ParameterDirection.ReturnValue;

            SqlParameter sqlErrMsg = new SqlParameter("@ErrMsg", SqlDbType.NVarChar, 200);
            sqlErrMsg.Direction = ParameterDirection.Output;

            SqlHelper.ExecuteNonQuery(CommandType.StoredProcedure,
                                      "Quote_Add_SegmentFromStandardJob2", //<CODE_TAG_101936>
                                     RV,
                                     new SqlParameter("@QuoteId", quoteId),
                                     new SqlParameter("@Revision", revision),
                                     new SqlParameter("@NewSegmentData", NewSegmentData),
                                     new SqlParameter("@CopyNotes", copyNotes),
                                     new SqlParameter("@EnterUserId", X.Web.WebContext.Current.User.IdentityEx.UserID),
                                     new SqlParameter("@SourceType", sType),
                                     sqlErrMsg);

            errMsg = sqlErrMsg.Value.AsString();
            return RV.Value.AsInt(0);
        }//</CODE_TAG_101936>

        public static void DeleteQuote(int quoteId, int deleteType)
        {
            SqlHelper.ExecuteNonQuery("Quote_Delete", quoteId, deleteType, X.Web.WebContext.Current.User.IdentityEx.UserID);
        }

        public static DataSet Quote_Get_RevisionSegmentsTotal(int quoteId, int revision)
        {
            var data = SqlHelper.ExecuteDataset(
                      "dbo.Quote_Get_RevisionSegmentsTotal"
                      , quoteId
                      , revision
                      );
            return data;

        }
        //<CODE_TAG_105545>R.Z
        public static DataSet Code_Quote_Status_List()
        {
            var data = SqlHelper.ExecuteDataset(
                      "dbo.Codes_Quote_Status_List"

                      );
            return data;

        }
        public static void UpdateQuoteStatusFromQuoteList(int quoteId, int quoteStatusId, int createTicket)
        {
            //SqlHelper.ExecuteNonQuery("ERP_API_Ticket_Update", quoteId, revision, X.Web.WebContext.Current.User.IdentityEx.UserID);
            SqlHelper.ExecuteNonQuery("Quote_Edit_Status_FromQuoteList", quoteId, quoteStatusId,createTicket, X.Web.WebContext.Current.User.IdentityEx.UserID);
        }
        //</CODE_TAG_105545>

        public static DataSet QuoteGetSegmentsBySearch (string searchField, string op, string keyword)
        {
            var data = SqlHelper.ExecuteDataset(
                      "dbo.Quote_Get_SegmentsListBySearch"
                      , searchField
                      , op
                      , keyword
                      );
            return data;

        }

        public static DataSet QuoteGetCustomersBySearch(string searchField, string op, string keyword)
        {
            var data = SqlHelper.ExecuteDataset(
                      "dbo.Quote_Get_CustomersListBySearch"
                      , searchField
                      , op
                      , keyword
                      );
            return data;

        }

        public static DataSet QuoteGetWoSegmentsBySearch(string keyword)
        {
            var data = SqlHelper.ExecuteDataset(
                      "dbo.Quote_Get_WOListBySearch"
                      , keyword
                      );
            return data;

        }

        public static DataSet QuoteGetSegmentsByIds(string Ids)
        {
            var data = SqlHelper.ExecuteDataset("dbo.Quote_Get_SegmentsListByIds", Ids);
            return data;
        }

        public static DataSet QuoteGetWOSegmentsByIds(string Ids)
        {
            var data = SqlHelper.ExecuteDataset("dbo.Quote_Get_WOSegmentListByIds", Ids);
            return data;
        }


        public static DataSet Quote_Get_RevisionList(int quoteId)
        {
            var data = SqlHelper.ExecuteDataset("dbo.Quote_Get_RevisionList", quoteId);
            return data;
        }

        public static int Quote_Get_LastSegmentId(int quoteId, int revision)
        {
            SqlParameter LastSegmentId = new SqlParameter("@LastSegmentId", SqlDbType.Int);
            LastSegmentId.Direction = ParameterDirection.Output;


            SqlHelper.ExecuteNonQuery(CommandType.StoredProcedure,
                                      "Quote_Get_LastSegmentId",
                                     new SqlParameter("@QuoteId", quoteId),
                                     new SqlParameter("@Revision", revision),
                                     LastSegmentId);

            return LastSegmentId.Value.As<int>();
        }

        public static DataSet QuoteGetAviliableOppList(string cuno, string division, int quoteTypeId)
        {
            var data = SqlHelper.ExecuteDataset("dbo.Quote_Get_AvailableOppList", cuno, division,quoteTypeId);
            return data;

        }

        public static DataSet Quote_Get_StandardJobInfo(int DBSROId, int DBSROPId)
        {
            var data = SqlHelper.ExecuteDataset("dbo.Quote_Get_StandardJobInfo", DBSROId, DBSROPId);
            return data;
        }
        //<CODE_TAG_101936>
        public static DataSet Quote_Get_StandardJobListInfo(string DBSROId, string DBSROPId, string SType)
        {
            var data = SqlHelper.ExecuteDataset("dbo.Quote_Get_StandardJobListInfo", DBSROId, DBSROPId, SType);
            return data;
        }
        //</CODE_TAG_101936>
        public static DataSet Quote_Revision_Financials_Get(int quoteId, int revision, string customerNo)
        {
            var data = SqlHelper.ExecuteDataset(
                        "dbo.Quote_Revision_Financials_Get"
                        , quoteId
                        , revision
                        , customerNo
                        );
            return data;
        }

        public static DataSet QuoteListPartForCheck(string sos, string partNo)
        {

            var data = SqlHelper.ExecuteDataset(
                   "dbo.quote_List_PartsForCheck"
                   , sos
                   , partNo
                   );
            return data;
        }
        public static string QuoteGetBranchName(string branchNo)
        {
            string rt = "";
            var data = SqlHelper.ExecuteDataset("dbo.Quote_Get_Branch", branchNo);
            if (data.Tables[0].Rows.Count  > 0)
            {
                rt = data.Tables[0].Rows[0]["BranchName"].ToString();
            }

            return rt;
        }
        public static DataSet Quote_Get_InitAdvancedSearch()
        {
            var data = SqlHelper.ExecuteDataset("dbo.Quote_Get_InitAdvancedSearch");
            return data;
        }

        public static DataSet Quote_Get_SegmentFinancials(int quoteId, int revision, string customerNo)
        {
            var data = SqlHelper.ExecuteDataset("dbo.Quote_Revision_Segment_Financials_Get", quoteId, revision, customerNo);
            return data;
        }

        public static DataSet Quote_Get_PrintConfig(int quoteId)
        {
            DataSet  data;
            if (quoteId == 0)
                data = SqlHelper.ExecuteDataset("dbo.Quote_Print_Config_UserDefault_Get", X.Web.WebContext.Current.User.IdentityEx.UserID);
            else
                data = SqlHelper.ExecuteDataset("dbo.Quote_Print_Config_Quote_Get", quoteId, X.Web.WebContext.Current.User.IdentityEx.UserID);
            return data;
        }

        public static void Quote_Save_PrintConfig(int quoteId, string strXML, int customerPrintHideSegmentDetail, int internalPrintHideSegmentDetail)
        {
            SqlHelper.ExecuteNonQuery("Quote_Print_Config_AddUpd", X.Web.WebContext.Current.User.IdentityEx.UserID, quoteId, strXML, customerPrintHideSegmentDetail, internalPrintHideSegmentDetail);
        }

        public static DataSet Quote_Get_PrintCustomer(int quoteId, int revision)
        {
            DataSet  data = SqlHelper.ExecuteDataset("dbo.Quote_Revision_PrintCustomers_Get", quoteId, revision);
            return data;
        }

        public static DataSet Quote_Get_UserPersonalization()
        {
            DataSet data = SqlHelper.ExecuteDataset("dbo.User_Personalization_Get", X.Web.WebContext.Current.User.IdentityEx.UserID);
            return data;
        }

        public static void Quote_Save_UserPersonalization(string division, string branchNo, string phoneNo, string cellPhoneNo, string faxNo)
        {
            SqlHelper.ExecuteNonQuery("User_Personalization_Update",
                                        X.Web.WebContext.Current.User.IdentityEx.UserID,
                                        0,
                                        division,
                                        branchNo ,
                                        phoneNo ,
                                        cellPhoneNo,
                                        faxNo);
        }
        public static DataSet Quote_Get_AdvancedSearch( string custNo,
                                                        string make,
                                                        string serialNo,
                                                        string model,
                                                        string jobCode,
                                                        string jobDesc,     //<CODE_TAG_103410>
                                                        string componentCode,
                                                        string componentDesc,       //<CODE_TAG_103410>
                                                        string modifierCode,
                                                        string modifierDesc,        //<CODE_TAG_103410>
                                                        string businessGroup,
                                                        string quantityCode,
                                                        string workApplicationCode,
                                                        string branchCode,
                                                        string costCentreCode,
                                                        string cabTypecde,
                                                        string shopField,
                                                        string jobLocationCode,
                                                        DateTime? fromDate,
                                                        DateTime? toDate,
                                                        string originator,  //<CODE_TAG_104104>
                                                        string owner,       //<CODE_TAG_104104>
                                                        string manager,     //<CODE_TAG_104104>
                                                        int limitRecords,
                                                        string limitType,
                                                        int querySection,
                                                        string sjSortField,
                                                        string sjSortDirection,
                                                        string woSortField,
                                                        string woSortDirection,
                                                        string quoteSortField,
                                                        string quoteSortDirection)
        {
            DataSet data = SqlHelper.ExecuteDataset("dbo.Quote_List_AdvancedSearch",  //
                                                       custNo,
                                                       make,
                                                       serialNo,
                                                       model,
                                                       jobCode,
                                                       jobDesc,             //<CODE_TAG_103410>
                                                       componentCode,
                                                       componentDesc,       //<CODE_TAG_103410>
                                                       modifierCode,
                                                       modifierDesc,        //<CODE_TAG_103410>
                                                       businessGroup,
                                                       quantityCode,
                                                       workApplicationCode,
                                                       branchCode,
                                                       costCentreCode,
                                                       cabTypecde,
                                                       shopField,
                                                       jobLocationCode,
                                                       fromDate,
                                                       toDate,
                                                       originator,           //<CODE_TAG_104104>    
                                                       owner,                //<CODE_TAG_104104>
                                                       manager,              //<CODE_TAG_104104>
                                                       limitRecords,
                                                       limitType,
                                                       querySection,
                                                       sjSortField,
                                                       sjSortDirection,
                                                       woSortField,
                                                       woSortDirection,
                                                       quoteSortField,
                                                       quoteSortDirection,
                                                       X.Web.WebContext.Current.User.IdentityEx.UserID);
            return data;
        }

        public static DataSet QuoteGetInfluencers(string cuno)
        {
            var data = SqlHelper.ExecuteDataset("dbo.Quote_List_Influencers", cuno, X.Web.WebContext.Current.User.IdentityEx.UserID);
            return data;
        }

        //<CODE_TAG_104119>
        public static void Quote_Save_CustomerFinancialItem(int quoteId, int revision, string customerNo, int financialItemId, int includeIndicator)
        {
            Quote_Save_CustomerFinancialItem(quoteId, revision, customerNo, financialItemId, includeIndicator, null);
        }
        //</CODE_TAG_104119>
        //public static void Quote_Save_CustomerFinancialItem(int quoteId, int revision, string customerNo, int financialItemId, int includeIndicator)
        public static void Quote_Save_CustomerFinancialItem(int quoteId, int revision, string customerNo, int financialItemId, int includeIndicator, decimal? financialItemAmtByManual) //<CODE_TAG_104119>
        {

            //SqlHelper.ExecuteNonQuery("Quote_AddUpdate_CustomerFinancialItem",
            //                            quoteId,
            //                            revision,
            //                            customerNo,
            //                            financialItemId,
            //                            includeIndicator,
            //                            X.Web.WebContext.Current.User.IdentityEx.UserID
            //                            );

            //<CODE_TAG_104119>
            if (financialItemAmtByManual == null)
            {
                SqlHelper.ExecuteNonQuery("Quote_AddUpdate_CustomerFinancialItem",
                                            quoteId,
                                            revision,
                                            customerNo,
                                            financialItemId,
                                            includeIndicator,
                                            X.Web.WebContext.Current.User.IdentityEx.UserID
                                            );
            }
            else
            {
                SqlHelper.ExecuteNonQuery("Quote_AddUpdate_CustomerFinancialItem",
                             quoteId,
                             revision,
                             customerNo,
                             financialItemId,
                             includeIndicator,
                             X.Web.WebContext.Current.User.IdentityEx.UserID
                             , financialItemAmtByManual
                             );
            }
            //</CODE_TAG_104119>
        }

        public static DataSet QuoteListDivision()
        {
            var data = SqlHelper.ExecuteDataset("dbo.Quote_List_Division");
            return data;
        }

        public static DataSet QuoteGetSMCSCode(string jobcode, string componentCode, string modifierCode, string businessGroupCode, string quantityCode, string branchCode, string costCentreCode )
        {
            var data = SqlHelper.ExecuteDataset("dbo.Quote_Get_SMCSDesc",
                                                jobcode,
                                                componentCode,
                                                modifierCode,
                                                businessGroupCode,
                                                quantityCode,
                                                branchCode,
                                                costCentreCode
                                              );
            return data;
        }

        public static DataSet QuoteGetIdByQuoteNo(string quoteNo)
        {
            var data = SqlHelper.ExecuteDataset("dbo.Quote_GetId_ByQuoteNo",quoteNo);
            return data;
        }

        public static void DeleteAllNotes(int quoteSegmentId)
        {
            SqlHelper.ExecuteNonQuery("Quote_delete_AllNotes", quoteSegmentId);
        }

        public static void AddNote(int quoteSegmentId, int noteType, string note, string masterIndicator, int sort)
        {
            SqlHelper.ExecuteNonQuery("Quote_Add_Note",
                                       quoteSegmentId,
                                       noteType,
                                       note,
                                       masterIndicator,
                                       sort
                                       );

        }

        public static void DeleteAllHeaderNotes(int quoteId, int revision)
        {
            SqlHelper.ExecuteNonQuery("Quote_delete_AllHeaderNotes", quoteId , revision);
        }

        public static void AddHeaderNote(int quoteId, int revision, int noteType, string note, string masterIndicator, int sort)
        {
            SqlHelper.ExecuteNonQuery("Quote_Add_HeaderNote",
                                       quoteId,
                                       revision,
                                       noteType,
                                       note,
                                       masterIndicator,
                                       sort
                                       );

        }
        public static DataSet QuoteGetSegmentCustomer(int segmentId)
        {
            var data = SqlHelper.ExecuteDataset("dbo.Quote_Get_Segment_Customer", segmentId);
            return data;
        }

        public static void EditSegmentCustomer(int quoteSegmentId, string partsCustomerNo, double partsPercent, string laborCustomerNo, double laborPercent, string miscCustomerNo, double miscPercent)
        {

            SqlHelper.ExecuteNonQuery("Quote_Edit_QuoteSegment_Customer",
                                       quoteSegmentId,
                                       partsCustomerNo,
                                       partsPercent,
                                       laborCustomerNo,
                                       laborPercent,
                                       miscCustomerNo,
                                       miscPercent,
                                       X.Web.WebContext.Current.User.IdentityEx.UserID
                                       );

        }


        public static DataSet QuoteGetStandardJobParts(int repairOptionId, int repairOptionPricingID, string selectedGroup)
        {
            var data = SqlHelper.ExecuteDataset("dbo.Quote_Get_StandardJobParts", repairOptionId, repairOptionPricingID, selectedGroup);
            return data;
        }

        public static string QuoteGetSegmentPendingParts(int segmentId)
        {
            return SqlHelper.ExecuteScalar("Quote_Get_SegmentPendingParts", segmentId).ToString();
        }

        //<Ticket 51393>R.Z
        public static string QuoteGetSegmentPendingInvalidParts(int segmentId)
        {
            return SqlHelper.ExecuteScalar("Quote_Get_SegmentPendingInvalidParts", segmentId).ToString();
        }
        //</Ticket 51393>
        public static DataSet QuoteGetOppInfo(int oppNo)
        {
            return SqlHelper.ExecuteDataset("Quote_Get_OppInfo",
                                      oppNo,
                                      X.Web.WebContext.Current.User.IdentityEx.UserID
                                      );


        }

        public static void Quote_Save_PrintConfig_Reset(int quoteId, int level) //0:user level 1:dealer level
        {
            SqlHelper.ExecuteNonQuery("Quote_Print_Config_Reset", X.Web.WebContext.Current.User.IdentityEx.UserID, quoteId, level);
        }

        public static DataSet  QuoteGetSegmentPendingDetails(int segmentId)
        {
            return SqlHelper.ExecuteDataset("Quote_Get_SegmentPendingDetail", segmentId);
        }
        //<CODE_TAG_101832> 
        public static DataSet QuoteGetSegmentRepriceRequiredList(int segmentId)
        {
            return SqlHelper.ExecuteDataset("Quote_Get_Segment_RepriceRequiredList", segmentId);
        }
        //</CODE_TAG_101832> 

        //<CODE_TAG_101986>
        public static DataSet QuoteGetDetailSegmentColumnsOrder(int DetailTypeId)
        {
            return SqlHelper.ExecuteDataset("Quote_Get_Detail_Segment_Columns_Order", DetailTypeId);
        }
        //</CODE_TAG_101986>
        public static DataSet QuoteGetUniqueLabourChargeCode(int SegmentId, int QuoteID, string STN1, string CSCC)
        {
            return SqlHelper.ExecuteDataset("Quote_Get_Unique_LabourChargeCode", SegmentId, QuoteID, CSCC, STN1);
        }
        public static DataSet QuoteGetUniqueMiscChargeCode(int SegmentId, int QuoteID, string STN1, string CSCC)
        {
            return SqlHelper.ExecuteDataset("Quote_Get_Unique_MiscChargeCode", SegmentId, QuoteID, CSCC, STN1);
        }
        //PN
        public static DataSet SaveCategorySummarySettings(int SegmentId, int CategoryId, string Note, Boolean ShowDetailFlag, Boolean ShowSummaryFlag)
        {
            int SDFlag = 1;
            int SSFlag = 1;

            if (ShowDetailFlag) SDFlag = 2;
            if (ShowSummaryFlag) SSFlag = 2;
            return SqlHelper.ExecuteDataset("Quote_Add_Segment_Revision_Category", SegmentId, CategoryId, Note, SDFlag, SSFlag);
        }


        //!!
        public static void MyWatcher_Add(string strVariableName, string strVariableValue)
        {
            SqlHelper.ExecuteNonQuery("Watcher_Add", strVariableName, strVariableValue);

        }
        //!!
        //<CODE_TAG_103339>
        //public static void Quote_Save_MultiLineNotesAndInstruction(int segmentId, string multiLineExternalNotes, string multiLineInternalNotes, string multiLineInstructionsNotes, int @IsInternalExternalNoteSame)
        public static void Quote_Save_MultiLineNotesAndInstruction(int segmentId, string multiLineExternalNotes, string multiLineInternalNotes, string multiLineInstructionsNotes)
        {
            //SqlHelper.ExecuteNonQuery("Quote_Segment_Update_MultiLineNotesAndInstructions", segmentId, multiLineExternalNotes, multiLineInternalNotes, multiLineInstructionsNotes, @IsInternalExternalNoteSame);
            SqlHelper.ExecuteNonQuery("Quote_Segment_Update_MultiLineNotesAndInstructions", segmentId, multiLineExternalNotes, multiLineInternalNotes, multiLineInstructionsNotes);

        }
        //</CODE_TAG_103339>
        //<CODE_TAG_103379>
        public static void Quote_Save_QuoteLevelMultiLineNotesAndInstruction(int QuoteId, int Revision, string multiLineExternalQuoteNotes, string multiLineInternalQuoteNotes, string multiLineQuoteSpecialInstructions)
        {
            SqlHelper.ExecuteNonQuery("Quote_Update_MultiLineNotesAndInstructions", QuoteId, Revision, multiLineExternalQuoteNotes, multiLineInternalQuoteNotes, multiLineQuoteSpecialInstructions);
        }
        //<CODE_TAG_103379>

        //<CODE_TAG_103560>
        public static DataSet QuoteGetDBSPartDocumentsBySearch(string keyword)
        {
            return SqlHelper.ExecuteDataset("Quote_Get_DBSPartDocumentsBySearch", keyword);
        }
        public static DataSet QuoteGetDBSPartDocumentListByIds(string docNo)
        {
            return SqlHelper.ExecuteDataset("Quote_Get_DBSPartDocumentListByIds", docNo);
        }
        public static int AddSegmentFromDBSPartDocuments(int quoteId, int revision, string newSegmentData, out string errMsg)
        {
            SqlParameter RV = new SqlParameter("RetValue", SqlDbType.Int);
            RV.Direction = ParameterDirection.ReturnValue;

            SqlParameter sqlErrMsg = new SqlParameter("@ErrMsg", SqlDbType.NVarChar, 200);
            sqlErrMsg.Direction = ParameterDirection.Output;

            SqlHelper.ExecuteNonQuery(CommandType.StoredProcedure,
                                      "Quote_Add_SegmentFromDBSPartDocuments",
                                     RV,
                                     new SqlParameter("@QuoteId", quoteId),
                                     new SqlParameter("@Revision", revision),
                                     new SqlParameter("@NewSegmentData", newSegmentData),
                //new SqlParameter("@LockPart", 1),
                //new SqlParameter("@CopyHeaderNotes", 0),
                //new SqlParameter("@CopyNotes", copyNotes),
                                     new SqlParameter("@EnterUserId", X.Web.WebContext.Current.User.IdentityEx.UserID),
                                     sqlErrMsg);

            errMsg = sqlErrMsg.Value.AsString();
            return RV.Value.AsInt(0);
        }
        //</CODE_TAG_103560>
        //<CODE_TAG_103600>
        public static void ImportPartsFromDBSPartDocuments(int quoteSegmentId, string docNoData)
        {


            SqlParameter sqlErrMsg = new SqlParameter("@ErrMsg", SqlDbType.NVarChar, 200);
            sqlErrMsg.Direction = ParameterDirection.Output;

            SqlHelper.ExecuteNonQuery(CommandType.StoredProcedure,
                                      "Quote_Revision_Segment_PartsAddFromDBSPartDocument",
                                     new SqlParameter("@QuoteSegmentId", quoteSegmentId),
                                     new SqlParameter("@docNo", docNoData),

                                     new SqlParameter("@EnterUserId", X.Web.WebContext.Current.User.IdentityEx.UserID)
                                     );


        }
        //</CODE_TAG_103600>
        //<CODE_TAG_103629>
         public static string GetSelectedQuoteOwnerEmail (int QuoteOwnerId )
        {
            return SqlHelper.ExecuteScalar("Quote_Get_QuoteOwnerEmail", QuoteOwnerId).ToString();
        }
        //</CODE_TAG_103629>

        public static DataSet QuoteGetTicket(int QuoteId, int Revision)
        {
            return SqlHelper.ExecuteDataset("ERP_API_Ticket_Get", QuoteId, Revision);
        }
        public static void CreateTicket(int quoteId, int revision)
        {
            SqlHelper.ExecuteNonQuery("ERP_API_Ticket_Create", quoteId, revision, X.Web.WebContext.Current.User.IdentityEx.UserID);
        }
        public static void UpdateTicket(int quoteId, int revision)
        {
            SqlHelper.ExecuteNonQuery("ERP_API_Ticket_Update", quoteId, revision, X.Web.WebContext.Current.User.IdentityEx.UserID);
        }
        public static void DeleteTicket(int quoteId, int revision)
        {
            SqlHelper.ExecuteNonQuery("ERP_API_Ticket_Delete", quoteId, revision, X.Web.WebContext.Current.User.IdentityEx.UserID);
        }

        //<CODE_TAG_103703>
        public static int GetQuoteOwnerId(int QuoteId)
        {
            return SqlHelper.ExecuteScalar("Quote_Get_SaleRepIdByQuote", QuoteId).AsInt();
        }
        //</CODE_TAG_103703>

        //<CODE_TAG_104531>
        public static DataSet GetUserSignatureInfoForEmail(int UserId)
        {
            return SqlHelper.ExecuteDataset("User_EmailSignatureInfo_Get", UserId);
        }
        //</CODE_TAG_104531>

        //<CODE_TAG_105379>R.Z
        public static int QuoteGetQuoteStatusId(int quoteId)
        {
            return SqlHelper.ExecuteScalar("Quote_Get_QuoteStatusId", quoteId).AsInt();
        }
        //</CODE_TAG_105379>

        //<CODE_TAG_105318> lwang 
        public static int QuoteGetSegmentLaborRepricing(int quoteId, int segmentId)
        {
            return SqlHelper.ExecuteScalar("Quote_Get_Segment_LaborRepricing", quoteId, segmentId).AsInt();
        }

        public static void Quote_Segment_Labor_Repriceing(int quoteId, int Revision)
        {
            SqlHelper.ExecuteNonQuery("Quote_Segment_Labor_Repricing", quoteId, Revision, X.Web.WebContext.Current.User.IdentityEx.UserID);
        }

        //</CODE_TAG_105318> lwang 
    }
}