using System;
using System.Collections.Generic;
namespace Entities
{
    public class DocumentInfo
    {
        public int  DocumentId { get; set; }
        public string DocumentName { get; set; }
        public string Description { get; set; }
        public int Size { get; set; }
        public byte[] FileStream { get; set; }

        public IdentityInfo EnterUser { get; set; }
        public DateTime EnterDate { get; set; }
        public IdentityInfo ChangeUser { get; set; }
        public DateTime ChangeDate { get; set; }
    }
}