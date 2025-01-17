using bookBeauty.Model.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace bookBeauty.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class OrderItemController : BaseCRUDController<OrderItem, OrderItemSearchObject, OrderItemInsertRequest, OrderItemUpdateRequest>
    {
        public OrderItemController(ILogger<BaseController<OrderItem, OrderItemSearchObject>> logger, IOrderItemService service) : base(logger,service)
        {
        }

        [Authorize]
        [HttpPost]
        public override Task<OrderItem> Insert(OrderItemInsertRequest request)
        {
            return base.Insert(request);
        }
    }
}
