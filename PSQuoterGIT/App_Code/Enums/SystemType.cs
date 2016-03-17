using System;

namespace Enums {
    [Flags]
    public enum SystemType {
        DBS = 0x01,
        DBSi = 0x02,
        DBS5 = 0x04,
        Rentals = 0x08,
        SAP = 0x10
    }
}