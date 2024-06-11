using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services
{
    public class GenderService : BaseCRUDService<Model.Gender, BaseSearchObject, Database.Gender, GenderUpsertRequest, GenderUpsertRequest>, IGenderService
    {
        public GenderService(_200101Context context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
