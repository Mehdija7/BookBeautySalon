using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Requests
{
    public class RecommendResultUpsertRequest
    {
        public int ProductId { get; set; }
        public int FirstProduct { get; set; }
        public int SecondProduct { get; set; }
        public int ThirdProduct { get; set; }
    }
}
