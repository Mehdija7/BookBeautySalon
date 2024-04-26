using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.ProductStateMachine;
using MapsterMapper;
using Microsoft.Extensions.Logging;

namespace bookBeauty.Services
{
    public class ProductService : BaseCRUDService<Model.Product, ProductSearchObject, Database.Product, ProductInsertRequest, ProductUpdateRequest>, IProductService

    {
        ILogger<ProductService> _logger;
        public BaseProductState BaseProductState { get; set; }
        public ProductService(Database._200101Context context, IMapper mapper,BaseProductState baseProductState, ILogger<ProductService> logger) : base(context, mapper)
        {
            BaseProductState = baseProductState;
            _logger = logger;
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

        public Model.Product Edit(int id)
        {
            var entity = GetById(id);
            var state = BaseProductState.CreateState(entity.StateMachine);
            return state.Edit(id);
        }

        public Model.Product Hide(int id)
        {
            var entity = GetById(id);
            var state = BaseProductState.CreateState(entity.StateMachine);
            return state.Hide(id);
        }

        public List<string> AllowedActions(int id)
        {
            _logger.LogInformation($"Allowed actions called for: {id}");

            if( id <= 0 )
            {
                var state = BaseProductState.CreateState("initial");
                return state.AllowedActions(null);
            }
            else
            {
                var entity = Context.Products.Find(id);
                var state = BaseProductState.CreateState(entity.StateMachine);
                return state.AllowedActions(entity);
            }

        }
    }
}
