using bookBeauty.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services;
using Microsoft.AspNetCore.Mvc;

namespace bookBeauty.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TransactionController : BaseCRUDController<Model.Transaction, BaseSearchObject, TransactionInsertRequest, TransactionUpdateRequest>
    {
        public TransactionController(ITransactionService service) : base(service)
        {
        }
    }
}
