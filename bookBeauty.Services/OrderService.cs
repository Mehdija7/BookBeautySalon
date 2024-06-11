using bookBeauty.Model;
using bookBeauty.Model.Messages;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using EasyNetQ;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using RabbitMQ.Client;
using RabbitMQ.Client.Exceptions;
using System.Text;


namespace bookBeauty.Services
{
    public class OrderService : BaseCRUDService<Model.Order, OrderSearchObject, Database.Order, OrderInsertRequest, OrderUpdateRequest>, IOrderService
    {
        private _200101Context _context;

        public OrderService( _200101Context context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }

        public override async Task BeforeInsert(OrderInsertRequest request, Database.Order entity)
        {
            float? _amount= 0;
            foreach (var item in request.Items)
            {
                var productItem = _context.Products.Where(x => x.ProductId == item.ProductId).FirstOrDefault();
                var x = productItem.Price * item.Quantity;
                float? y = (float?)x;
               _amount += y;
            }
            entity.CustomerId = request.CustomerId;
            entity.DateTime = DateTime.Now;
            entity.OrderNumber = "#" + (_context.Orders.Count() + 1).ToString();
            entity.TotalPrice = _amount;
            entity.Status = "Pending";
            entity.OrderItems = request.Items.Select(item => new Database.OrderItem
            {
                Quantity = item.Quantity,
                ProductId = item.ProductId,
            }).ToList();
            base.BeforeInsert(request, entity);
        }

        public override IQueryable<Database.Order> AddFilter(OrderSearchObject search, IQueryable<Database.Order> query)
        {
            if (search?.UserId != 0)
            {
                query = query.Where(x => x.CustomerId == search.UserId);
            }

            return base.AddFilter(search, query);
        }

        public override async Task<Model.Order> Update(int id, OrderUpdateRequest request)
        {
            var entity = await _context.Orders.FindAsync(id);

            if(!IsValidStatusTransition(entity.Status,request.Status))
            {
                throw new UserException("Invalid status transaction");
            }
            else
            {
                return await base.Update(id, request);
            }
           
        }

        private bool IsValidStatusTransition(string? currentStatus, string? newStatus)
        {
            if (currentStatus == newStatus)
            {
                return true;
            }

            switch (currentStatus)
            {
                case "Pending":
                    return newStatus == "Completed" || newStatus == "Cancelled";
                case "Cancelled":
                    return newStatus == "Pending";
                default:
                    throw new UserException("Invalid status transition");
            }
        }

      
    }
}
