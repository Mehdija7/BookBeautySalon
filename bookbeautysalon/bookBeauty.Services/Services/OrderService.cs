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
#pragma warning disable CS9107 // Parameter is captured into the state of the enclosing type and its value is also passed to the base constructor. The value might be captured by the base class as well.
    public class OrderService(_200101Context context, IMapper mapper) : BaseCRUDService<Model.Model.Order, OrderSearchObject, Database.Order, OrderInsertRequest, OrderUpdateRequest>(context, mapper), IOrderService
#pragma warning restore CS9107 // Parameter is captured into the state of the enclosing type and its value is also passed to the base constructor. The value might be captured by the base class as well.
    {
        public override async Task BeforeInsert(OrderInsertRequest request, Database.Order entity)
        {

            entity.OrderNumber = "#" + (context.Orders.Count() + 1).ToString();
            entity.Status = "Kreirana";

            await base.BeforeInsert(request, entity);
        }

        public override IQueryable<Database.Order> AddFilter(OrderSearchObject search, IQueryable<Database.Order> query)
        {
            if (search?.UserId != 0)
            {
                query = query.Where(x => x.CustomerId == search.UserId);
            }

            return base.AddFilter(search, query);
        }

        public override async Task<Model.Model.Order> Update(int id, OrderUpdateRequest request)
        {
            return await base.Update(id, request);

        }



        public override Task<Model.Model.Order> Insert(OrderInsertRequest request)
        {
            /* var factory = new ConnectionFactory()
             {
                 HostName = "localhost",
                 Port = Protocols.DefaultProtocol.DefaultPort,
                 UserName = "guest",
                 Password = "guest",
                 VirtualHost = "/",
                 ContinuationTimeout = new TimeSpan(10, 0, 0, 0)
             };

             using var connection = factory.CreateConnection();
             using var channel = connection.CreateModel();

             channel.QueueDeclare(queue: "orders",
                                  durable: false,
                                  exclusive: false,
                                  autoDelete: false,
                                  arguments: null);

             var mappedEntity = Mapper.Map<Model.Order>(request);
             var newOrder = new OrderMade { Order = mappedEntity };
             var json = JsonConvert.SerializeObject(newOrder);
             var body = Encoding.UTF8.GetBytes(json);

             channel.BasicPublish(exchange: string.Empty,
                                  routingKey: "orders",
                                  basicProperties: null,
                                  body: body);*/

            return base.Insert(request);
        }



    }
}
