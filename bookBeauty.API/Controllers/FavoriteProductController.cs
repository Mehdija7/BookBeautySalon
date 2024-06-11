using bookBeauty.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services;
using Microsoft.AspNetCore.Mvc;

namespace bookBeauty.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class FavoriteProductController : BaseCRUDController<Model.Favorites, FavoriteSearchObject, FavoritesUpsertRequest, FavoritesUpsertRequest>
    {
        public FavoriteProductController(IFavoritesService service) : base(service)
        {
        }
    }

}
