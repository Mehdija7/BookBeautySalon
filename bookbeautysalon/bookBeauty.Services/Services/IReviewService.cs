using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using bookBeauty.Model.Model;

namespace bookBeauty.Services.Services
{
    public interface IReviewService : ICRUDService<Review, Model.SearchObjects.ReviewSearchObject, Model.Requests.ReviewInsertRequest, Model.Requests.ReviewUpdateRequest>
    {
        public Task<double> GetAverage(int productId);
    }
}
