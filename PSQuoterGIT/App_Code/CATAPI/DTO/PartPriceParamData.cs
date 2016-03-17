using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DTO {
    /// <summary>
    /// Summary description for PartPriceParamData
    /// </summary>
    public class PartPriceParamData {
        #region Module vars
        private string _dealerCode;
        #endregion

        public string BranchNo { get; set; }
        public string AccountNo { get; set; }
        public string Division { get; set; }
        public string DealerCode {
            get {
                return _dealerCode;
            }
            set {
                _dealerCode = value;
                if (_dealerCode != null) _dealerCode = _dealerCode.Trim();
            }
        }

        //<BEGIN-fxiao, 2010-01-08::Get CORE prices from DBS>
        public bool ShowCOREPriceSeparately { get; set; }
        public bool COREPriceUseBusinessSystemSource { get; set; }
        //</END-fxiao, 2010-01-08>
    }
}