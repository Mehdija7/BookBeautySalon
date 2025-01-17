using bookBeauty.Model.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace bookBeauty.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ReviewController : BaseCRUDController<Review, ReviewSearchObject, ReviewInsertRequest, ReviewUpdateRequest>
    {
        public ReviewController(ILogger<BaseController<Review, ReviewSearchObject>> logger, Services.Services.IReviewService service)
            : base(logger, service)
        {
        }

        [Authorize]
        [HttpGet("/GetAverage")]
        public  async Task<double> GetAverage(int productId)
        {
            return await (_service as IReviewService).GetAverage(productId);
        }

        [Authorize]
        public override Task<Review> Insert(ReviewInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize]
        public override Task<IActionResult> Delete(int id)
        {
            return base.Delete(id);
        }
    }
}
