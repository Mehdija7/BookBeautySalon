using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Requests
{
    public class ProductUpdateRequest
    {
        public float Price { get; set; }
        public string StateMachine { get; set; } = null!;
        public string Description { get; set; } = null!;
        public byte[]? Image { get; set; }
    }
}
