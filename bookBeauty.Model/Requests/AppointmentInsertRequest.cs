using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Requests
{
    public class AppointmentInsertRequest
    {
        public int UserId { get; set; }
        public int HairdresserId { get; set; }
        public DateTime Date { get; set; }
        public int ServiceId { get; set; }
    }
}
