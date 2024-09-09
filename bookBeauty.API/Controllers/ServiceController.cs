using bookBeauty.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using MapsterMapper;

namespace bookBeauty.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ServiceController : BaseCRUDController<Model.Service, ServiceSearchObject, ServiceInsertRequest, ServiceUpdateRequest>
    {

        public ServiceController(IServiceService service) : base(service)
        {
        }


        [AllowAnonymous]
        [HttpGet("/Service/Mobile")]
        public async Task<List<Model.Service>> GetMobile ()
        {
            return await ((IServiceService)_service).GetMobile();
        }

        [AllowAnonymous]
        public override Task<PagedResult<Service>> GetList([FromQuery] ServiceSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize(Roles = "Admin")]
        public override Task<Model.Service> Insert([FromBody] ServiceInsertRequest request)
        {
            return base.Insert(request);
        }

   

    }
}
