using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Model
{
    public class User
    {
        public int UserId { get; set; }
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string Username { get; set; } = null!;
        public string? Address { get; set; } 
        public string Email { get; set; } = null!;
        public string Phone { get; set; } = null!;
        public byte[]? UserImage { get; set; }
        public virtual ICollection<UserRoles> UserRoles { get; set; } = [];

    }
}
