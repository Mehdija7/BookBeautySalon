using System;
using System.Collections.Generic;

namespace bookBeauty.Services.Database;

public partial class Service
{
    public int ServiceId { get; set; }
    public required string Name { get; set; }
    public required string ShortDescription { get; set; }
    public required string LongDescription { get; set; }
    public float Price { get; set; }
    public int Duration { get; set; }
    public byte[]? Image { get; set; }
    public virtual ICollection<Appointment> Appointments { get; set; } = [];
}
