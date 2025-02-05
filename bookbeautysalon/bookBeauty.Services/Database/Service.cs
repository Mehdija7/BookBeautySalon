using System;
using System.Collections.Generic;

namespace bookBeauty.Services.Database;

public partial class Service
{
    public int ServiceId { get; set; }
    public string? Name { get; set; }
    public string? ShortDescription { get; set; }
    public string? LongDescription { get; set; }
    public float Price { get; set; }
    public int Duration { get; set; }
    public string? Image { get; set; }
    public virtual ICollection<Appointment>? Appointments { get; set; } = [];
}
