using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Requests
{
    public class NewsUpsertRequest
    {
        public string? Title { get; set; }
        public string? Text { get; set; }
        public DateTime? DateTime  { get; set; }
    }
}
