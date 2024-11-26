using bookBeauty.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services;
using bookBeauty.Services.Database;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace bookBeauty.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class FavoriteProductController : BaseCRUDController<Model.FavoriteProduct, FavoriteSearchObject, FavoritesUpsertRequest, FavoritesUpsertRequest>
    {
        public FavoriteProductController(IFavoritesService service) : base(service)
        {
        }

        [AllowAnonymous]
        [HttpGet]
        public override Task<PagedResult<Model.FavoriteProduct>> GetList([FromQuery] FavoriteSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

        [AllowAnonymous]
        [HttpPost]
        public override Task<Model.FavoriteProduct> Insert(FavoritesUpsertRequest request)
        {
            return base.Insert(request);
        }

        [AllowAnonymous]
        [HttpDelete]
        public override Task<Model.FavoriteProduct> Delete(int id)
        {
            Console.WriteLine("------------------------- --------------------- -------------------- ----------");
            Console.WriteLine(id);
            return base.Delete(id);
        }

        [AllowAnonymous]
        [HttpGet("/Product/IsProductFav")]
        public bool IsProductFav(int productId, int userId)
        {
            return  ((IFavoritesService)_service).IsProductFav(productId, userId);
        }
    }

}
