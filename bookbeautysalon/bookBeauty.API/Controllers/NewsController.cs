using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using Microsoft.AspNetCore.Mvc;

namespace bookBeauty.API.Controllers
{
    [ApiController]
    public class NewsController : BaseCRUDController<Model.Model.News, BaseSearchObject, Model.Requests.NewsUpsertRequest, NewsUpsertRequest>

    {
        public NewsController(ILogger<BaseController<Model.Model.News, BaseSearchObject>> logger, bookBeauty.Services.Services.INewsService service) : base(logger, service)
        {
        }

    }
}
