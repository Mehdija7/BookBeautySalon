using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Requests
{
    public class OrderInsertRequest
    {
        public float? TotalPrice { get; set; }

        public DateTime? DateTime { get; set; }
        public List<OrderItem>? Items { get; set; }

        public int CustomerId { get; set; }

        public string? OrderNumber { get; set; }
    }
}
