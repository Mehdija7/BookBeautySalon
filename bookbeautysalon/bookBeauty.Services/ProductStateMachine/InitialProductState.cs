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
    public class InitialProductState(_200101Context context, IMapper mapper, IServiceProvider serviceProvider) : BaseProductState(context, mapper, serviceProvider)
    {
        public override async Task <Model.Model.Product> Insert(ProductInsertRequest request)
        {

            var set = Context.Set<Database.Product>();
            Console.WriteLine("**********************   PRODUCT SET   **********************************************");
            Console.WriteLine(set);
            var entity = Mapper.Map<Database.Product>(request);
            Console.WriteLine("**********************   PRODUCT ENTITY   **********************************************");
            Console.WriteLine(entity.Price);
            entity.StateMachine = "draft";
            try
            {
                set.Add(entity);
                Console.WriteLine(entity.Price.GetType());
                Context.SaveChanges();
            }
            catch (Exception ex)
            {
                Console.WriteLine("**********************   EXCEPTION   **********************************************");
                Console.WriteLine(ex.Message);
                Console.WriteLine(ex.InnerException?.Message);
            }


            return Mapper.Map<Model.Model.Product>(entity);
        }
        public override async Task<List<string>> AllowedActions(Database.Product entity)
        {
            return [nameof(Insert)];
        }
    }
}
