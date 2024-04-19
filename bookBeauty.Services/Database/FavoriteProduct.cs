using System;
using System.Collections.Generic;

namespace bookBeauty.Services.Database;

public partial class FavoriteProduct
{
    public int FavoriteProductsId { get; set; }

    public DateTime? AddingDate { get; set; }

    public string ProductId { get; set; } = null!;

    public int? UserId { get; set; }

    public virtual Product Product { get; set; } = null!;

    public virtual User? User { get; set; }
}
