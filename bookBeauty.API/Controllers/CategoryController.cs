using bookBeauty.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace bookBeauty.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CategoryController : BaseCRUDController<Model.Category, CategorySearchObject, CategoryUpsertRequest, CategoryUpsertRequest>

    {
        public CategoryController(ICategoryService service) : base(service)
        {
        }

    }
}
