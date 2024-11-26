using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Requests
{
    public class AppointmentGetRequest
    {
     
            public int AppointmentId { get; set; }

            public DateTime? DateTime { get; set; }

            public int? UserId { get; set; }

            public int HairdresserId { get; set; }

            public int ServiceId { get; set; }

            public string? Note { get; set; }

            public virtual Service? Service { get; set; }

    }
}
