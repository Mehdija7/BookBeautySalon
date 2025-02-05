using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services.Services
{
    public class GenderService(_200101Context context, IMapper mapper) : BaseCRUDService<Model.Model.Gender, BaseSearchObject, Database.Gender, GenderUpsertRequest, GenderUpsertRequest>(context, mapper), IGenderService
    {
       
        public List<Model.Model.Gender> Get()
        {
            var list = Context.Genders.ToList();
            return Mapper.Map<List<Model.Model.Gender>>(list);
        }
    }
}
