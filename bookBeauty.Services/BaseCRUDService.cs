using bookBeauty.Model;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services
{
    public abstract class BaseCRUDService<TModel, TSearch, TDbEntity, TInsert, TUpdate> : BaseService<TModel, TSearch, TDbEntity> where TModel : class where TSearch : BaseSearchObject where TDbEntity : class
    {
        protected readonly _200101Context _context;
        public BaseCRUDService(_200101Context context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }

        public virtual async Task<TModel> Insert(TInsert request)
        {


            TDbEntity entity =   Mapper.Map<TDbEntity>(request);

           await BeforeInsert(request, entity);

            Context.Add(entity);
            Context.SaveChanges();


            return  Mapper.Map<TModel>(entity);
        }

        public virtual async Task BeforeInsert(TInsert request, TDbEntity entity) { }

        public virtual async Task<TModel> Update(int id, TUpdate request)
        {
            var set = Context.Set<TDbEntity>();

            var entity = set.Find(id);

            Mapper.Map(request, entity);

            BeforeUpdate(request, entity);

            Context.SaveChanges();

            return Mapper.Map<TModel>(entity);
        }

        public virtual async Task BeforeUpdate(TUpdate request, TDbEntity entity) { }

        public virtual async Task<TModel> Delete(int id)
        {
            var entity = await _context.Set<TDbEntity>().FindAsync(id);
            if(entity == null)
            {
                throw new UserException($"Entity of {typeof(TModel).Name} type with id {id} does not exist");
            }
            _context.Set<TDbEntity>().Remove(entity);
            await _context.SaveChangesAsync();
            return Mapper.Map<TModel>(entity);

        }

    }
}
