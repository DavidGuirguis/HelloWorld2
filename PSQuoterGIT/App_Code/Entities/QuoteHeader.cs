using System;
using System.Collections.Generic;

namespace Entities
{
    public class QuoteHeader
    {
        public int QuoteId { get; set; }
        public string QuoteNo { get; set; }
        public QuoteTypeEnum QuoteType {get; set;}
        public DateTime QuoteDate { get; set; }
        public int Revision { get; set; }

        public List<QuoteRevision> Revisions;

        public string Description { get; set; }

        public Customer Customer { get; set; }
        public RepInfo  SalesRep { get; set; }
        public Summary Summary { get; set; }
        public List<Segment> Segments;
        public List<DocumentInfo> Documents;

        public IdentityInfo EnterUser { get; set; }
        public DateTime EnterDate { get; set; }
        public IdentityInfo ChangeUser { get; set; }
        public DateTime ChangeDate { get; set; }
        
        
    }

  
}