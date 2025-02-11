

using bookBeauty.Model.Requests;
using bookBeauty.Services;
using bookBeauty.Services.Services;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;
using Microsoft.Identity.Client;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Text.Encodings.Web;

namespace bookBeauty.API
{
    public class BasicAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
    {
        private readonly IUserService userService;

        public BasicAuthenticationHandler(IOptionsMonitor<AuthenticationSchemeOptions> options,
            ILoggerFactory logger,
            UrlEncoder encoder,
            IUserService userService
       ) : base(options, logger, encoder)
        {
            this.userService = userService;
        }

        protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            if (!Request.Headers.ContainsKey("Authorization"))
            {
                return AuthenticateResult.Fail("Missing header");
            }

            var authHeader = AuthenticationHeaderValue.Parse(Request.Headers["Authorization"]);
            var credentialBytes = Convert.FromBase64String(authHeader.Parameter);
            var credentials = Encoding.UTF8.GetString(credentialBytes).Split(':');

            var username = credentials[0];
            var password = credentials[1];

            LoginInsertRequest request = new LoginInsertRequest
            {
                Password = password,
                Username = username,
            };

            var user = userService.Login(request);

            if (user == null)
            {
                var customer = userService.Login(request);

                if (customer == null)
                {
                    return AuthenticateResult.Fail("Auth failed");
                }
                else
                {
                    var claims = new List<Claim>()
                    {
                     new Claim(ClaimTypes.Name,customer.Result.FirstName),
                    new Claim(ClaimTypes.NameIdentifier, customer.Result.Username)
                    };

                    claims.Add(new Claim(ClaimTypes.Role, "Kupac"));

                    var identity = new ClaimsIdentity(claims, Scheme.Name);

                    var principal = new ClaimsPrincipal(identity);

                    var ticket = new AuthenticationTicket(principal, Scheme.Name);
                    return AuthenticateResult.Success(ticket);
                }
            }
            else
            {
                var claims = new List<Claim>()
                {
                    new Claim(ClaimTypes.Name, user.Result.FirstName),
                    new Claim(ClaimTypes.NameIdentifier, user.Result.Username)
                };

                foreach (var role in user.Result.UserRoles)
                {
                    claims.Add(new Claim(ClaimTypes.Role, role.Role.Name));
                }

                var identity = new ClaimsIdentity(claims, Scheme.Name);

                var principal = new ClaimsPrincipal(identity);

                var ticket = new AuthenticationTicket(principal, Scheme.Name);
                return AuthenticateResult.Success(ticket);
            }
        }
    }
}