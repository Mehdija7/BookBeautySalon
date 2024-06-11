using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model
{
    public class Favorites
    {
        public int FavoriteId { get; set; }

        public DateTime  AddedDate { get; set; }

        public int? ProductId { get; set; }

        public int? UserId { get; set; }

    }
}
