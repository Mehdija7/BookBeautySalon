using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Requests
{
    public  class UserInsertRequest
    {
        public string? FirstName { get; set; }
        public string?  LastName{ get; set; }
        public string? Email { get; set; }
        public string? Phone { get; set; }
        public string? Address { get; set; }
        public int? GenderId { get; set; }
        public string? Username { get; set; }

        [Compare ("PasswordConfirmed", ErrorMessage = "Lozinke se ne podudaraju")]
        public string? Password { get; set; }

        [Compare("Password", ErrorMessage = "Lozinke se ne podudaraju")]
        public string? PasswordConfirmed { get; set; }
    }

}
