using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model
{
    public class Appointment
    {
        public int AppointmentId { get; set; }

        public DateTime? DateTime { get; set; }

        public int? UserId { get; set; }

        public int HairDresserId { get; set; } 

        public int ServiceId { get; set; }
    }
}
