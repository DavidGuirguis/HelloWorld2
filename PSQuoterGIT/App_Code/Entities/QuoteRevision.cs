using System;
using System.Collections.Generic;
namespace Entities
{
    public class QuoteRevision
    {
        public int  Revision { get; set; }
        public QuoteStatusEnum Status { get; set; }
        public bool Selected { get; set; }
        public IdentityInfo EnterUser { get; set; }
        public DateTime EnterDate { get; set; }
        public IdentityInfo ChangeUser { get; set; }
        public DateTime ChangeDate { get; set; }
    }
}