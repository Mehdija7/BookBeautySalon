using Azure.Core;
using bookBeauty.Model.Messages;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using EasyNetQ;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;
using RabbitMQ.Client;
using RabbitMQ.Client.Exceptions;
using System.Text;


namespace bookBeauty.Services.Services
{

    public class OrderService(_200101Context context, IMapper mapper) : BaseCRUDService<Model.Model.Order, OrderSearchObject, Database.Order, OrderInsertRequest, OrderUpdateRequest>(context, mapper), IOrderService
    {
    
        public override IQueryable<Database.Order> AddInclude(IQueryable<Database.Order> query, OrderSearchObject? search = null)
        {
            query = query.Include("OrderItems.Product");
            return base.AddInclude(query, search);
        }
    }
}
