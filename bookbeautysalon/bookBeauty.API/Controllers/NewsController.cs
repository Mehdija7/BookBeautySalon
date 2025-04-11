using Azure.Core;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace bookBeauty.API.Controllers
{
    [ApiController]
    public class NewsController : BaseCRUDController<Model.Model.News, BaseSearchObject, Model.Requests.NewsUpsertRequest, NewsUpsertRequest>

    {
        public NewsController(ILogger<BaseController<Model.Model.News, BaseSearchObject>> logger, bookBeauty.Services.Services.INewsService service) : base(logger, service)
        {
        }

        [Authorize(Roles = "Admin,Hairdresser")]
        public override Task<Model.Model.News> Insert([FromBody] NewsUpsertRequest request)
        {

            return base.Insert(request);
        }

        [Authorize(Roles = "Admin,Hairdresser")]
        public override Task<IActionResult> Delete(int id)
        {
            return base.Delete(id);
        }
    }
}
