using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Model
{
    public class Transaction
    {
        public int TransactionId { get; set; }

        public string Name { get; set; } = null!;

        public int OrderId { get; set; }

        public float Price { get; set; }

        public string Status { get; set; } = null!;

        public  virtual Order? Order { get; set; }

    }
}
