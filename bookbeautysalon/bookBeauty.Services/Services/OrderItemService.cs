using bookBeauty.Model.SearchObjects;
using MapsterMapper;
using bookBeauty.Model.Requests;
using bookBeauty.Services.Database;
using bookBeauty.Model.Model;

namespace bookBeauty.Services.Services
{
    public class OrderItemService(_200101Context context, IMapper mapper) : BaseCRUDService<Model.Model.OrderItem, OrderItemSearchObject, Database.OrderItem, OrderItemInsertRequest, OrderItemUpdateRequest>(context, mapper), IOrderItemService
    {
        public override IQueryable<Database.OrderItem> AddFilter(OrderItemSearchObject search, IQueryable<Database.OrderItem> query)
        {
            if (search?.OrderId != 0)
            {
                query = query.Where(x => x.OrderId == search.OrderId);
            }

            return base.AddFilter(search, query);
        }


    }
}
