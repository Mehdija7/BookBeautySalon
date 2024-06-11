using System;
using System.Collections.Generic;

namespace bookBeauty.Services.Database;

public partial class HairDresser
{
    public int HairDresserId { get; set; } 

    public DateTime? StartDate { get; set; }

    public DateTime? EndDate { get; set; }

    public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();
}
