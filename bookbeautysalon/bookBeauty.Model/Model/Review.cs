using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Model
{
    public class Review
    {
        public int ReviewId { get; set; }
        public int Mark { get; set; }
        public int ProductId { get; set; }
        public int UserId { get; set; }
        public virtual Product? Product { get; set; }
        public virtual User? User { get; set; }
    }
}
