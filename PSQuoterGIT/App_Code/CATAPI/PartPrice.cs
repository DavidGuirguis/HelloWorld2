using AppContext = Canam.AppContext;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DTO;
using X;
using X.Text;
using PartStoreOptionalService;
using System.Text;

/// <summary>
/// Summary description for PartPrice
/// </summary>
/// 

namespace CATPAI
{
    public class BoInfo
    {
        public int BoQty ;
        public string BoFacCode;
        public string BoFacName;
        public string BoFacType;
    }

    public class PartPrice
    {
        #region Member fields
        private PartPrice[] _replacements;
        private PartPrice[] _alternates;
        private string partNo;
        private string partDesc;
        private string sos;
        private double? unitDisc;
        private double? unitSell;
        private double? unitNet;
        private string coreDesc;
        private double? coreUnitSell;
        private double? coreExtdSell;
        private string errorCode;
        private string errorMessage;
        private int qty = 0; //<CODE_TAG_105815>R.Z
        private string factoryFlag = "";  
        
        #endregion

        #region ctor
        //<CODE_TAG_100754>Use new constructor to instantiate an instance for error</CODE_TAG_100754>
        public PartPrice(string partNo, string errorCode, string errorMessage)
        {
            this.PartNo = partNo;
            this.ErrorCode = errorCode;
            this.ErrorMessage = errorMessage;
        }

        public PartPrice(PartPriceParamData paramData, string partNo, string sos, int qty, PartStoreService.AllPartsAvailOutput priceData)
        {
            SosProvided = true;//<CODE_TAG_100754>Indicate whether SOS was provided</CODE_TAG_100754>
            Sos = sos;
            PartNo = partNo;
            PartDesc = priceData.desc;
            Qty = qty;

            
            ErrorCode = priceData.errorCode;
            ErrorMessage = priceData.errorMessage;

            //Not valid
            if (false == Valid) return;

            //Replacements
            if (priceData.repl != null)
            {
                Replacements = (
                    from replPart in priceData.repl
                    select new PartPrice(paramData, replPart)
                ).ToArray();
            }
            ReplacementsFound = Replacements != null && Replacements.Length > 0;
            //Comment out here for <CODE_TAG_101973>
            //if (ReplacementsFound)
            //{
            //    foreach (PartPrice rp in Replacements)
            //    {
            //        rp.Qty = qty;
            //    }
            //}
            //</CODE_TAG_101973>

            //<CODE_TAG_102102>
            if (ReplacementsFound)
            {
                foreach (PartPrice rp in Replacements)
                {
                    //rp.Qty = qty;
                    /*comment here because it has allready been devided by qty before reach here  */
                    //<CODE_TAG_102215> Victor20130920
                    //if (qty != 0)
                    //    rp.UnitNet = rp.UnitNet / qty;
                    //</CODE_TAG_102215>
                    if (qty == 0)  //<CODE_TAG_105815>R.Z when part from standard job the part qty is 0, the replacement part should be 0 instead of 1 from CAT part Store
                        rp.qty = 0;

                }
            }
            //</CODE_TAG_102102>

            //Alternates
            //<CODE_TAG_100754>Add xref parts
            PartPrice[] alternates = new PartPrice[] { };
            if (priceData.altPart != null)
            {
                alternates = alternates.Concat(
                    from altPart in priceData.altPart
                    select new PartPrice(paramData, altPart)
                ).ToArray();
            }
            if (priceData.xref != null)
            {
                alternates = alternates.Concat(
                    from altPart in priceData.xref
                    select new PartPrice(paramData, altPart)
                ).ToArray();
            }
            if (alternates.Length > 0) Alternates = alternates;
            
            AlternatesFound = Alternates != null && Alternates.Length > 0;
            if (AlternatesFound)
            {
                foreach (PartPrice ap in alternates)
                {
                    ap.Qty = qty;
                    //<CODE_TAG_102102>  //sep 9, 2013 added
                    if (qty != 0)
                        ap.UnitNet = ap.UnitNet / qty;
                    //</CODE_TAG_102102>
                }
            }



            CoreDesc = priceData.coreDesc;
            CoreUnitSell = priceData.coreUnitSell;
            CoreExtdSell = priceData.extdCoreSell;
            UnitDisc = priceData.unitDisc;
            
            //if (AppContext.Current.AppSettings["psQuoter.PartPrice.CAT.SellPrice.Source"].Trim().ToUpper() == "NET")
            //{
            //        if (qty > 0)
            //            UnitNet = priceData.extdNet / qty;
            //        else
            //            UnitNet = priceData.extdNet;
            //}
            //else
            //{
            //    UnitNet = priceData.unitSell; 
            //}
            //<CODE_TAG_102215> Victor20130920
            //if (qty > 0)
                  //UnitNet = priceData.extdNet / qty;
            //<CODE_TAG_103396>
            if (qty != 0)
            {
                //UnitNet = priceData.extdNet / qty;
                //<CODE_TAG_103517>
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.ExcludeCorePartFromSellPrice") && CoreUnitSell != 0)
                    UnitNet = priceData.extdNet / qty - CoreUnitSell;
                else
                    UnitNet = priceData.extdNet / qty;
                //</CODE_TAG_103517>
                if (UnitNet < 0)
                    UnitNet = (-1) * (UnitNet);
            }
            //</CODE_TAG_103396>
            else
            {
                //UnitNet = priceData.extdNet;
                //<CODE_TAG_103517>
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.ExcludeCorePartFromSellPrice") && CoreUnitSell != 0)
                    UnitNet = priceData.extdNet - CoreUnitSell;
                else
                    UnitNet = priceData.extdNet;
                //</CODE_TAG_103517>
            }
              //</CODE_TAG_102215>


            UnitSell = priceData.unitSell;

            UnitWeight = priceData.unitWeight;
            AvailableQty = priceData.qtyOnHand.Value ;
            QtyOnhand = priceData.qtyOnHand.Value;

            BoInfo bo;
            string branchName;

            if (priceData.bo != null)
            {
                    for (int i = 0; i < priceData.bo.Length; i++)
                    {
                        if (priceData.bo[i].boFac != "REPL" && priceData.bo[i].boFac != "RPLCAT")
                        {
                            AvailableQty += priceData.bo[i].boQty.Value;
                            bo = new BoInfo();
                            bo.BoQty = priceData.bo[i].boQty.Value;
                            bo.BoFacCode = priceData.bo[i].boFac;
                            branchName = DAL.Quote.QuoteGetBranchName(bo.BoFacCode);
                            if (branchName != "")
                            {
                                bo.BoFacName = branchName;
                                bo.BoFacType = "BRANCH";
                            }
                            else
                            {
                                bo.BoFacType = "CAT";
                            }
                            if (BackOrders == null) BackOrders = new List<BoInfo>();
                            BackOrders.Add(bo);
                        }
                }
            }
            



            if (priceData.bo != null)
            {
                if (priceData.bo.Length > 0)
                    factoryFlag = priceData.bo[0].boFac;
            }
            Normalize(paramData);
        }

