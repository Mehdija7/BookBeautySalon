using bookBeauty.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Text;

namespace bookBeauty.API.Controllers
{
    [ApiController]
    [Route("[controller]")]

    public class UserController : BaseCRUDController<Model.User, UserSearchObject, UserInsertRequest, UserUpdateRequest>
    {
        public UserController(IUserService service) : base(service)
        {
        }

        [AllowAnonymous]
        public override Task<User> Insert(UserInsertRequest request)
        {
            return base.Insert(request);
        }

        [HttpPost("Authenticate")]
        [AllowAnonymous]
        public Model.User Login(LoginInsertRequest req)
        {
            return ((IUserService)_service).Login(req);

        }

        [HttpPost("{id}/AddUserRole")]
        [AllowAnonymous]
        public Model.User AddUserRole(int id)
        {
            return ((IUserService)_service).AddUserRole(id);
        }

        [HttpPost("{id}/AddRole")]
        public Model.User AddRole(int id,[FromBody]string namerole)
        {
            return ((IUserService)_service).AddRole(id,namerole);
        }

        [HttpGet("{id}/GetRoles")]
        [AllowAnonymous]
        public List<UserRoles> GetUserRoles(int id)
        {
            return ((IUserService)_service).GetUserRoles(id);
        }

        [HttpGet("/GetHairdressers")]
        public List<Model.User> GetHairdressers()
        {
            return ((IUserService)_service).GetHairdressers();
        }

        [HttpDelete("/DeleteUserRoles")]
        public void DeleteUserRoles(int userId)
        {
              ((IUserService)_service).DeleteUserRoles(userId);
        }

        [HttpGet("/GetHairdressersMobile")]
        [AllowAnonymous]
        public List<HairdresserGetRequest> GetHairdressersMobile()
        {
            return ((IUserService)_service).GetHairdressersMobile();
        }
    }
}
