using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Requests
{
    public class ReviewInsertRequest
    {
        public int? Mark  { get; set;}
        public int? UserId { get; set; }
        public int? ProductId { get; set; }
    }
}
