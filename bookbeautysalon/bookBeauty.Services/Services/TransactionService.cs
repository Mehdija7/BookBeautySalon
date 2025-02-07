using bookBeauty.Model.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using RabbitMQ.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services.Services
{
    public class TransactionService : BaseCRUDService<Model.Model.Transaction, BaseSearchObject, Database.Transaction, TransactionInsertRequest, TransactionUpdateRequest>, ITransactionService
    {
        private readonly RabbitMQ.Client.IModel _channel;
        private readonly string _host = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost";
        private readonly string _username = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest";
        private readonly string _password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest";
        private readonly string _virtualhost = Environment.GetEnvironmentVariable("RABBITMQ_VIRTUALHOST") ?? "/";
        public TransactionService(_200101Context context, IMapper mapper) : base(context, mapper)
        {
            var factory = new ConnectionFactory
            {
                HostName = _host,
                UserName = _username,
                Password = _password
            };
            Console.WriteLine("||||||||||||||||||||| TRYING TO CONNECT FROM TRANSACTION SERVICE ||||||||||||||||");

            var connection = factory.CreateConnection();
            Console.WriteLine("||||||||||||||||||||   CONNECTED SUCCESFULLY FROM TRANSACTION SERVICE  ||||||||||||||||||||||||");
            _channel = connection.CreateModel();
            _channel.QueueDeclare(queue: "orderQueue",
                                 durable: false,
                                 exclusive: false,
                                 autoDelete: false,
                                 arguments: null);
        }

        public override async Task BeforeInsert(TransactionInsertRequest insert, Database.Transaction db)
        {
            Console.WriteLine(" id in the transaction");

            Console.WriteLine(insert.Name);
            Console.WriteLine(insert.OrderId);

           
            var order = await _context.Orders.FirstOrDefaultAsync(x=>x.OrderId==insert.OrderId);    


            var customer = await _context.Users.FirstOrDefaultAsync(x => x.UserId == order.CustomerId);
       
            Console.WriteLine(customer.Email);
            var userEmail = customer.Email;
            if (!string.IsNullOrEmpty(userEmail))
            {
              
                    var message = $"Order created for {userEmail}";
                    var body = Encoding.UTF8.GetBytes(message);
                    _channel.BasicPublish(exchange: "",
                                          routingKey: "orderQueue",
                                          basicProperties: null,
                                          body: body);
                
     
              
            }
            await base.BeforeInsert(insert,db);
        }

        public override IQueryable<Database.Transaction> AddInclude(IQueryable<Database.Transaction> query, BaseSearchObject? search = null)
        {
            query = query.Include("Order");
            return base.AddInclude(query, search);
        }
    }
}
