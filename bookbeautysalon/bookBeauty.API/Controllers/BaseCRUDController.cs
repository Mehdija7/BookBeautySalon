using bookBeauty.Model;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace bookBeauty.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class BaseCRUDController<TModel, TSearch, TInsert, TUpdate> : BaseController<TModel, TSearch> where TSearch : BaseSearchObject where TModel : class
    {
        protected new Services.Services.ICRUDService<TModel, TSearch, TInsert, TUpdate> _service;
        protected new readonly ILogger<BaseController<TModel, TSearch>> _logger;

      
        public BaseCRUDController(ILogger<BaseController<TModel, TSearch>> logger, Services.Services.ICRUDService<TModel, TSearch, TInsert, TUpdate> service) : base(logger,service)
        {
            _service = service;
            _logger = logger;
        }

        [Authorize]
        [HttpPost()]
        public virtual async Task<TModel> Insert(TInsert request)
        {
            return await _service.Insert(request);
        }

        [Authorize]
        [HttpPut("{id}")]
        public virtual async Task<TModel> Update(int id, TUpdate request)
        {
            return await _service.Update(id, request);
        }

        [Authorize]
        [HttpDelete]
        public virtual async Task<IActionResult> Delete(int id)
        {
            var result = await _service.Delete(id);

            if (result == null)
            {
                return NotFound();
            }

            return NoContent();
           
        }
    }
}
