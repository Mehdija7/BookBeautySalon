using bookBeauty.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services;
using bookBeauty.Services.Database;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace bookBeauty.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProductController : BaseCRUDController<Model.Product, ProductSearchObject, ProductInsertRequest, ProductUpdateRequest>
    {
        public ProductController(IProductService service) : base(service)
        {
        }
        [HttpPut("{id}/activate")]
        public async Task<Model.Product> Activate(int id)
        {
            return await ((IProductService)_service).Activate(id);
        }

        [Authorize(Roles = "Admin")]
        public override Task<Model.Product> Insert([FromBody]ProductInsertRequest request)
        {

            return base.Insert(request);
        }

        [HttpPut("{id}/hide")]
        public virtual async Task<Model.Product> Hide(int id)
        {
            return await (_service as IProductService).Hide(id);
        }

        [HttpGet("{id}/allowedActions")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_service as IProductService).AllowedActions(id);
        }


    }
}
