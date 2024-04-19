using System;
using System.Collections.Generic;

namespace bookBeauty.Services.Database;

public partial class Product
{
    public string ProductId { get; set; } = null!;

    public string Name { get; set; } = null!;

    public decimal Price { get; set; }

    public byte[] Image { get; set; } = null!;

    public string Description { get; set; } = null!;

    public string? CategoryId { get; set; }

    public string? StateMachine { get; set; }

    public virtual Category? Category { get; set; }

    public virtual ICollection<FavoriteProduct> FavoriteProducts { get; set; } = new List<FavoriteProduct>();

    public virtual ICollection<Favorite> Favorites { get; set; } = new List<Favorite>();

    public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();

    public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();
}
