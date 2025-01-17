using bookBeauty.Model.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using bookBeauty.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace bookBeauty.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class FavoriteProductController : BaseCRUDController<Model.Model.FavoriteProduct, FavoriteSearchObject, FavoritesUpsertRequest, FavoritesUpsertRequest>
    {
        public FavoriteProductController(ILogger<BaseController<Model.Model.FavoriteProduct, FavoriteSearchObject>> logger, Services.Services.IFavoritesService service) : base(logger, service)
        {
        }

        [Authorize]
        [HttpGet]
        public override Task<PagedResult<Model.Model.FavoriteProduct>> GetList([FromQuery] FavoriteSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [Authorize]
        [HttpPost]
        public override Task<Model.Model.FavoriteProduct> Insert(FavoritesUpsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize]
        [HttpDelete]
        public override Task<IActionResult> Delete(int id)
        {
            return base.Delete(id);
        }

        [Authorize]
        [HttpGet("/Product/IsProductFav")]
        public bool IsProductFav(int productId, int userId)
        {
            return  ((IFavoritesService)_service).IsProductFav(productId, userId);
        }
    }

}
