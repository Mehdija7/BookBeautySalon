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
        public string Title { get; set; } = null!;
        public string Text { get; set; } = null!;
        public DateTime? DateTime { get; set; }
        public int HairdresserId { get; set; }
        public byte[]? NewsImage { get; set; }
        public virtual User? Hairdresser { get; set; }
    }
}
