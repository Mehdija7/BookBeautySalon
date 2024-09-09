

namespace bookBeauty.Model.Requests
{
    public class ProductInsertRequest
    {
        public string Name { get; set; }
        public int CategoryId { get; set; }
        public float Price { get; set; }
        public string Description { get; set; }
        public string? Image { get; set; }
        public string? StateMachine { get; set; }
    }
}
