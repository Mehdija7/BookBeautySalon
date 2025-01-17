using bookBeauty.Model.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services.Services
{
    public interface IUserService : ICRUDService<User, UserSearchObject, UserInsertRequest, UserUpdateRequest>
    {
        Task<User> Login(LoginInsertRequest request);
        User AddUserRole(int id);
        User AddRole(int id, string namerole);
        List<UserRoles> GetUserRoles(int id);
        List<User> GetHairdressers();
        void DeleteUserRoles(int userId);
        List<HairdresserGetRequest> GetHairdressersMobile();
    }
}
