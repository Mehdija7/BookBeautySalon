using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Requests
{
    public class ProductUpdateRequest
    {
        public string? Name { get; set; }
        public float Price { get; set; }
        public string? Image { get; set; }
        public string? StateMachine { get; set; }
    }
}
