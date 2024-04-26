using bookBeauty.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Services.Database;
using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;
using System.Runtime.InteropServices;


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
            throw new UserException("Metoda nije dozvoljena");
        }

        public virtual Model.Product Update(int id, ProductUpdateRequest request)
        {
            throw new UserException("Metoda nije dozvoljena");
        }

        public virtual Model.Product Activate(int id)
        {
            throw new UserException("Metoda nije dozvoljena");
        }

        public virtual Model.Product Hide(int id)
        {
            throw new UserException("Metoda nije dozvoljena");
        }
        public virtual Model.Product Edit(int id)
        {
            throw new UserException("Metoda nije dozvoljena");
        }

        public virtual List<string> AllowedActions(Database.Product entity)
        {
            throw new UserException("Metoda nije dozvoljena");
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
                case "hidden":
                    return ServiceProvider.GetService<HiddenProductState>();
                default: throw new Exception("State not recognized");
            }
        }
    }
}
