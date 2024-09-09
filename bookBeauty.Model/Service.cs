using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model
{
    public class Service
    {
        public int ServiceId { get; set; }
        public string Name { get; set; }
        public float Price { get; set; }
        public string ShortDescription { get; set; }
        public string LongDescription { get; set; }
        public int Duration { get; set; }
        public string? Image { get; set; }
    }
}
