using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.Security.Cryptography;
using System.Text;
using bookBeauty.Model;
using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using bookBeauty.Model.Model;

namespace bookBeauty.Services.Services
{
    public class UserService : BaseCRUDService<Model.Model.User, UserSearchObject, Database.User, UserInsertRequest, UserUpdateRequest>, IUserService
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


            foreach (var u in Context.Users)
            {
                if (u.Username.Equals(request.Username))
                    throw new UserException("Username already exist.");
            }

            if (request.Password != request.PasswordConfirmed)
            {
                throw new UserException("Password i PasswordConfirmed must be the same.");
            }

            entity.PasswordSalt = GenerateSalt();
            entity.PasswordHash = GenerateHash(entity.PasswordSalt, request.Password);
            await base.BeforeInsert(request, entity);
        }

        public static string GenerateSalt()
        {
            var byteArray = RandomNumberGenerator.GetBytes(16);


            return Convert.ToBase64String(byteArray);
        }
        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }

        public override async Task BeforeUpdate(UserUpdateRequest request, Database.User entity)
        {
            await base.BeforeUpdate(request, entity);
            if (request.Password != null)
            {
                if (request.Password != request.PasswordConfirmed)
                {
                    throw new Exception("Password i PasswordConfirmed must be the same.");
                }

                entity.PasswordSalt = GenerateSalt();
                entity.PasswordHash = GenerateHash(entity.PasswordSalt, request.Password);
            }
        }

        public async Task<Model.Model.User> Login(LoginInsertRequest req)
        {

            Console.WriteLine("++++++++++++++++++     login endpoint         +++++++++++++++++++++");
            Console.WriteLine(req);
            Console.WriteLine(req.Username);
            Console.WriteLine(req.Password);
            var entity = Context.Users.Include(x => x.UserRoles).ThenInclude(y => y.Role).FirstOrDefault(x => x.Username == req.Username) ?? throw new UserException("Korisnik s takvim imenom ne postoji");
            Console.WriteLine(entity.Username);
            Console.WriteLine(entity.PasswordSalt);
            var hash = GenerateHash(entity.PasswordSalt, req.Password);
            Console.WriteLine("Hash entity");
            Console.WriteLine(entity.PasswordHash);
            Console.WriteLine("Hash request");
            Console.WriteLine(hash);
            if (hash != entity.PasswordHash)
            {
                throw new UserException("Wrong username or password");
            }

            return Mapper.Map<Model.Model.User>(entity);
        }
        public Model.Model.User AddRole(int id, string namerole)
        {
            var user = Context.Users.Include("UserRoles.Role").FirstOrDefault(x => x.UserId == id);
            var role = Context.Roles.FirstOrDefault(x => x.Name.ToLower() == namerole);
            UserRole newrole = new UserRole
            {
                ChangedDate = DateTime.Now,
                UserId = id,
                RoleId = role.RoleId
            };
            Context.UserRoles.Add(newrole);
            Context.SaveChanges();
            return Mapper.Map<Model.Model.User>(user);
        }


        public Model.Model.User AddUserRole(int id)
        {
            var user = Context.Users.Include("UserRoles.Role").FirstOrDefault(x => x.UserId == id);
            var role = Context.Roles.FirstOrDefault(x => x.Name.ToLower() == "customer"); ;
            UserRole newrole = new UserRole
            {
                ChangedDate = DateTime.Now,
                UserId = id,
                RoleId = role.RoleId
            };
            Context.UserRoles.Add(newrole);
            Context.SaveChanges();
            return Mapper.Map<Model.Model.User>(user);
        }

        public List<UserRoles> GetUserRoles(int id)
        {
            var userRoles = Context.UserRoles.Include(r => r.Role).Where(u => u.UserId == id).ToList();
            return Mapper.Map<List<UserRoles>>(userRoles);
        }

        public List<Model.Model.User> GetHairdressers()
        {
            var users = Context.Users
            .Include("UserRoles.Role")
             .Where(u => u.UserRoles.Any(r => r.Role.Name.ToLower() == "hairdresser"))
            .ToList();

            return Mapper.Map<List<Model.Model.User>>(users);
        }



        public void DeleteUserRoles(int userId)
        {
            var userRoles = Context.UserRoles.Where(ur => ur.UserId == userId).ToList();

            Context.UserRoles.RemoveRange(userRoles);

            Context.SaveChanges();
        }

        public Model.Model.User UserRegistration(UserInsertRequest request)
        {
            if (request.Password != null)
            {
                if (request.Password != request.PasswordConfirmed)
                {
                    throw new UserException("Password i PasswordConfirmed must be the same. ");
                }
                var salt = GenerateSalt();
                var hash = GenerateHash(salt, request.Password);
                Database.User user = new Database.User
                {
                    FirstName = request.FirstName,
                    LastName = request.LastName,
                    Email = request.Email,
                    Address = request.Address,
                    Username = request.Username,
                    PasswordSalt = salt,
                    PasswordHash = hash,
                    Phone = request.Phone,
                    
                };
                Context.Add(user);
                Context.SaveChanges();
                var role = Context.Roles.FirstOrDefault(x => x.Name.ToLower() == "customer"); 
                UserRole newrole = new UserRole
                {
                    ChangedDate = DateTime.Now,
                    UserId = user.UserId,
                    RoleId = role.RoleId
                };
                Context.UserRoles.Add(newrole);
                Context.SaveChanges();
                return Mapper.Map<Model.Model.User>(user);
            }
            else
            {
                throw new UserException("Obavezna polja");
            }
        }
    }
}
