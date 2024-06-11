using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services
{
    public interface ITransactionService : ICRUDService<Model.Transaction,BaseSearchObject,TransactionInsertRequest, TransactionUpdateRequest>
    {
    }
}
    