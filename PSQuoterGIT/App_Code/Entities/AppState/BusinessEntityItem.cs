using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using X.Extensions;

namespace Entities.AppState {
    /// <summary>
    /// Summary description for BusinessEntityItem
    /// </summary>
    public class BusinessEntityItem {
        private string _applicationPath;

        /// <summary>
        /// Gets default division code of the specified business entity.
        /// </summary>
        public string DivisionCode { get; set; }

        public int BusinessEntityId { get; set; }
        public string BusinessEntityName { get; set; }
        public string Theme { get; set; }
        public string ApplicationPath {
            get { return _applicationPath; }
            set {
                _applicationPath = value.AsNullIfWhiteSpace(trim:true);
            }
        }

        public bool Selected { get; set; }
    } 
}