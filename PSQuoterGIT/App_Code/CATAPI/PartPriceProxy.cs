using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DTO;

/// <summary>
/// Summary description for PartPriceProxy
/// </summary>
/// 
namespace CATPAI
{
    public static class PartPriceProxy
    {
        public static List<PartPrice> GetPartPrice(string division, string customerNo, string branchNo, PartIdentifier part)
        {
            var parts = new List<PartIdentifier>();
            parts.Add(part);

            return GetPartPrice(division, customerNo, branchNo, parts);
        }

        public static List<PartPrice> GetPartPrice(string division, string customerNo, string branchNo, List<PartIdentifier> parts)
        {
            //no parts
            if (parts.Count == 0) return new List<PartPrice>();

            var paramData = DAL.PartSearch.PriceParamDataGet(division, customerNo, branchNo);

            if (parts[0].SOSExists)
                //Required SOS
                return PartPriceRequired.GetPartPrice(paramData, parts);
            else
                //Optional SOS
                return PartPriceOptional.GetPartPrice(paramData, parts);
        }
    }
}