using bookBeauty.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services;

namespace bookBeauty.API.Controllers
{
    public class CategoryController : BaseCRUDController<Model.Category, CategorySearchObject, CategoryUpsertRequest, CategoryUpsertRequest>

    {
        public CategoryController(ICategoryService service) : base(service)
        {
        }
    }
}
