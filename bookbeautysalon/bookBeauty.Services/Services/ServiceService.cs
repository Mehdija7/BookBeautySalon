using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using MapsterMapper;


namespace bookBeauty.Services.Services
{
    public class ServiceService(_200101Context context, IMapper mapper) : BaseCRUDService<Model.Model.Service, ServiceSearchObject, Database.Service, ServiceInsertRequest, ServiceUpdateRequest>(context, mapper), IServiceService
    {
        public async Task<List<Model.Model.Service>> GetMobile()
        {
            List<Model.Model.Service> list = new List<Model.Model.Service>();
            var db = Context.Services.ToList();

            foreach (var s in db)
            {
                var service = Mapper.Map<Model.Model.Service>(s);

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
