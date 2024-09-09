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

       /* [HttpPost("Authenticate")]
        [AllowAnonymous]
        public Model.User Authenticate()
        {
           string authorization = HttpContext.Request.Headers["Authorization"];
            string encodedHeader = authorization["Basic ".Length..].Trim();
            Encoding encoding = Encoding.GetEncoding("iso-8859-1");
            string usernamePassword = encoding.GetString(Convert.FromBase64String(encodedHeader));
            int seperatorIndex = usernamePassword.IndexOf(':');

            return ((IUserService)_service).Login(usernamePassword.Substring(0, seperatorIndex), usernamePassword[(seperatorIndex + 1)..]);
        }*/


    }
}
