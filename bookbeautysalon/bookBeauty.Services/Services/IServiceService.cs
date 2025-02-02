using bookBeauty.Model.Model;
using bookBeauty.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services.Services
{
    public interface IServiceService : ICRUDService<Service, Model.SearchObjects.ServiceSearchObject, ServiceInsertRequest, ServiceUpdateRequest>
    {

    }
}
