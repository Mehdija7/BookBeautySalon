using bookBeauty.Services.Database;
using Microsoft.EntityFrameworkCore;
using Mapster;
using Microsoft.Extensions.DependencyInjection.Extensions;
using bookBeauty.Services;
using bookBeauty.Services.ProductStateMachine;
using bookBeauty.API.Filters;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddTransient<IProductService, ProductService>();
builder.Services.AddTransient<IUserService, UserService>();
builder.Services.AddTransient<ICategoryService, CategoryService>();

builder.Services.AddTransient<BaseProductState>();
builder.Services.AddTransient<InitialProductState>();
builder.Services.AddTransient<DraftProductState>();
builder.Services.AddTransient<ActiveProductState>();
builder.Services.AddTransient<HiddenProductState>();

builder.Services.AddControllers(x=>
{
    x.Filters.Add<ExceptionFilter>();
});
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var connectionString = builder.Configuration.GetConnectionString("BookBeauty");
builder.Services.AddDbContext<_200101Context>(options => options.UseSqlServer(connectionString));


 builder.Services.AddMapster();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
