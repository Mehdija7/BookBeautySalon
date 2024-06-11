using bookBeauty.Model.SearchObjects;
using MapsterMapper;
using bookBeauty.Model.Requests;
using bookBeauty.Services.Database;

namespace bookBeauty.Services
{
    public class OrderItemService : BaseCRUDService<Model.OrderItem,OrderItemSearchObject,Database.OrderItem,OrderItemInsertRequest,OrderItemUpdateRequest>, IOrderItemService
    {

        public OrderItemService(_200101Context context, IMapper mapper)
            : base(context, mapper)
        {
        }

        public override IQueryable<OrderItem> AddFilter(OrderItemSearchObject search, IQueryable<OrderItem> query)
        {
            if (search?.OrderId != 0)
            {
                query = query.Where(x => x.OrderId == search.OrderId);
            }

            return base.AddFilter(search, query);
        }

      
    }
}