        private PartPrice(PartPriceParamData paramData, PartStoreService.AltPartsAvailAltPartInformation priceData)
        {
            Sos = priceData.sos;
            PartNo = DAL.PartSearch.NormalizePartNo(Sos, priceData.partNo);
            PartDesc = priceData.desc;

            CoreDesc = priceData.coreDesc;
            CoreUnitSell = priceData.coreUnitSell;
            CoreExtdSell = priceData.extdCoreSell;
            UnitDisc = priceData.unitDisc;
            //UnitNet = priceData.netPrice; //<CODE_TAG_101756> unitSell; // netPrice;  //Victor 2013-06-19
            //<CODE_TAG_103517>
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.ExcludeCorePartFromSellPrice") && CoreUnitSell != 0)
                UnitNet = priceData.netPrice - CoreUnitSell;
            else
                UnitNet = priceData.netPrice; //<CODE_TAG_101756> unitSell; // netPrice;  //Victor 2013-06-19
            //</CODE_TAG_103517>

            UnitSell = priceData.unitSell; // extdSell;
            
            if (priceData.bo != null)
            {
                if (priceData.bo.Length > 0)
                    factoryFlag = priceData.bo[0].boFac;
            }

            UnitWeight = priceData.unitWeight;
            AvailableQty = priceData.onHand.Value ;
            QtyOnhand = priceData.onHand.Value ;

            BoInfo bo;
            string branchName;
            if (priceData.bo != null)
            {
                for (int i = 0; i < priceData.bo.Length; i++)
                {
                    if (priceData.bo[i].boFac != "REPL" && priceData.bo[i].boFac != "RPLCAT")
                    {
                        AvailableQty += priceData.bo[i].boQty.Value;
                        bo = new BoInfo();
                        bo.BoQty = priceData.bo[i].boQty.Value;
                        bo.BoFacCode = priceData.bo[i].boFac;
                        branchName = DAL.Quote.QuoteGetBranchName(bo.BoFacCode);
                        if (branchName != "")
                        {
                            bo.BoFacName = branchName;
                            bo.BoFacType = "BRANCH";
                        }
                        else
                        {
                            bo.BoFacType = "CAT";
                        }
                        if (BackOrders == null) BackOrders = new List<BoInfo>();
                        BackOrders.Add(bo);
                    }
                }
            }
            

            Normalize(paramData);//<fxiao, 2010-01-08::Get CORE prices from DBS - Normalize values />
        }

