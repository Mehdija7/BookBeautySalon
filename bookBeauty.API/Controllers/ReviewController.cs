using bookBeauty.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace bookBeauty.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ReviewController : BaseCRUDController<Model.Review, ReviewSearchObject, ReviewInsertRequest, ReviewUpdateRequest>
    {
        public ReviewController( IReviewService service)
            : base( service)
        {
        }

        [AllowAnonymous]
        [HttpGet("/GetAverage")]
        public  async Task<double> GetAverage(int productId)
        {
            return await (_service as IReviewService).GetAverage(productId);
        }

        [AllowAnonymous]
        public override Task<Review> Insert(ReviewInsertRequest request)
        {
            return base.Insert(request);
        }
    }
}
