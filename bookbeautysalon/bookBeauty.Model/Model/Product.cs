namespace bookBeauty.Model.Model
{
    public class Product
    {
        public int ProductId { get; set; }
        public string Name { get; set; } = null!;
        public string Description { get; set; } = null!;
        public float Price { get; set; }
        public int CategoryId { get; set; }
        public string? StateMachine { get; set; }
        public byte[]? Image { get; set; }
        public virtual Category? Category { get; set; }
    }
}
