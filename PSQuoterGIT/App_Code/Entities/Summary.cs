using System;
namespace Entities
{
    public class Summary
    {
        public string WorkOrderNo { get; set; }
        public string PurchaseOrderNo { get; set; }
        public string Division { get; set; }
        public string BranchNo { get; set; }
        public string Make { get; set; }
        public string Model { get; set; } 
        public string SerialNo { get; set; }
        public string UnitNo { get; set; }
	    public double SMU {get; set;}
        public string EstimatedRepairTime {get; set;}
	    public double GSTRate {get; set;}
	    public double PSTRate{get; set;}
	    public int PSTOnGST{get; set;}
	    public int OriginalQuoteId {get; set;}
	    public DateTime NewCompletionDate {get; set;}
	    public double EnvironmentalCharge {get; set;}
	    public double QuoteTotal {get; set;}
	    public bool EmailSent {get; set;}
	    public int SchedulerAppointmentId {get; set;}
	    public DateTime AcceptedDate {get; set;}
	    public string Comments {get; set;}
    }

}