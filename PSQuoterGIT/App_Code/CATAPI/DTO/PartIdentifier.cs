using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using X.Text;

namespace DTO
{
    /// <summary>
    /// Summary description for PartIdentifier
    /// </summary>
    public class PartIdentifier
    {
        #region Member fields
        private string _partNo;
        private int _qty;
        #endregion

        public string PartNo
        {
            get { return _partNo; }
            set
            {
                _partNo = value;
                if (_partNo != null) _partNo = _partNo.ToUpper();
            }
        }
        public string SOS { get; set; }
        public int Qty
        {
            get {
                // if (_qty == 0) _qty = 1;  //<CODE_TAG_101775>
                    return _qty; 
            }
            set { _qty = value;  }
        }
        public bool SOSExists
        {
            get
            {
                return HasSOS(this.SOS);
            }
        }

        public static bool HasSOS(string sos)
        {
            return false == StringHelper.IsNullOrEmpty(sos);
        }
    }
}