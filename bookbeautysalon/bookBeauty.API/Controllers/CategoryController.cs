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
    public class CategoryController : BaseCRUDController<Category, CategorySearchObject, CategoryUpsertRequest, CategoryUpsertRequest>

    {
        public CategoryController(ILogger<BaseController<Category,CategorySearchObject>> logger, bookBeauty.Services.Services.ICategoryService service) : base(logger,service)
        {
        }

    }
}
