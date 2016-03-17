using System;
using System.Collections.Generic;
namespace Entities
{
    public class Segment
    {
        public int  SegmentId { get; set; }
        public string SegmentNo { get; set; }
        //public string Description { get; set; }
        //public string HiddenDescription { get; set; }
        public string SegmentExternalNotes { get; set; }
        public string SegmentInternalNotes { get; set; }
        public int DBSRepairOptionId { get; set; }

        public List<Part> Parts;
        public List<Labor> Labor;
        public List<Misc> Misc;

        public IdentityInfo EnterUser { get; set; }
        public DateTime EnterDate { get; set; }
        public IdentityInfo ChangeUser { get; set; }
        public DateTime ChangeDate { get; set; }
    }
}