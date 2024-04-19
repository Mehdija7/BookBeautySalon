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
    public class DraftProductState : BaseProductState
    {
        public DraftProductState(_200101Context context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }
        public override Model.Product Update(int id, ProductUpdateRequest request)
        {
            var set = Context.Set<Database.Product>();

            var entity = set.Find(id);

            Mapper.Map(request, entity);

            Context.SaveChanges();

            return Mapper.Map<Model.Product>(entity);
        }

        public override Model.Product Activate(int id)
        {
            var set = Context.Set<Database.Product>();

            var entity = set.Find(id);

            entity.StateMachine = "active";

            Context.SaveChanges();

            return Mapper.Map<Model.Product>(entity);
        }
    }
}
