using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Enums {
    /// <summary>
    /// Summary description for DivisionTypeEnum
    /// </summary>
    [Flags]
    public enum DivisionTypeEnum {
        General = 0x01,
        Industrial = 0x02,
        Truck = 0x04,
        Rental = 0x08,

        All = 0x7F
    }
}