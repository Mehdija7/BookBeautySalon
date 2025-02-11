using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Requests
{
    public class CommentProductUpsertRequest
    {
        public DateTime CommentDate { get; set; }

        public string CommentText { get; set; } = null!;

        public int UserId { get; set; }

        public int ProductId { get; set; }
    }
}
