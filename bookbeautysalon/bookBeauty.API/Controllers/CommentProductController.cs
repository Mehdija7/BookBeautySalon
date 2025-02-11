using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace bookBeauty.API.Controllers
{
    [ApiController]
    public class CommentProductController : BaseCRUDController<Model.Model.CommentProduct, BaseSearchObject, Model.Requests.CommentProductUpsertRequest, CommentProductUpsertRequest>

    {
        public CommentProductController(ILogger<BaseController<Model.Model.CommentProduct, BaseSearchObject>> logger, bookBeauty.Services.Services.ICommentProductService service) : base(logger, service)
        {
        }

        [Authorize]
        public override Task<Model.Model.CommentProduct> Insert([FromBody] CommentProductUpsertRequest request)
        {

            return base.Insert(request);
        }




    }
}
