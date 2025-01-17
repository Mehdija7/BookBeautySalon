using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services.Services
{
    public interface INewsService : ICRUDService<Model.Model.News, BaseSearchObject, NewsUpsertRequest, NewsUpsertRequest>
    {
   
    }
}
