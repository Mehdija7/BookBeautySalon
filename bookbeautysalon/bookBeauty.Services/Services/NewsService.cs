using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services.Services
{
    public class NewsService : BaseCRUDService<Model.Model.News, BaseSearchObject, Database.News, NewsUpsertRequest, NewsUpsertRequest>, INewsService
    {
        public NewsService(_200101Context context, IMapper mapper) : base(context, mapper)
        {
        }


    }
}
