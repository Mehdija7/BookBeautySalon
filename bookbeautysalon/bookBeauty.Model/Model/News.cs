using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Model
{
    public class News
    {
        public int NewsId { get; set; }
        public string? Title { get; set; }
        public string? Text { get; set; }
        public DateTime? DateTime { get; set; }
    }
}
