using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model
{
    public class Product
    {
        public int ProductId { get; set; } 

        public string Name { get; set; } = null!;

        public double Price { get; set; }

        public string Description { get; set; } = null!;

        public int? CategoryId { get; set; }

        public string? StateMachine { get; set; }

        public byte[] Image { get; set; }
        public virtual Category? Category { get; set; }
    }
}
