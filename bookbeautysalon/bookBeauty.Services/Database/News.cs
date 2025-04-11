using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services.Database
{
    public partial class News
    {
        public int NewsId { get; set; }
        public required string Title { get; set; }
        public required string Text { get; set; }
        public DateTime? DateTime { get; set; }
        public byte[]? NewsImage { get; set; }
        public int HairdresserId { get; set; }
        public virtual User? Hairdresser { get; set; }
    }

}
