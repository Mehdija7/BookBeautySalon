using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Requests
{
    public class TransactionInsertRequest
    {
        public int? OrderId { get; set; }

        public float? Price { get; set; }

        public string? Status { get; set; }

        public string? Name { get; set; }
    }
}
