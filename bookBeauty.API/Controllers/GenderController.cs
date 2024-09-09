using bookBeauty.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services;

namespace bookBeauty.API.Controllers
{
    public class GenderController : BaseCRUDController<Model.Gender, BaseSearchObject, GenderUpsertRequest, GenderUpsertRequest>
    {
        public GenderController(IGenderService service) : base(service)
        {
        }
    }
}
