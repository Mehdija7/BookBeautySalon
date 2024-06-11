using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Requests
{
     public class OrderItemInsertRequest
    {
        public int? Quantity { get; set; }

        public string? ProductId { get; set; }

        public int? OrderId { get; set; }
    }
}
