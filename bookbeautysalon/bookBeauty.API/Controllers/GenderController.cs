using bookBeauty.Model.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace bookBeauty.API.Controllers
{
    public class GenderController : BaseCRUDController<Gender, BaseSearchObject, GenderUpsertRequest, GenderUpsertRequest>
    {
        public GenderController(ILogger<BaseController<Gender, BaseSearchObject>> logger, Services.Services.IGenderService service) : base(logger, service)
        {
        }


        [Authorize]
        [HttpGet("getGenders")]
        public List<Gender> GetGenders()
        {
            return ((IGenderService)_service).GetGenders();
        }


    }
}
