using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Model.Model
{
    public class FavoriteProduct
    {
        public int FavoriteProductsId { get; set; }

        public DateTime AddingDate { get; set; }

        public int ProductId { get; set; }

        public int UserId { get; set; }

        public virtual Product? Product { get; set; }

    }
}
