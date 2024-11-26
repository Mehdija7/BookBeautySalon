

using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;

namespace bookBeauty.Services
{
    public interface IGenderService : ICRUDService<Model.Gender,BaseSearchObject,GenderUpsertRequest,GenderUpsertRequest>
    {
        List<Model.Gender> GetGenders();
    }
}