        private PartPrice(PartPriceParamData paramData, PartStoreService.AllPartsAvailXRefInformation priceData)
        {
            Sos = priceData.sos;
            PartNo = DAL.PartSearch.NormalizePartNo(Sos, priceData.partNo);
            PartDesc = priceData.desc;

            CoreDesc = priceData.coreDesc;
            CoreUnitSell = priceData.coreUnitSell;
            CoreExtdSell = priceData.extdCoreSell;
            UnitDisc = priceData.unitDisc;
            //UnitNet = priceData.unitSell; // <CODE_TAG_101756> netPrice;  //Victor 2013-06-19
            //UnitNet = priceData.netPrice; // <CODE_TAG_101756> netPrice;  //Victor 2013-06-19
            //<CODE_TAG_103517>
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.ExcludeCorePartFromSellPrice") && CoreUnitSell != 0)
                UnitNet = priceData.netPrice - CoreUnitSell;
            else
                UnitNet = priceData.netPrice; // <CODE_TAG_101756> netPrice;  //Victor 2013-06-19
            //</CODE_TAG_103517>
            UnitSell = priceData.unitSell; // extdSell;


            if (priceData.bo != null)
            {
                if (priceData.bo.Length > 0)
                    factoryFlag = priceData.bo[0].boFac;
            }


            UnitWeight = priceData.unitWeight;
            AvailableQty = priceData.onHand.Value ;
            QtyOnhand = priceData.onHand.Value ;

            BoInfo bo;
            string branchName;
            if (priceData.bo != null)
            {
                for (int i = 0; i < priceData.bo.Length; i++)
                {
                    if (priceData.bo[i].boFac != "REPL" && priceData.bo[i].boFac != "RPLCAT")
                    {
                        AvailableQty += priceData.bo[i].boQty.Value;
                        bo = new BoInfo();
                        bo.BoQty = priceData.bo[i].boQty.Value;
                        bo.BoFacCode = priceData.bo[i].boFac;
                        branchName = DAL.Quote.QuoteGetBranchName(bo.BoFacCode);
                        if (branchName != "")
                        {
                            bo.BoFacName = branchName;
                            bo.BoFacType = "BRANCH";
                        }
                        else
                        {
                            bo.BoFacType = "CAT";
                        }
                        if (BackOrders == null) BackOrders = new List<BoInfo>();
                        BackOrders.Add(bo);
                    }
                }
            }
            
            Normalize(paramData);
        }

