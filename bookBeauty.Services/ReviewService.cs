using bookBeauty.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using EasyNetQ.Events;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services
{
    public class ReviewService : BaseCRUDService<Model.Review, Model.SearchObjects.ReviewSearchObject,Database.Review, Model.Requests.ReviewInsertRequest, Model.Requests.ReviewUpdateRequest>, IReviewService
    {
        public ReviewService(_200101Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Review> AddFilter(ReviewSearchObject search, IQueryable<Database.Review> query)
        {
            var filteredQuery = base.AddFilter(search, query);


            if (search.ProductId != null && search.ProductId != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.ProductId == search.ProductId);
            }

            if (search.UserId != null && search.UserId != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.UserId == search.UserId);
            }

            return filteredQuery;
        }

        public async Task<double> GetAverage(int productId)
        {
            if (productId <= 0 || !_context.Reviews.Any(r => r.ProductId == productId))
                return 0;

            var average = await _context.Reviews
                .Where(r => r.ProductId == productId)
                .AverageAsync(r => r.Mark ?? 0);

            return average;
        }

        public override async Task BeforeInsert(ReviewInsertRequest request, Database.Review entity)
        {
            if(Context.OrderItems.Any(o=> (o.ProductId == request.ProductId) && (o.Order.CustomerId == request.UserId))){
                foreach (var r in Context.Reviews)
                {
                    if ((r.UserId == request.UserId) && (r.ProductId == request.ProductId))
                        throw new UserException("Recenzija na ovaj proizvod vec postoji");
                }

            }
            else
            {
                throw new UserException("ne mozete dati recenziju");
            }
            await base.BeforeInsert(request, entity);
        }

    }
}
