using System.Web;
using Enums;
using X.Extensions;

namespace Entities.AppState {
    public class DivisionInfo {
        private int _systemId;
        private DivisionTypeEnum _divisionType;

        public static DivisionInfo CreateAllDivision(HttpContextBase httpContext) {
            //httpContext.Request.QueryString["SystemId"].As<int?>() ?? appContext.BusinessEntity.SystemId //TODO:get systemid from URL

            var divisionInfo = new DivisionInfo{DivisionCode = "%", DivisionName = "All Divisions", DivisionId = 0x7ff, IsGeneral = true, IsIndustrial = false, IsRental = false, IsTruck = false, IsRentalsSystem = true, SystemId = 1, SystemDesc = "DBS"};//TODO:all division info

            return divisionInfo;
        }

        private bool? _isAllDivision;
        public bool IsAllDivision {
            get {
                return (_isAllDivision ?? (_isAllDivision = IsAllDivisionCode(DivisionCode))).Value;
            }
        }

        public static bool IsAllDivisionCode(string divisionCode) {
            return divisionCode == Consts.DivCode_All;
        }

        public string DivisionCode { get; set; }
        public string DivisionName { get; set; }
        public int DivisionId { get; set; }
        public bool AllowProspectAccount { get; set; }

        public int SystemId {
            get { return _systemId; }
            set {
                _systemId = value;

                var systemType = _systemId.As<SystemType>();

                IsDBSSystem = systemType.HasFlag(SystemType.DBS);
                IsDBSiSystem = systemType.HasFlag(SystemType.DBSi);
                IsDBS5System = systemType.HasFlag(SystemType.DBS5);
                IsRentalsSystem = systemType.HasFlag(SystemType.Rentals);
                IsSAPSystem = systemType.HasFlag(SystemType.SAP);
            }
        }
        public string SystemDesc { get; set; }

        public DivisionTypeEnum DivisionType {
            get { return _divisionType; }
            set { 
                _divisionType = value;

                IsGeneral = _divisionType.HasFlag(DivisionTypeEnum.General);
                IsIndustrial = _divisionType.HasFlag(DivisionTypeEnum.Industrial);
                IsTruck = _divisionType.HasFlag(DivisionTypeEnum.Truck);
                IsRental = _divisionType.HasFlag(DivisionTypeEnum.Rental);
            }
        }

        public int BusinessEntityId { get; set; }
        public int BusinessEntityVisibilityFlags { get; set; }

        public bool IsGeneral { get; private set; }
        public bool IsIndustrial { get; private set; }
        public bool IsTruck { get; private set; }
        public bool IsRental { get; private set; }

        public bool IsDBSSystem { get; private set; }
        public bool IsDBSiSystem { get; private set; }
        public bool IsDBS5System { get; private set; }
        public bool IsRentalsSystem { get; private set; }
        public bool IsSAPSystem { get; private set; }
    }
}