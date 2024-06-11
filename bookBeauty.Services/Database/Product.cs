using System;
using System.Collections.Generic;

namespace bookBeauty.Services.Database;

public partial class Product
{
    public int ProductId { get; set; } 

    public string Name { get; set; } = null!;

    public double Price { get; set; }

    public string Description { get; set; } = null!;

    public int? CategoryId { get; set; }

    public string? StateMachine { get; set; }

    public byte[] Image { get; set; } 
    public virtual Category? Category { get; set; }

    public virtual ICollection<FavoriteProduct> FavoriteProducts { get; set; } = new List<FavoriteProduct>();

    public virtual ICollection<Favorite> Favorites { get; set; } = new List<Favorite>();

    public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();

    public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();
}
