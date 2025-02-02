using bookBeauty.Model.Model;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services.Services
{
    public abstract class BaseService<TModel, TSearch, TDbEntity>(_200101Context context, IMapper mapper) : IBaseService<TModel, TSearch> where TSearch : BaseSearchObject where TDbEntity : class where TModel : class
    {
        protected _200101Context Context { get; set; } = context;
        public IMapper Mapper { get; set; } = mapper;

        public virtual async Task<PagedResult<TModel>> GetPaged(TSearch search)
        {
            List<TModel> result = [];

            var query =  Context.Set<TDbEntity>().AsQueryable();

            Console.WriteLine("BASE SERVICE ");
            foreach (var item in query.ToList())
            {
                Console.WriteLine(item);
            }

            query = AddFilter(search, query);

            foreach (var item in query.ToList())
            {
                Console.WriteLine(item);
            }
            query = AddInclude(query,search);
            foreach (var item in query.ToList())
            {
                Console.WriteLine(item);
            }

            int count = await query.CountAsync();

            Console.WriteLine(count);
            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query.Skip(search.Page.Value * search.PageSize.Value).Take(search.PageSize.Value);
            }

            var list = await query.ToListAsync();
            foreach (var item in list)
            {
                Console.WriteLine(item);
            }
            result = Mapper.Map(list, result);
            foreach (var item in result)
            {
                Console.WriteLine(item);
            }
            PagedResult<TModel> pagedResult = new()
            {
                ResultList = result,
                Count = count
            };

            return pagedResult;
        }

        public virtual IQueryable<TDbEntity> AddFilter(TSearch search, IQueryable<TDbEntity> query)
        {
            return query;
        }
        public virtual IQueryable<TDbEntity> AddInclude(IQueryable<TDbEntity> query, TSearch? search = null)
        {
            return query;
        }
        public virtual async Task<TModel> GetById(int id)
        {
            var entity =  Context.Set<TDbEntity>().Find(id);

            if (entity != null)
            {
                return  Mapper.Map<TModel>(entity);
            }
            else
            {
                return null;
            }

        }

    }
}
