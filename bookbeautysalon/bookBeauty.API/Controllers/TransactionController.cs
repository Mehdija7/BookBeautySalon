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
    public class TransactionController : BaseCRUDController<Transaction, BaseSearchObject, TransactionInsertRequest, TransactionUpdateRequest>
    {
        public TransactionController(ILogger<BaseController<Transaction, BaseSearchObject>> logger, ITransactionService service) : base(logger,service)
        {
        }

        [Authorize]
        [HttpPost]
        public override Task<Transaction> Insert(TransactionInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles="Admin")]
        [HttpGet]
        public override  Task<PagedResult<Transaction>> GetList([FromQuery] BaseSearchObject searchObject)
        {
            return _service.GetPaged(searchObject);
        }
    }
}