        private PartPrice(PartPriceParamData paramData, PartStoreService.AllPartsAvailReplInformation priceData)
        {
            Sos = priceData.replSos;
            PartNo = DAL.PartSearch.NormalizePartNo(Sos, priceData.replPartNo);
            PartDesc = priceData.replDesc;
            CoreDesc = priceData.coreDesc;
            CoreUnitSell = priceData.coreUnitSell;
            CoreExtdSell = priceData.extdCoreSell;
            UnitDisc = priceData.unitDisc;
            //<CODE_TAG_102215> Victor20130920
            int totalqty = 1;
            if (priceData.orderQty.HasValue)
                totalqty = priceData.orderQty.Value;
            //UnitNet = priceData.netPrice / totalqty; //unitSell; // netPrice;
            //</CODE_TAG_102215>
            //<CODE_TAG_103517>
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.ExcludeCorePartFromSellPrice") && CoreUnitSell != 0)
                UnitNet = priceData.netPrice / totalqty - CoreUnitSell;
            else
                UnitNet = priceData.netPrice / totalqty; //unitSell; // netPrice;
            //</CODE_TAG_103517>

            UnitSell = priceData.unitSell; // extdSell;

            if (priceData.orderQty.HasValue)
                Qty = priceData.orderQty.Value;
            if (priceData.bo != null)
            {
                if (priceData.bo.Length > 0)
                    factoryFlag = priceData.bo[0].boFac;
            }

            UnitWeight = priceData.unitWeight;
            AvailableQty = priceData.onHand.Value ;
            QtyOnhand = priceData.onHand.Value;

            BoInfo bo;
            string branchName;
            if (priceData.bo != null)
            {
                for (int i = 0; i < priceData.bo.Length; i++)
                {
                    if (priceData.bo[i].boFac != "REPL" && priceData.bo[i].boFac != "RPLCAT")
                    {
                        AvailableQty += priceData.bo[i].boQty.Value;
                        bo = new BoInfo();
                        bo.BoQty = priceData.bo[i].boQty.Value;
                        bo.BoFacCode = priceData.bo[i].boFac;
                        branchName = DAL.Quote.QuoteGetBranchName(bo.BoFacCode);
                        if (branchName != "")
                        {
                            bo.BoFacName = branchName;
                            bo.BoFacType = "BRANCH";
                        }
                        else
                        {
                            bo.BoFacType = "CAT";
                        }
                        if (BackOrders == null) BackOrders = new List<BoInfo>();
                        BackOrders.Add(bo);
                    }
                }
            }
            

            Normalize(paramData);//<fxiao, 2010-01-08::Get CORE prices from DBS - Normalize values />
        }
        
        //public PartPrice(PartPriceParamData paramData, string partNo, AllSOSDetailInformation priceData)
        public PartPrice(PartPriceParamData paramData, string partNo, int qty, AllSOSDetailInformation priceData)//<CODE_TAG_102215> Victor20130920
        {
            Sos = priceData.sos;
            PartNo = partNo;
            PartDesc = priceData.desc;

            ReplacementsFound = priceData.replFound != null && priceData.replFound.ToUpper() == "Y";
            AlternatesFound = (priceData.altFound != null && priceData.altFound.ToUpper() == "Y")
                || (priceData.remanXRefFound != null && priceData.remanXRefFound.ToUpper() == "Y")
            ;

           

            CoreDesc = priceData.coreDesc;
            CoreUnitSell = priceData.coreUnitSell;
            CoreExtdSell = priceData.extdCoreSell;
            UnitDisc = priceData.unitDisc;
            
            //UnitNet = priceData.unitSell; //<CODE_TAG_101756> netPrice; 
            //<CODE_TAG_102215> Victor20130920
            if (qty > 0)
            {
                //UnitNet = priceData.extdNet / qty;
                //<CODE_TAG_103517>
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.ExcludeCorePartFromSellPrice") && CoreUnitSell != 0)
                    UnitNet = priceData.extdNet / qty - CoreUnitSell;
                else
                    UnitNet = priceData.extdNet / qty;
                //</CODE_TAG_103517>
            }
            else
            {
                //UnitNet = priceData.extdNet;
                //UnitNet = priceData.extdNet / qty;
                //<CODE_TAG_103517>
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.ExcludeCorePartFromSellPrice") && CoreUnitSell != 0)
                    UnitNet = priceData.extdNet / qty - CoreUnitSell;
                else
                    UnitNet = priceData.extdNet / qty;
                //<CODE_TAG_103517>
            }
            //</CODE_TAG_102215>

            UnitSell = priceData.unitSell; // extdSell;

            if (priceData.bo != null)
            {
                if (priceData.bo.Length > 0)
                    factoryFlag = priceData.bo[0].boFac;
            }
            //UnitWeight = priceData.unitWeight;

            AvailableQty = priceData.qtyOnHand.Value;
            QtyOnhand = priceData.qtyOnHand.Value;

            BoInfo bo;
            string branchName;
            if (priceData.bo != null)
            {
                for (int i = 0; i < priceData.bo.Length; i++)
                {
                    if (priceData.bo[i].boFac != "REPL" && priceData.bo[i].boFac != "RPLCAT")
                    {

                        AvailableQty += priceData.bo[i].boQty.Value;
                        bo = new BoInfo();
                        bo.BoQty = priceData.bo[i].boQty.Value;
                        bo.BoFacCode = priceData.bo[i].boFac;
                        branchName = DAL.Quote.QuoteGetBranchName(bo.BoFacCode);
                        if (branchName != "")
                        {
                            bo.BoFacName = branchName;
                            bo.BoFacType = "BRANCH";
                        }
                        else
                        {
                            bo.BoFacType = "CAT";
                        }
                        if (BackOrders == null) BackOrders = new List<BoInfo>();
                        BackOrders.Add(bo);
                    }
                }
            }
            


            Normalize(paramData);//<fxiao, 2010-01-08::Get CORE prices from DBS - Normalize values />
        }
        #endregion

