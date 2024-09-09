using bookBeauty.Model;
using bookBeauty.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services
{
    public interface IBaseService<TModel, TSearch> where TSearch : BaseSearchObject
    {
        public  Task<PagedResult<TModel>> GetPaged(TSearch search);
        public  Task<TModel> GetById(int id);
       
    }
}
