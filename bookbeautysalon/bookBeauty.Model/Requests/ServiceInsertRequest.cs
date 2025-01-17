using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Requests
{
    public class ServiceInsertRequest
    {
        public string? Name { get; set; }
        public float Price { get; set; }
        public string? ShortDescription { get; set; }       
        public string? LongDescription { get; set; }
        public int Duration { get; set; }
        public string? Image { get; set; }

    }
}
