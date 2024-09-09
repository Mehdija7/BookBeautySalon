using bookBeauty.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using MapsterMapper;


namespace bookBeauty.Services
{
    public class ServiceService : BaseCRUDService<Model.Service, ServiceSearchObject, Database.Service, ServiceInsertRequest, ServiceUpdateRequest>, IServiceService
    {
        public ServiceService(_200101Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public async Task<List<Model.Service>> GetMobile()
        {
            List<Model.Service> list = new List<Model.Service>();
            var db = Context.Services.ToList();

            foreach (var s in db)
            {
                var service = Mapper.Map<Model.Service>(s);

                if (!string.IsNullOrEmpty(service.Image) && service.Image.Contains("localhost"))
                {
                    service.Image = service.Image.Replace("localhost", "10.0.2.2");
                }

                list.Add(service);
            }

            return list;
        }
    }
}
