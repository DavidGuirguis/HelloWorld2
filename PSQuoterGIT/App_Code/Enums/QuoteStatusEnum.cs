using System;
namespace Entities
{

    public enum QuoteStatusEnum
    {
        Open = 1,
        SubmittedForApproval = 2,
        Won = 4,
        Lost = 8,
        NoDeal = 16
    }
}