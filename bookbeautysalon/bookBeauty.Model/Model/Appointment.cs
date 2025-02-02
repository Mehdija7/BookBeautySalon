using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Model
{
    public class Appointment
    {
        public int AppointmentId { get; set; }

        public DateTime? DateTime { get; set; }

        public int UserId { get; set; }

        public int HairdresserId { get; set; }

        public int ServiceId { get; set; }

        public string? Note { get; set; }

        public virtual Service Service { get; set; } = null!;

        public virtual User? User { get; set; }
        public virtual User? Hairdresser { get; set; }

    }
}
