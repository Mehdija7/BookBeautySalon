using bookBeauty.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services
{
    public interface IUserService : ICRUDService<User,UserSearchObject,UserInsertRequest,UserUpdateRequest>
    {
        Model.User Login(string username,string password);
    }
}
