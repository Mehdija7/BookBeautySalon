using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using bookBeauty.Model.Model;

namespace bookBeauty.Model.Requests
{
    public class OrderInsertRequest
    {
        public float TotalPrice { get; set; }
        public DateTime? DateTime { get; set; }
        public List<OrderItem> Items { get; set; } = null!;
        public int CustomerId { get; set; }
        public string OrderNumber { get; set; } = null!;
    }
}
