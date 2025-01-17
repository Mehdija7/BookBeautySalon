using bookBeauty.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services.ProductStateMachine
{
    public class HiddenProductState(_200101Context context, IMapper mapper, IServiceProvider serviceProvider) : BaseProductState(context, mapper, serviceProvider)
    {
        public override async Task<Model.Model.Product> Edit(int id)
        {
            var set =  Context.Set<Database.Product>();

            var entity =  set.Find(id);

            if(entity != null) {

                entity.StateMachine = "draft";

                Context.SaveChanges();

                return Mapper.Map<Model.Model.Product>(entity);
            }
            return await base.Edit(id);
           
        }

        public override  async Task<List<string>> AllowedActions(Database.Product entity)
        {
            return [nameof(Edit)];
        }
    }
}
