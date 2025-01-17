using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Requests
{
    public class FavoritesUpsertRequest
    {
        public DateTime AddingDate { get; set; }

        public int? ProductId { get; set; }

        public int? UserId { get; set; }
    }
}
