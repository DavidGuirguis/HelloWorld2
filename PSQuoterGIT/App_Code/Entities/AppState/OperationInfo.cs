using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Enums;
using Helpers;
using X.Extensions;
using X.Web.Security;

namespace Entities.AppState {
    public class OperationInfo {
        public bool Admin { get; set; }

        public bool CreateQuote { get; set; }

        public bool WOReports { get; set; }

        public bool DeleteQuote { get; set; }

        public bool RepairOption { get; set; }

        public bool WODetails { get; set; }

        public bool TRG { get; set; }

        public bool QuoteSearchReps { get; set; }

        public bool CreateWO { get; set; }

        public int RoleId { get; set; }   //<CODE_TAG_103481>
    }
}
