using bookBeauty.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace bookBeauty.API.Controllers
{
    public class GenderController : BaseCRUDController<Model.Gender, BaseSearchObject, GenderUpsertRequest, GenderUpsertRequest>
    {
        public GenderController(IGenderService service) : base(service)
        {
        }


        [AllowAnonymous]
        [HttpGet("getGenders")]
        public List<Model.Gender> GetGenders()
        {
            return ((IGenderService)_service).GetGenders();
        }


    }
}
