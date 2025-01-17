using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Model
{
    public class Order
    {
        public int OrderId { get; set; }

        public float TotalPrice { get; set; }

        public DateTime DateTime { get; set; }

        public int CustomerId { get; set; }

        public string? OrderNumber { get; set; }

        public string? Status { get; set; }

        public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();

        public virtual User? User { get; set; }


    }
}
