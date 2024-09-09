using bookBeauty.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services
{
    public interface IServiceService : ICRUDService<Model.Service,Model.SearchObjects.ServiceSearchObject,ServiceInsertRequest,ServiceUpdateRequest>
    {
        public  Task<List<Model.Service>> GetMobile();

    }
}
