using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services
{
    public interface IReviewService : ICRUDService<Model.Review,Model.SearchObjects.ReviewSearchObject,Model.Requests.ReviewInsertRequest,Model.Requests.ReviewUpdateRequest>
    {
    }
}
