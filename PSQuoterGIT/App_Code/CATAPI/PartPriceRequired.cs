using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.Web.Services.Protocols;
using System.Configuration;
using System.Data;
using DTO;

/// <summary>
/// Summary description for PartPriceRequired
/// </summary>
/// 

namespace CATPAI
{
    public class PartPriceRequired
    {
        public static List<PartPrice> GetPartPrice(PartPriceParamData paramData, List<PartIdentifier> parts)
        {
            PartStoreService.AllPartsAvailInput data = new PartStoreService.AllPartsAvailInput();

            data.custNo =  paramData.AccountNo; //"1588360"; 
            data.custType = "";
            data.dealerCode =  paramData.DealerCode;  //"T010"; 
            data.inNbrPartTable = parts.Count;
            data.orderType = "S";
            data.storeNo =  paramData.BranchNo;  //""; 
            data.inNbrPartTableSpecified = true;
           
            if (ConfigurationManager.AppSettings["EndUseCode"].Trim() != "")
                data.endUseCode = ConfigurationManager.AppSettings["EndUseCode"];  //victor 2011.9.15            //"PQ";


            if (ConfigurationManager.AppSettings["UseDlrSos"].Length == 1)
            {
                data.inPartTable = (
                    from part in parts
                    select new PartStoreService.AllPartsAvailInPartTable()
                    {
                        partNo = part.PartNo
                        ,
                        //ordQty = (part.Qty == 0) ? 1 : part.Qty //<CODE_TAG_101775> 
                        ordQty = (part.Qty == 0) ? 1 : ((part.Qty >= 0) ? part.Qty : Math.Abs(part.Qty)) //<CODE_TAG_101775>  //<CODE_TAG_103396>
                        ,
                        inputSos = part.SOS
                        ,
                        ordQtySpecified = true
                        ,
                        useDlrSos = ConfigurationManager.AppSettings["UseDlrSos"]           //victor 2011.9.15
                    }).ToArray();
            }
            else
            {
                data.inPartTable = (
                from part in parts
                select new PartStoreService.AllPartsAvailInPartTable()
                {
                    partNo = part.PartNo
                    ,
                    ordQty = (part.Qty == 0) ? 1 : part.Qty //<CODE_TAG_101775>
                    ,
                    inputSos = part.SOS
                    ,
                    ordQtySpecified = true
                }).ToArray();

            }


            PartStoreService.AllPartsAvailOutput[] returnData = PartPriceRequired.GetPartPrice(data);

            var i = 0;
            return (
                from priceData in returnData
                select new PartPrice(paramData, parts[i].PartNo, parts[i].SOS, parts[i++].Qty  , priceData)
            ).ToList();
        }

        public static PartStoreService.AllPartsAvailOutput[] GetPartPrice(PartStoreService.AllPartsAvailInput data)
        {
            PartStoreService.PartStoreRequiredServicePortTypeClient wsProxy = new PartStoreService.PartStoreRequiredServicePortTypeClient("PartStoreRequiredServiceSOAP11port_https");

            wsProxy.ClientCredentials.UserName.UserName = "canamwebservice";
            wsProxy.ClientCredentials.UserName.Password = "N7P6X7-n6m2z2";

            PartStoreService.AllPartsAvailOutput[] returnData = null;
            try
            {
                returnData = wsProxy.getPartsAvailInformation(data);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return returnData;
        }
    }
}