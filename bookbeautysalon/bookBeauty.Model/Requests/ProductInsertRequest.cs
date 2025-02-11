

namespace bookBeauty.Model.Requests
{
    public class ProductInsertRequest
    {
        public string Name { get; set; } = null!;
        public int CategoryId { get; set; }
        public float Price { get; set; }
        public string Description { get; set; } = null!;
        public byte[]? Image { get; set; }
        public string StateMachine { get; set; } = null!;
    }
}
