using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

namespace Enums {
    //<CODE_TAG_100331>DTO of Codes_SalesLinkVersion</CODE_TAG_100331>
    [Flags]
    public enum ModifyOperationEnum {
        Create = 0x01,
        Update = 0x02,
        Delete = 0x04
    }
}