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
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? Username { get; set; }
        public string? Address { get; set; }
        public string? Email { get; set; }
        public int GenderId { get; set; }
        public string? Phone { get; set; }
        public virtual ICollection<UserRoles> UserRoles { get; set; } = [];
        public virtual Gender? Gender { get; set; }

    }
}
