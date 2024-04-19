using bookBeauty.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.ProductStateMachine;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services
{
    public class ProductService : BaseCRUDService<Model.Product, ProductSearchObject, Database.Product, ProductInsertRequest, ProductUpdateRequest>, IProductService
        
    {
        public BaseProductState BaseProductState { get; set; }
        public ProductService(Database._200101Context context, IMapper mapper,BaseProductState baseProductState) : base(context, mapper)
        {
            BaseProductState = baseProductState;
        }

        public override IQueryable<Database.Product> AddFilter(ProductSearchObject search, IQueryable<Database.Product> query)
        {
            var filteredQuery = base.AddFilter(search, query);

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                filteredQuery = filteredQuery.Where(x => x.Name.Contains(search.FTS));
            }

            return filteredQuery;
        }

        public override Model.Product Insert(ProductInsertRequest request)
        {
            var state = BaseProductState.CreateState("initial");
            return state.Insert(request);
        }

        public override Model.Product Update(int id, ProductUpdateRequest request)
        {
            var entity = GetById(id);
            var state = BaseProductState.CreateState(entity.StateMachine);
            return state.Update(id, request);

        }

        public Model.Product Activate(int id)
        {
            var entity = GetById(id);
            var state = BaseProductState.CreateState(entity.StateMachine);
            return state.Activate(id);
        }
    }
}
