using System;
using System.Collections.Generic;

namespace bookBeauty.Services.Database;

public partial class Order
{
    public int OrderId { get; set; }

    public float? TotalPrice { get; set; }

    public DateTime? DateTime { get; set; }

    public int CustomerId { get; set; }

    public string? OrderNumber { get; set; }

    public virtual User? Customer { get; set; } = null!;

    public string? Status { get; set; }

    public virtual ICollection<OrderItem>? OrderItems { get; set; } = [];

    public virtual ICollection<Transaction>? Transactions { get; set; } = [];
}
