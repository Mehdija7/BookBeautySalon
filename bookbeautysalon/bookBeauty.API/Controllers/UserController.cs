using bookBeauty.Model.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Text;

namespace bookBeauty.API.Controllers
{
    [ApiController]
    [Route("[controller]")]

    public class UserController : BaseCRUDController<User, UserSearchObject, UserInsertRequest, UserUpdateRequest>
    {
        public UserController(ILogger<BaseController<User, UserSearchObject>> logger, IUserService service) : base(logger,service)
        {
        }

        [AllowAnonymous]
        public override Task<User> Insert(UserInsertRequest request)
        {
            return base.Insert(request);
        }

        [HttpPost("Authenticate")]
        [AllowAnonymous]
        public async Task<User> Login(LoginInsertRequest req)
        {
            return await ((IUserService)_service).Login(req);

        }

        [HttpPost("{id}/AddUserRole")]
        [Authorize(Roles ="Admin")]
        public User AddUserRole(int id)
        {
            return ((IUserService)_service).AddUserRole(id);
        }

        [HttpPost("{id}/AddRole")]
        [Authorize(Roles = "Admin")]
        public User AddRole(int id,[FromBody]string namerole)
        {
            return ((IUserService)_service).AddRole(id,namerole);
        }

        [HttpGet("{id}/GetRoles")]
        [Authorize(Roles = "Admin")]
        public List<UserRoles> GetUserRoles(int id)
        {
            return ((IUserService)_service).GetUserRoles(id);
        }

        [HttpGet("/GetHairdressers")]
        public List<User> GetHairdressers()
        {
            return ((IUserService)_service).GetHairdressers();
        }

        [HttpDelete("/DeleteUserRoles")]
        [Authorize(Roles = "Admin")]
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
