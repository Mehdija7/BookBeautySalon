using bookBeauty.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services
{
    public interface IProductService : ICRUDService<Product,ProductSearchObject,ProductInsertRequest,ProductUpdateRequest>
    {

        public Product Activate(int id);
        public Product Edit(int id);
        public Product Hide(int id);
        public List<string> AllowedActions(int id);

    }
}
