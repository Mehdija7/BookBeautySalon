using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using EasyNetQ.Events;
using MapsterMapper;
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

        public override IQueryable<Review> AddFilter(ReviewSearchObject search, IQueryable<Review> query)
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
    }
}
