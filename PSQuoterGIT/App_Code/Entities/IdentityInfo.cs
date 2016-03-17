using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Enums;
using Helpers;
using X.Extensions;
using X.Web.Security;
namespace Entities
{
    public class IdentityInfo : WebIdentityData
    {
        public IdentityInfo()
        {
        }

        public string FullName
        {
            get { return Util.FormatFullName(FirstName, LastName); }
        }

        public string DivisionCode { get; set; }
        public int? AdminId { get; internal set; }
    }

}