using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.Web.Services.Protocols;
using System.Data;
using DTO;


/// <summary>
/// Summary description for PartPriceOptional
/// </summary>
/// 

namespace CATPAI
{
    public class PartPriceOptional
    {
        public static List<PartPrice> GetPartPrice(PartPriceParamData paramData, List<PartIdentifier> parts)
        {
            PartStoreOptionalService.getSOSInformationRequest data1 = new PartStoreOptionalService.getSOSInformationRequest();
            PartStoreOptionalService.AllSOSInput data = new PartStoreOptionalService.AllSOSInput();
            data.custNo = paramData.AccountNo;
            data.custType = "";
            data.dealerCode = paramData.DealerCode;
            data.inNbrPartTable = parts.Count;
            data.orderType = "S";
            data.storeNo = paramData.BranchNo;
            data.inNbrPartTableSpecified = true;
            data.inPartTable = (
                from part in parts
                select new PartStoreOptionalService.AllSOSInPartTable()
                {
                    partNo = part.PartNo
                    ,
                    ordQty = 1
                    ,
                    ordQtySpecified = true
                }).ToArray();

            data1.input = data;
            PartStoreOptionalService.AllSOSOutput[] returnData = PartPriceOptional.GetPartPrice(data1);
            List<PartPrice> PartPriceList = new List<PartPrice>();

            var idxPart = 0;
            foreach (PartStoreOptionalService.AllSOSOutput a in returnData)
            {
                var partID = parts[idxPart++];

                if (a.errorCode != "")
                {
                    PartPriceList.Add(new PartPrice(partID.PartNo, a.errorCode, a.errorMessage));//<CODE_TAG_100754>Use new constructor to instantiate an instance for error</CODE_TAG_100754>
                }
                else
                {
                    foreach (PartStoreOptionalService.AllSOSDetailInformation b in a.sosDetail)
                    {
                        PartPriceList.Add(new PartPrice(paramData, partID.PartNo, 1, b)); //<CODE_TAG_102215> Victor20130920
                    }
                }
            }
            return PartPriceList;
        }

        public static PartStoreOptionalService.AllSOSOutput[] GetPartPrice(PartStoreOptionalService.getSOSInformationRequest data)
        {
            PartStoreOptionalService.PartStoreOptionalServicePortTypeClient wsProxy = new PartStoreOptionalService.PartStoreOptionalServicePortTypeClient("PartStoreOptionalServiceSOAP11port_https");
            wsProxy.ClientCredentials.UserName.UserName = "canamwebservice";
            wsProxy.ClientCredentials.UserName.Password = "N7P6X7-n6m2z2";
            PartStoreOptionalService.AllSOSOutput[] returnData = null;
            try
            {
                //returnData = wsProxy.getSOSInformation(data).@return;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return returnData;
        }
    }
}