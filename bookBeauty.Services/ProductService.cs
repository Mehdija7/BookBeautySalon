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

        public override async Task <Model.Product> Insert(ProductInsertRequest request)
        {
            var state = BaseProductState.CreateState("initial");
            return await state.Insert(request);
        }

        public override async Task <Model.Product> Update(int id, ProductUpdateRequest request)
        {
            var entity = await GetById(id);
            var state =  BaseProductState.CreateState(entity.StateMachine);
            return await state.Update(id, request);

        }

        public async Task<Model.Product> Activate(int id)
        {
            var entity = await  GetById(id);
            var state = BaseProductState.CreateState(entity.StateMachine);
            return await state.Activate(id);
        }

        public async Task<Model.Product> Edit(int id)
        {
            var entity = await GetById(id);
            var state = BaseProductState.CreateState(entity.StateMachine);
            return await state.Edit(id);
        }

        public async Task<Model.Product> Hide(int id)
        {
            var entity = await GetById(id);
            var state = BaseProductState.CreateState(entity.StateMachine);
            return await state.Hide(id);
        }

        public async Task<List<string>> AllowedActions(int id)
        {
            _logger.LogInformation($"Allowed actions called for: {id}");

            if( id <= 0 )
            {
                var state = BaseProductState.CreateState("initial");
                return await state.AllowedActions(null);
            }
            else
            {
                var entity = Context.Products.Find(id);
                var state = BaseProductState.CreateState(entity.StateMachine);
                return await state.AllowedActions(entity);
            }

        }
    }
}
