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
    public class OrderService : BaseCRUDService<Model.Model.Order, OrderSearchObject, Database.Order, OrderInsertRequest, OrderUpdateRequest>, IOrderService
    {
        private readonly _200101Context context;

        // Constructor explicitly passing context to the base class constructor
        public OrderService(_200101Context context, IMapper mapper)
            : base(context, mapper) // Pass context directly to the base class
        {
            this.context = context;
        }

        public override IQueryable<Database.Order> AddInclude(IQueryable<Database.Order> query, OrderSearchObject? search = null)
        {
            query = query.Include("OrderItems.Product");
            return base.AddInclude(query, search);
        }

        public override async Task BeforeInsert(OrderInsertRequest request, Database.Order entity)
        {
            entity.OrderNumber = "#" + (context.Orders.Count() + 1).ToString();
            entity.Status = "Kreirana";
            await base.BeforeInsert(request, entity);
        }
    }
}
