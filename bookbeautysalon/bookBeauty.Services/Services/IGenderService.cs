using bookBeauty.Model.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;

namespace bookBeauty.Services.Services
{
    public interface IGenderService : ICRUDService<Gender, BaseSearchObject, GenderUpsertRequest, GenderUpsertRequest>
    {
        public List<Model.Model.Gender> Get();
    }
}
