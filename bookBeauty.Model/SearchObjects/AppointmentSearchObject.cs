using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.SearchObjects
{
    public class AppointmentSearchObject : BaseSearchObject
    {
        public string Hairdresser  { get; set; }
        public string Customer { get; set; }
        public DateTime Date { get; set; }
    }
}
