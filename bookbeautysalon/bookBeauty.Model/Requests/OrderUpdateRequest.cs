using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using bookBeauty.Model.Model;

namespace bookBeauty.Model.Requests
{
    public class OrderUpdateRequest
    {
        
        public float TotalPrice { get; set; }
        public List<OrderItem>? OrderItems { get; set; }
        public string Status { get; set; } = null!;
        public DateTime? DateTime { get; set; }

    }
}
