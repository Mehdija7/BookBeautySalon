using bookBeauty.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services.ProductStateMachine
{
    public class HiddenProductState : BaseProductState
    {
        public HiddenProductState(_200101Context context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }
        public override async Task<Model.Product> Edit(int id)
        {
            var set = Context.Set<Database.Product>();

            var entity = set.Find(id);

            entity.StateMachine = "draft";

            Context.SaveChanges();

            return Mapper.Map<Model.Product>(entity);
        }

        public override async Task<List<string>> AllowedActions(Database.Product entity)
        {
            return new List<string>() { nameof(Edit) };
        }
    }
}
