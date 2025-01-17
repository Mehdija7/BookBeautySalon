using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.SearchObjects
{
    public class UserSearchObject : BaseSearchObject
    {
        public string? FirstNameGTE { get; set; }
        public string? LastNameGTE { get; set; }

        public string? Email { get; set; }

        public string? Username { get; set; }

        public bool? IsUserRoleIncluded { get; set; }

        public string? OrderBy { get; set; }
    }
}