        #region Properties
        public PartPrice[] Replacements
        {
            get
            {
                if (_replacements == null) _replacements = new PartPrice[0];

                return _replacements;
            }
            private set
            {
                _replacements = NormalizePartItems(value);
            }
        }
        public bool ReplacementsFound { get; set; }

        public PartPrice[] Alternates
        {
            get
            {
                if (_alternates == null) _alternates = new PartPrice[0];

                return _alternates;
            }
            private set
            {
                _alternates = NormalizePartItems(value);
            }
        }
        public bool AlternatesFound { get; set; }


        public double? CoreExtdSell
        {
            get { return coreExtdSell; }
            private set { coreExtdSell = value; }
        }
        public double? CoreUnitSell
        {
            get { return coreUnitSell; }
            private set { coreUnitSell = value; }
        }
        public double? UnitNet
        {
            get { return unitNet; }
            private set { unitNet = value; }
        }
        public double? UnitSell
        {
            get { return unitSell; }
            private set { unitSell = value; }
        }
        public double? UnitDisc
        {
            get { return unitDisc; }
            private set { unitDisc = value; }
        }
        public string ErrorMessage
        {
            get { return errorMessage; }
            set { errorMessage = value; }
        }
        public string ErrorCode
        {
            get { return errorCode; }
            set { errorCode = value; }
        }
        public string CoreDesc
        {
            get { return coreDesc; }
            private set { coreDesc = value; }
        }
        public string Sos
        {
            get { return sos; }
            set { sos = value; }
        }
        public int QtyOnhand = 0;
        public List<BoInfo> BackOrders ;
        //<CODE_TAG_101003>
        public string FactoryFlag
        {
            get { return factoryFlag; }
            set { factoryFlag = value; }
        }

        //<CODE_TAG_100754>Indicate whether SOS was provided</CODE_TAG_100754>
        public bool SosProvided { get; private set; }
        public string PartDesc
        {
            get { return partDesc; }
            set { partDesc = value; }
        }
        public string PartNo
        {
            get { return partNo; }
            set { partNo = value; }
        }
        //<CODE_TAG_100940>
        public int Qty
        {
            get { return qty; }
            set { qty = value; }
        }

        public bool Valid
        {
            get
            {
                return StringHelper.IsNullOrEmpty(ErrorCode) && StringHelper.IsNullOrEmpty(ErrorMessage);
            }
        }

        public double? UnitWeight { get; set; }
        public int AvailableQty  {get; set;}

        public double Discount { get; set; }        //<CODE_TAG_104427> Dav
        #endregion

        #region Methods
        private PartPrice[] NormalizePartItems(PartPrice[] items)
        {
            return items.Where(i => PartIdentifier.HasSOS(i.Sos)
                || false == StringHelper.IsNullOrEmpty(i.PartNo)
                || false == StringHelper.IsNullOrEmpty(i.PartDesc)
            ).ToArray()
            ;
        }

