using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Enums;
using Helpers;
using X.Extensions;
using X.Web.Security;

namespace Entities.AppState {
    public class IdentityInfo : WebIdentityData {
        public IdentityInfo() {
        }

        public string FullName {
            get { return Util.FormatFullName(FirstName, LastName); }
        }

        /// <summary>
        /// Gets a value of user's default division.
        /// </summary>
        public string DivisionCode { get; set; }
        public int? RepId { get; set; }
        public int? AdminId { get; internal set; }

        public bool CanImpersonate { get; internal set; }

        public void Reset() {
            var resetHelper = new IdentityInfo();
            resetHelper.CopyTo(this);
        }
    }
}
