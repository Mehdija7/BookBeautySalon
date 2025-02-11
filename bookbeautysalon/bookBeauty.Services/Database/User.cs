using System;
using System.Collections.Generic;

namespace bookBeauty.Services.Database;

public partial class User
{
    public int UserId { get; set; }

    public string? FirstName { get; set; }

    public string? LastName { get; set; }

    public string? Username { get; set; }

    public string? Email { get; set; }

    public string? Phone { get; set; }

    public string? Address { get; set; }

    public string? PasswordHash { get; set; }

    public string? PasswordSalt { get; set; }

    public byte[]? UserImage { get; set; }
    public virtual ICollection<Appointment> Appointments { get; set; } = [];

    public virtual ICollection<FavoriteProduct> FavoriteProducts { get; set; } = [];

    public virtual ICollection<Order> Orders { get; set; } = [];

    public virtual ICollection<Review> Reviews { get; set; } = [];

    public virtual ICollection<UserRole> UserRoles { get; set; } = [];
    public virtual ICollection<News> News { get; set; } = [];
    public virtual ICollection<CommentProduct> CommentProducts { get; set; } = [];
}
