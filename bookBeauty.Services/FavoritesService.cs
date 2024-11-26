using bookBeauty.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services
{
    public class FavoritesService : BaseCRUDService<Model.FavoriteProduct, FavoriteSearchObject, Database.FavoriteProduct,FavoritesUpsertRequest,FavoritesUpsertRequest>, IFavoritesService
    {
        public FavoritesService(_200101Context context, IMapper mapper) : base(context, mapper)
        {
        }
       
        public override IQueryable<Database.FavoriteProduct> AddFilter(FavoriteSearchObject search, IQueryable<Database.FavoriteProduct> query)
        {
            var filteredQuery = base.AddFilter(search, query);

            if (search.UserId != null && search.UserId != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.UserId == search.UserId).Include(x => x.Product);
            }

            if (search.ProductId != null && search.ProductId != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.ProductId == search.ProductId).Include(x => x.Product);
            }

            return filteredQuery.Select(f => new Database.FavoriteProduct
            {
                FavoriteProductsId = f.FavoriteProductsId,
                AddingDate = f.AddingDate,
                ProductId = f.ProductId,
                UserId = f.UserId,
                Product = f.Product != null ? new Database.Product
                {
                    Category = f.Product.Category,
                    Description = f.Product.Description,
                    Name = f.Product.Name,
                    Price = f.Product.Price,
                    Image = !string.IsNullOrEmpty(f.Product.Image) && f.Product.Image.Contains("localhost")
                        ? f.Product.Image.Replace("localhost", "10.0.2.2")
                        : f.Product.Image
                } : null
            });
        }

        public override async Task BeforeInsert(FavoritesUpsertRequest request, Database.FavoriteProduct entity)
        {
            if (Context.FavoriteProducts.Any(o => (o.ProductId == request.ProductId) && (o.UserId == request.UserId)))
            {
                throw new UserException("dodano");

            }
           
            await base.BeforeInsert(request, entity);
        }

        public bool IsProductFav(int productId, int userId)
        {
            try
            {
                Console.WriteLine("------------------------- --------------------- -------------------- ----------");
                Console.WriteLine(productId);
                Console.WriteLine(userId);
                var response = Context.FavoriteProducts.First(o => (o.ProductId == productId) && (o.UserId == userId));
                return true;
            }
            catch (Exception e)
            {
                return false;
            }
        }

    }
}
