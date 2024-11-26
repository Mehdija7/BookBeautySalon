using System;
using System.Collections.Generic;

namespace bookBeauty.Services.Database;

public partial class Appointment
{
    public int AppointmentId { get; set; }

    public DateTime? DateTime { get; set; }

    public int? UserId { get; set; }

    public int HairdresserId { get; set; } 

    public int ServiceId { get; set; }

    public string? Note { get; set; }

    public virtual Service Service { get; set; } = null!;

    public virtual User? User { get; set; }
    public virtual User? Hairdresser { get; set; }
}
