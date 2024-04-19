using bookBeauty.Model.Requests;
using bookBeauty.Services.Database;
using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;


namespace bookBeauty.Services.ProductStateMachine
{
    public class BaseProductState
    {
        public _200101Context Context { get; set; }
        public IMapper Mapper { get; set; }
        public IServiceProvider ServiceProvider { get; set; }

        public BaseProductState(_200101Context context, IMapper mapper, IServiceProvider serviceProvider)
        {
            Context = context;
            Mapper = mapper;
            ServiceProvider = serviceProvider;
        }
        public virtual Model.Product Insert(ProductInsertRequest request)
        {
            throw new Exception("Method not allowed");
        }

        public virtual Model.Product Update(int id, ProductUpdateRequest request)
        {
            throw new Exception("Method not allowed");
        }

        public virtual Model.Product Activate(int id)
        {
            throw new Exception("Method not allowed");
        }

        public virtual Model.Product Hide(int id)
        {
            throw new Exception("Method not allowed");
        }

        public BaseProductState CreateState(string stateName)
        {
            switch (stateName)
            {
                case "initial":
                    return ServiceProvider.GetService<InitialProductState>();
                case "draft":
                    return ServiceProvider.GetService<DraftProductState>();
                case "active":
                    return ServiceProvider.GetService<ActiveProductState>();
                default: throw new Exception("State not recognized");
            }
        }
    }
}
