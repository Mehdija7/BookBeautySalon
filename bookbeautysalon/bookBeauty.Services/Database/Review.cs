using System;
using System.Collections.Generic;

namespace bookBeauty.Services.Database;

public partial class Review
{
    public int ReviewId { get; set; }

    public int Mark { get; set; }

    public int ProductId { get; set; }

    public int UserId { get; set; }

    public virtual Product? Product { get; set; }

    public virtual User? User { get; set; }
}
