using bookBeauty.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services
{
    public class FavoritesService : BaseCRUDService<Model.Favorites, FavoriteSearchObject, Database.Favorite,FavoritesUpsertRequest,FavoritesUpsertRequest>, IFavoritesService
    {
        public FavoritesService(_200101Context context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Favorite> AddFilter(FavoriteSearchObject search, IQueryable<Favorite> query)
        {
            var filteredQuery = base.AddFilter(search, query);

            if (search.UserId != null && search.UserId != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.UserId == search.UserId);
            }

            if (search.ProductId != null && search.ProductId != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.ProductId == search.ProductId);
            }

            return filteredQuery;
        }


    }
}
