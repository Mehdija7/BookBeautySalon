using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using MapsterMapper;
using bookBeauty.Model.Model;
using bookBeauty.Services.Services;

namespace bookBeauty.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ServiceController : BaseCRUDController<Service, ServiceSearchObject, ServiceInsertRequest, ServiceUpdateRequest>
    {

        public ServiceController(ILogger<BaseController<Service, ServiceSearchObject>> logger, IServiceService service) : base(logger, service)
        {
        }

        [Authorize(Roles = "Admin, Frizer")]
        public override Task<Service> Insert([FromBody] ServiceInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Admin, Frizer")]
        public override  async Task<Service> Update(int id, ServiceUpdateRequest request)
        {
            return await _service.Update(id, request);
        }
        

    }
}
