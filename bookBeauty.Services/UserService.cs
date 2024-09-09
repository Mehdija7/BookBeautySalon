using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.Security.Cryptography;
using System.Text;
using bookBeauty.Model;

namespace bookBeauty.Services
{
    public class UserService : BaseCRUDService<Model.User, UserSearchObject, Database.User, UserInsertRequest, UserUpdateRequest>, IUserService
    {
        ILogger<UserService> _logger;
        public UserService(_200101Context context, IMapper mapper, ILogger<UserService> logger) : base(context, mapper)
        {
            _logger = logger;
        }
        public override IQueryable<Database.User> AddFilter(UserSearchObject searchObject, IQueryable<Database.User> query)
        {
            query = base.AddFilter(searchObject, query);
            if (!string.IsNullOrWhiteSpace(searchObject?.FirstNameGTE))
            {
                query = query.Where(x => x.FirstName.StartsWith(searchObject.FirstNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.LastNameGTE))
            {
                query = query.Where(x => x.LastName.StartsWith(searchObject.LastNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.Email))
            {
                query = query.Where(x => x.Email == searchObject.Email);
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.Username))
            {
                query = query.Where(x => x.Username == searchObject.Username);
            }

            if (searchObject.IsUserRoleIncluded == true)
            {
                query = query.Include(x => x.UserRoles).ThenInclude(x => x.Role);
            }

            return query;
        }


        public override async Task BeforeInsert(UserInsertRequest request, Database.User entity)
        {
            _logger.LogInformation($"Adding user: {entity.Username}");


           foreach(var u in Context.Users)
            {
                if(u.Username.Equals(request.Username))
                    throw new UserException("Korisnik s tim korisnickim imenom vec postoji");
            }

            if (request.Password != request.PasswordConfirmed)
            {
                throw new UserException("Password i PasswordPotvrda moraju biti iste");
            }

            entity.PasswordSalt = GenerateSalt();
            entity.PasswordHash = GenerateHash(entity.PasswordSalt, request.Password);
           await base.BeforeInsert(request, entity);
        }

        public static string GenerateSalt()
        {
            var byteArray = RNGCryptoServiceProvider.GetBytes(16);


            return Convert.ToBase64String(byteArray);
        }
        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            System.Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            System.Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }

        public override async Task BeforeUpdate(UserUpdateRequest request, Database.User entity)
        {
            base.BeforeUpdate(request, entity);
            if (request.Password != null)
            {
                if (request.Password != request.PasswordConfirmed)
                {
                    throw new Exception("Password i PasswordPotvrda moraju biti iste");
                }

                entity.PasswordSalt = GenerateSalt();
                entity.PasswordHash = GenerateHash(entity.PasswordSalt, request.Password);
            }
        }

        public Model.User Login(LoginInsertRequest req)
        {
            var entity = Context.Users.Include(x => x.UserRoles).ThenInclude(y => y.Role).FirstOrDefault(x => x.Username == req.Username);

            if (entity == null)
            {
                return null;
            }

            var hash = GenerateHash(entity.PasswordSalt, req.Password);

            if (hash != entity.PasswordHash)
            {

                return null;
            }

            return this.Mapper.Map<Model.User>(entity);
        }

        public Model.User AddUloga(int id, string namerole)
        {
            var user = Context.Users.Include("UserRoles.Role").FirstOrDefault(x => x.UserId == id);
            var role = Context.Roles.FirstOrDefault(x => x.Name.ToLower() == namerole);
            Database.UserRole newrole = new Database.UserRole
            {
                ChangedDate = DateTime.Now,
                UserId = id,
                RoleId = role.RoleId
            };
            Context.UserRoles.Add(newrole);
            Context.SaveChanges();
            return Mapper.Map<Model.User>(user);
        }

       
    }
}
