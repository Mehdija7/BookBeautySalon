using System;
using System.Collections.Generic;

namespace bookBeauty.Services.Database;

public partial class Gender
{
    public int GenderId { get; set; }

    public string? Name { get; set; }

    public virtual ICollection<User> Users { get; set; } = [];
}
