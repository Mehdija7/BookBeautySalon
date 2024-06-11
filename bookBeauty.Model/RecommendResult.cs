using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model
{
    public class RecommendResult
    {
        public int RecommendResultId { get; set; }

        public string? ProductId { get; set; }

        public string? FirstProductId { get; set; }

        public string? SecondProductId { get; set; }

        public string? ThirdProductId { get; set; }
    }
}
