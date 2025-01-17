using System;
using System.Collections.Generic;

namespace bookBeauty.Services.Database;

public partial class Transaction
{
    public int TransactionId { get; set; }

    public int OrderId { get; set; }

    public float Price { get; set; }

    public string? Status { get; set; }

    public string? Name { get; set; }

    public virtual Order? Order { get; set; }
}
