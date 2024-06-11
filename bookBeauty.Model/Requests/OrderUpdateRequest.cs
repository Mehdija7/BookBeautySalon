using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Requests
{
    public class OrderUpdateRequest
    {
        public float? TotalPrice { get; set; }
        public List<OrderItem>? Items { get; set; }
        public string? Status { get; set; }

    }
}
