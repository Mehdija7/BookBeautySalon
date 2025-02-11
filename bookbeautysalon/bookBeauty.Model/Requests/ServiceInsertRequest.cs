using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Requests
{
    public class ServiceInsertRequest
    {
        public string Name { get; set; } = null!;
        public float Price { get; set; }
        public string ShortDescription { get; set; } = null!;
        public string LongDescription { get; set; } = null!;
        public int Duration { get; set; }
        public byte[]? Image { get; set; }

    }
}
