using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Model
{
    public class UserRoles
    {
        public int UserRoleId { get; set; }

        public int UserId { get; set; }

        public int RoleId { get; set; }

        public DateTime? ChangedDate { get; set; }

        public virtual Role Role { get; set; } = null!;
    }
}
