using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data;
using X.Data;
using X;
using DTO;

namespace DAL
{
    /// <summary>
    /// Summary description for PartSearch
    /// </summary>
    public class PartSearch
    {
        #region TRG_List_Parts
        public static DataSet TRG_List_Parts(int segmentID, bool getALLSegments, out int quoteID) {
            var paramQuoteId = new SqlParameter("@QuoteId", SqlDbType.Int) { Direction = ParameterDirection.Output };

            var data = SqlHelper.ExecuteDataset(
                CommandType.StoredProcedure,
                "dbo.TRG_List_Parts_BySegment",
                SqlHelper.CreateParameter("@SegmentId", SqlDbType.Int, segmentID),
                SqlHelper.CreateParameter("@GetAllSegments", SqlDbType.Bit, getALLSegments ? 1 : 0), //2009.12.17 VWang,  if user changed customer, we should refresh all segment price.
                paramQuoteId
                );

            quoteID = CType.ToInt32(paramQuoteId.Value, 0);

            return data;
        }
        #endregion

        //2009.12.17 VWang,  if user changed customer, we should refresh all segment price.
        public static void TRG_Update_PartPrice(int quoteDetailID, string unitDiscPrice, string unitSellPrice, string netSellPrice) {
            SqlHelper.ExecuteNonQuery("dbo.TRG_Edit_QuoteDetail_UnitPrice",
                                       quoteDetailID,
                                       unitDiscPrice,
                                       unitSellPrice,
                                       netSellPrice
                                      );

        }

        public static void QuoteTotalUpdate(int quoteId) {
            SqlHelper.ExecuteNonQuery("dbo.TRG_Edit_QuoteTotal", quoteId);
        }

        public static string NormalizePartNo(string sos, string partNo) {
            var paramPartNo = new SqlParameter("@PartNo", SqlDbType.VarChar, 20) { 
                Value = partNo
                ,Direction = ParameterDirection.InputOutput 
            };
            
            SqlHelper.ExecuteNonQuery(
                CommandType.StoredProcedure,
                "dbo.TRG_Normalize_PartNo",
                SqlHelper.CreateParameter("@SOS", SqlDbType.Char, 3, sos),
                paramPartNo
                );

            return paramPartNo.Value.ToString().Trim();
        }

        public static PartPriceParamData PriceParamDataGet(string division, string customerNo, string branchNo) {
            var data = SqlHelper.ExecuteDataset(
                "dbo.TRG_Get_PartPriceParamData",
                customerNo,
                division,
                branchNo
            );

            var row = data.Tables[0].Rows[0];
            
            return new PartPriceParamData{
                BranchNo = branchNo
                ,AccountNo = row.Field<string>("AccountNo")
                ,Division = row.Field<string>("Division")
                ,DealerCode = row.Field<string>("DealerCode")
                
                ,ShowCOREPriceSeparately = (2 == CType.ToInt32(row["ShowCOREPriceSeparatelyInd"], 0))
                ,COREPriceUseBusinessSystemSource = (2 == CType.ToInt32(row["COREPriceUseBusinessSystemSourceInd"], 0))
            };
        }

        //<BEGIN-fxiao, 2010-01-08::Get CORE prices from DBS>
        public static double GetCOREPriceFromBusinessSystem(string SOS, string partNo) {
            var reader = SqlHelper.ExecuteReader(
                "dbo.TRG_Get_PartPrice"
                ,SOS
                ,partNo
            );

            double corePrice = 0;

            if (reader.Read()) {
                corePrice = CType.ToDouble(reader["CorePrice"], 0);
            }

            reader.Close();

            return corePrice;
        }

        //</END-fxiao,2010-01-08>
    }
}
