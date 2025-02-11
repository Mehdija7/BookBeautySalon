using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services.Services
{
    public interface ICommentProductService : ICRUDService<Model.Model.CommentProduct, BaseSearchObject, CommentProductUpsertRequest, CommentProductUpsertRequest>
    {

    }
}
