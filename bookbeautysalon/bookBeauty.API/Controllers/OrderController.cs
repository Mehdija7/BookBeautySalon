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
    public class OrderController : BaseCRUDController<Order, OrderSearchObject, OrderInsertRequest, OrderUpdateRequest>
    {
        public OrderController(ILogger<BaseController<Order, OrderSearchObject>> logger, Services.Services.IOrderService service) : base(logger, service)
        {
        }

        [Authorize]
        public override Task<PagedResult<Order>> GetList([FromQuery] OrderSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }
                    
        [Authorize]
        [HttpPost]
        public override async Task<Order> Insert(OrderInsertRequest request)
        {
            return await base.Insert(request);
        }

        [Authorize]
        [HttpPut("{id}")]
        public override async Task<Order> Update(int id, [FromBody] OrderUpdateRequest request)
        {
            return await base.Update(id,request);
        }

        [Authorize]
        public override async Task<IActionResult> Delete(int id)
        {
            return await base.Delete(id);
        }
    }
}
