using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Requests
{
    public class ProductInsertRequest
    {
        public string Name { get; set; }
        public float Price { get; set; }
        public int CategoryId { get; set; }
        public string? Picture { get; set; }
        public string? StateMachine { get; set; }
    }
}
