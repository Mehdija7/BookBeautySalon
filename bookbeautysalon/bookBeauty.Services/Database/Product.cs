
namespace bookBeauty.Services.Database;

public partial class Product
{
    public int ProductId { get; set; } 

    public string Name { get; set; } = null!;

    public float Price { get; set; }
    public string Description { get; set; } = null!;

    public int CategoryId { get; set; }

    public string? StateMachine { get; set; }

    public byte[]? Image { get; set; } 
    public virtual Category? Category { get; set; }

    public virtual ICollection<FavoriteProduct> FavoriteProducts { get; set; } = [];

    public virtual ICollection<OrderItem> OrderItems { get; set; } = [];

    public virtual ICollection<Review> Reviews { get; set; } = [];
    public virtual ICollection<CommentProduct> CommentProducts { get; set; } = [];
}
