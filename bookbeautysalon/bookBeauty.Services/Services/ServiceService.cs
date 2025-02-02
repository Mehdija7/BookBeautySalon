using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using MapsterMapper;


namespace bookBeauty.Services.Services
{
    public class ServiceService(_200101Context context, IMapper mapper) : BaseCRUDService<Model.Model.Service, ServiceSearchObject, Database.Service, ServiceInsertRequest, ServiceUpdateRequest>(context, mapper), IServiceService
    {
      
    }
}
