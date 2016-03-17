using System;
using System.Collections.Generic;

namespace Entities
{
    public class Customer
    {
        public string CustomerNo { get; set; }
        public string CustomerName { get; set; }
        public string PhoneNo { get; set; }
        public string FaxNo { get; set; }
        public string Email { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string Address3 { get; set; }
        public string CityState { get; set; }
        public string ZipCode { get; set; }
        public List<Contact> Contacts;
    }


}