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
        [Required(AllowEmptyStrings = false, ErrorMessage = "This field can not be empty.")]
        [MinLength(2, ErrorMessage = "The user name can't be less than 2 characters.")]
        [MaxLength(50, ErrorMessage = "The user name can't be more than 50 characters.")]
        public string FirstName { get; set; } = null!;

        [Required(AllowEmptyStrings = false, ErrorMessage = "This field can not be empty.")]
        [MinLength(2, ErrorMessage = "The user lastname can't be less than 2 characters.")]
        [MaxLength(50, ErrorMessage = "The user lastname can't be more than 50 characters.")]
        public string LastName { get; set; } = null!;

        [Required(AllowEmptyStrings = false, ErrorMessage = "This field can not be empty.")]
        [EmailAddress(ErrorMessage = "The email needs to be in a valid format")]
        public string Email { get; set; } = null!;

        [Required(AllowEmptyStrings = false, ErrorMessage = "This field can not be empty.")]
        [Phone(ErrorMessage = "The phone needs to be in a valid format")]
        public string Phone { get; set; } = null!;
        public string? Address { get; set; }

        [Required]
        public int GenderId { get; set; }


        [Required(AllowEmptyStrings = false, ErrorMessage = "This field can not be empty.")]
        [MinLength(2, ErrorMessage = "The username can't be less than 2 characters.")]
        [MaxLength(50, ErrorMessage = "The username can't be more than 50 characters.")]
        public string Username { get; set; } = null!;
        public byte[]? UserImage { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "This field can not be empty.")]
        [Compare ("PasswordConfirmed", ErrorMessage = "Lozinke se ne podudaraju")]
        public string Password { get; set; } = null!;

        [Required(AllowEmptyStrings = false, ErrorMessage = "This field can not be empty.")]
        [Compare("Password", ErrorMessage = "Lozinke se ne podudaraju")]
        public string? PasswordConfirmed { get; set; } = null!;
    }

}
