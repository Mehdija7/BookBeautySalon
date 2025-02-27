﻿using System;
using System.Collections.Generic;

namespace bookBeauty.Services.Database;

public partial class Role
{
    public int RoleId { get; set; }

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    public virtual ICollection<UserRole> UserRoles { get; set; } = [];
}
