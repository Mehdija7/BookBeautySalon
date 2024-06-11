using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Dynamic.Core;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services
{
    public class CategoryService : BaseCRUDService<Model.Category, CategorySearchObject, Database.Category, CategoryUpsertRequest, CategoryUpsertRequest>, ICategoryService
    {
        public CategoryService(_200101Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override async Task BeforeInsert(CategoryUpsertRequest request, Category entity)
        {
            entity.CategoryId = Context.Categories.Count();
             base.BeforeInsert(request, entity);
        }
    }
}
