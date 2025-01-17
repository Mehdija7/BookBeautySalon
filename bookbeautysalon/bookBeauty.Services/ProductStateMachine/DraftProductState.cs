using bookBeauty.Model.Requests;
using bookBeauty.Services.Database;
using MapsterMapper;
using EasyNetQ;
using bookBeauty.Model.Messages;

namespace bookBeauty.Services.ProductStateMachine
{
    public class DraftProductState(_200101Context context, IMapper mapper, IServiceProvider serviceProvider) : BaseProductState(context, mapper, serviceProvider)
    {
        public override async Task<Model.Model.Product> Update(int id, ProductUpdateRequest request)
        {
            var set = Context.Set<Database.Product>();

            var entity = set.Find(id);
            if(entity != null)
            {
                Mapper.Map(request, entity);

                Context.SaveChanges();

                return Mapper.Map<Model.Model.Product>(entity);
            }
             return await  base.Update(id, request);
                  
        }

        public override async Task< Model.Model.Product> Activate(int id)
        {
            var set = Context.Set<Database.Product>();

            var entity = set.Find(id);

            if(entity != null)
            {
                entity.StateMachine = "active";

                var mappedEntity = Mapper.Map<Model.Model.Product>(entity);

                Context.SaveChanges();

                return mappedEntity;
            }
            return await  base.Activate(id);
        }

        public override async Task<List<string>> AllowedActions(Database.Product entity)
        {
            return [nameof(Update), nameof(Activate)];
        }
    }
}
