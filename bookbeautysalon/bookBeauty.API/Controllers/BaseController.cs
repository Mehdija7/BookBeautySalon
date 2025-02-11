using bookBeauty.Model.Model;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace bookBeauty.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
 
    public class BaseController<TModel, TSearch> : ControllerBase where TSearch : BaseSearchObject
    {

        protected Services.Services.IBaseService<TModel, TSearch> _service;
        protected readonly ILogger<BaseController<TModel, TSearch>> _logger;

        public BaseController(ILogger<BaseController<TModel, TSearch>> logger,IBaseService<TModel, TSearch> service)
        {
            _logger = logger;
            _service = service;
        }

        [Authorize]
        [HttpGet()]
        public async Task<PagedResult<TModel>> GetList([FromQuery] TSearch? searchObject)
        {
            return await _service.GetPaged(searchObject);
        }

        [Authorize]
        [HttpGet("{id}")]
        public async Task<TModel> GetById(int id)
        {
            return await _service.GetById(id);
        }
    }
}
