using bookBeauty.Model.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services.Services
{
    public interface IProductService : ICRUDService<Product, ProductSearchObject, ProductInsertRequest, ProductUpdateRequest>
    {

        public Task<Product> Activate(int id);
        public Task<Product> Edit(int id);
        public Task<Product> Hide(int id);
        public Task<List<string>> AllowedActions(int id);
        List<Product> Recommended(int id);

    }
}
