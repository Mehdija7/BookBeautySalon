using System;
using System.Collections.Generic;

namespace bookBeauty.Services.Database;

public partial class Favorite
{
    public int FavoriteId { get; set; }

    public string? AddedDate { get; set; }

    public string? ProductId { get; set; }

    public int? UserId { get; set; }

    public virtual Product? Product { get; set; }

    public virtual User? User { get; set; }
}