        //<BEGIN-fxiao, 2010-01-08::Get CORE prices from DBS - normalize CORE>
        private void Normalize(PartPriceParamData paramData)
        {
            //CORE shown separately
            var corePrice = CType.ToDouble(CoreExtdSell, 0);
            if (corePrice != 0)
            {

                //take off CORE price
                if (UnitNet.HasValue)
                {
                  //  UnitNet = Math.Round((double)UnitNet - corePrice, 2);
                }


                if (paramData.ShowCOREPriceSeparately //<CODE_TAG_100358>moved from outer if to remove CORE from unit net if the key is turned off</CODE_TAG_100358>
                    && paramData.COREPriceUseBusinessSystemSource
                )
                {
                    double corePriceFromBusinessSystem = 0;

                    corePriceFromBusinessSystem = DAL.PartSearch.GetCOREPriceFromBusinessSystem(Sos, PartNo);

                    //use price from business system
                    // if (corePriceFromBusinessSystem != 0) corePrice = corePriceFromBusinessSystem;
                    if (corePriceFromBusinessSystem != 0) CoreExtdSell = corePriceFromBusinessSystem;
                }
            }
        }
        //</END-fxiao, 2010-01-08>

        private string ToJSON(bool serializeChildren, string members)
        {
            StringBuilder json = new StringBuilder();

            serializeChildren = serializeChildren && Valid;

            json.Append("{");

            //custom members
            if (false == StringHelper.IsNullOrEmpty(members))
            {
                json.Append(members);
                json.Append(",");
            }

            json.AppendFormat("partNo:\"{0}\"", StringUtils.JSONEscape(PartNo));
            json.AppendFormat(",sos:\"{0}\"", StringUtils.JSONEscape(Sos));
            json.AppendFormat(",sosProvided:{0}", SosProvided ? "true" : "false");//<CODE_TAG_100754>Indicate whether SOS was provided</CODE_TAG_100754>
            json.AppendFormat(",desc:\"{0}\"", StringUtils.JSONEscape(PartDesc));
            json.AppendFormat(",unitSell:\"{0:#,##0.00}\"", Valid ? UnitSell : null);
            json.AppendFormat(",unitDisc:\"{0:#,##0.00}\"", Valid ? UnitDisc : null);
            json.AppendFormat(",unitNet:\"{0:#,##0.00}\"", Valid ? UnitNet : null);
            json.AppendFormat(",corePrice:\"{0:#,##0.00}\"", Valid ? CoreExtdSell : null);
            json.AppendFormat(",factoryFlag:\"{0}\"", StringUtils.JSONEscape(FactoryFlag));
            json.AppendFormat(",qty:\"{0}\"", Qty);
            json.AppendFormat(",unitWeight:\"{0}\"", UnitWeight );
            json.AppendFormat(",AvailableQty:\"{0}\"", AvailableQty);
            json.AppendFormat(",BoCount:\"{0}\"", BackOrders.Count());
            int i = 0;
            foreach (BoInfo bo in BackOrders)
            {
                json.AppendFormat(",BoFacCode" + i.ToString() + ":\"{0}\"", bo.BoFacCode);
                json.AppendFormat(",BoFacName" + i.ToString() + ":\"{0}\"", StringUtils.JSONEscape(bo.BoFacName));
                json.AppendFormat(",BoFacType" + i.ToString() + ":\"{0}\"", bo.BoFacType);
                json.AppendFormat(",BoQty" + i.ToString() + ":\"{0}\"", bo.BoQty);
                i++;
            }

            //execution status
            json.AppendFormat(",error:{0}",
                Valid ? "null" : String.Format("\"{0}\"", StringUtils.JSONEscape(ErrorMessage + " [" + ErrorCode + "]"))
            );

            //Replacements
            json.AppendFormat(",replPartsFound:{0}", ReplacementsFound ? "true" : "false");
            json.AppendFormat(",replParts:[{0}]",
                serializeChildren == false ? "" : String.Join(",", (
                    from item in Replacements
                    select item.ToJSON(false, null)
                ).ToArray())
            );

            //Alternates
            json.AppendFormat(",altPartsFound:{0}", AlternatesFound ? "true" : "false");
            json.AppendFormat(",altParts:[{0}]",
                serializeChildren == false ? "" : String.Join(",", (
                    from item in Alternates
                    select item.ToJSON(false, null)
                ).ToArray())
            );

            json.Append("}");

            return json.ToString();
        }

        public string ToJSON()
        {
            return ToJSON(true, null);
        }

        public string ToJSON(string members)
        {
            return ToJSON(true, members);
        }
        #endregion
    }
}

