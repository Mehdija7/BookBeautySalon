using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Model
{
    public class CommentProduct
    {
        public int CommentProductId { get; set; }

        public DateTime CommentDate { get; set; }

        public string CommentText { get; set; } = null!;

        public int UserId { get; set; }

        public int ProductId { get; set; }
        public virtual Product? Product { get; set; }

        public virtual User? User { get; set; }
    }
}
