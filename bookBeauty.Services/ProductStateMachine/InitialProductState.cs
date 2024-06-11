using bookBeauty.Model.Requests;
using bookBeauty.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services.ProductStateMachine
{
    public class InitialProductState : BaseProductState
    {
        public InitialProductState(_200101Context context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }
        public override async Task<Model.Product> Insert(ProductInsertRequest request)
        {
            var set = Context.Set<Database.Product>();
            var entity = Mapper.Map<Database.Product>(request);
            entity.StateMachine = "draft";
            set.Add(entity);
            Context.SaveChanges();

            return Mapper.Map<Model.Product>(entity);
        }

    }
}
