using bookBeauty.Services.Database;
using Microsoft.EntityFrameworkCore;
using Mapster;
using Microsoft.Extensions.DependencyInjection.Extensions;
using bookBeauty.Services.ProductStateMachine;
using bookBeauty.API.Filters;
using Microsoft.AspNetCore.Authentication;
using bookBeauty.API;
using Microsoft.OpenApi.Models;
using Microsoft.Extensions.FileProviders;
using RabbitMQ.Client;
using System.Text.Json;
using bookBeauty.Model.Requests;
using System.Security.Cryptography;
using bookBeauty.Services.Services;
using System.Text;

var builder = WebApplication.CreateBuilder(args);




builder.Services.AddSwaggerGen(options =>
{
    options.CustomSchemaIds(type => type.ToString());
});


builder.Services.AddTransient<IProductService, ProductService>();
builder.Services.AddTransient<IUserService, UserService>();
builder.Services.AddTransient<ICategoryService, CategoryService>();
builder.Services.AddTransient<IReviewService, ReviewService>();
builder.Services.AddTransient<IOrderItemService, OrderItemService>();
builder.Services.AddTransient<IOrderService, OrderService>();
builder.Services.AddTransient<IFavoritesService, FavoritesService>();
builder.Services.AddTransient<ITransactionService, TransactionService>();
builder.Services.AddTransient<IServiceService, ServiceService>();
builder.Services.AddTransient<IAppointmentService, AppointmentService>();
builder.Services.AddTransient<INewsService, NewsService>();
builder.Services.AddTransient<ICommentProductService, CommentProductService>();
builder.Services.AddTransient<BaseProductState>();
builder.Services.AddTransient<InitialProductState>();
builder.Services.AddTransient<DraftProductState>();
builder.Services.AddTransient<ActiveProductState>();
builder.Services.AddTransient<HiddenProductState>();

builder.Services.AddControllers(options =>
{
    options.Filters.Add<ExceptionFilter>();
});

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(a =>
{
    a.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    a.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
        new OpenApiSecurityScheme
        {
            Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth" }
        },
        new string[]{}
        }
    });
}
);

builder.Configuration.AddEnvironmentVariables();

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<_200101Context>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddMapster();

builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);

var rabbitMqFactory = new ConnectionFactory
{
    HostName = builder.Configuration["RabbitMQ:HostName"]
};
builder.Services.AddSingleton(rabbitMqFactory);

builder.Services.AddEndpointsApiExplorer();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();

app.UseAuthorization();

app.MapControllers();


Console.WriteLine("SEEDING");


using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<_200101Context>();
    if (dataContext.Database.EnsureCreated())
    {
        dataContext.Database.Migrate();

        dataContext.Categories.AddRange(
            new Category { Name = "Shampoo" },
            new Category { Name = "Oil" },
            new Category { Name = "Serum" },
            new Category { Name = "Cream" },
            new Category { Name = "Conditioner" },
            new Category { Name = "Spray" },
            new Category { Name = "Mask" }
        );
        dataContext.SaveChanges();

        dataContext.Roles.AddRange(
            new Role { Name = "Admin", Description = "Full system access." },
            new Role { Name = "Hairdresser", Description = "Enabled functionalities like manipulation of orders and appointments" },
            new Role { Name = "Customer", Description = "Enabled functionalities like online order and reservation" }

        );
        dataContext.SaveChanges();

      


        dataContext.Products.AddRange(new Product
        {
            Name = "Burdock Therapy shampoo",
            CategoryId = 1,
            Description = "Eveline thistle hair shampoo is suitable for weak, thin and fragile hair. Thanks to the innovative renewing formula, it thoroughly cleans the hair and scalp, prevents hair loss, stimulates its growth, soothes irritations, eliminates dandruff, strengthens and restores the hair structure. Eveline hair shampoo burdock nourishes the hair and contains anti-inflammatory properties.",
            StateMachine = "active",
            Price = 6.00f
        },
        new Product
        {
            Name = "Aqua Hyaluron mask",
            CategoryId = 7,
            Description = "Balea PROFESSIONAL Aqua Hyaluron 3in1 hair mask is ideal for dry hair. Its effective formula contains hyaluronic acid and 40% aloe vera. This mask provides intense hair without weighing it down and makes combing easier. Give your hair the necessary hydration with the Balea PROFESSIONAL Aqua Hyaluron 3in1 mask.",
            StateMachine = "active",
            Price = 10.00f
        },
        new Product
        {
            Name = "Garnier mask",
            CategoryId = 7,
            Description = "Fresh smelling care for your hair! 3in1 hair mask with aloe vera intensively cares for hair, detangles it and makes it incredibly supple. At the same time, this cure can be used as a conditioner, mask or leave-in care. The rich formula consists of 98 percent natural substances and is suitable for vegans.",
            StateMachine = "active",
            Price = 12.00f
        },
        new Product
        {
            Name = "Repair oil",
            CategoryId = 2,
            Description = "Luxurious Coconut Repair hair oil restores very dry and damaged hair. It restores it and does not make it greasy. Enriched with vitamins A, B and E, it promotes the growth and renewal of damaged hair. It protects it from harmful external influences. It extremely smoothes the surface of the hair, and also helps with split ends. It does not contain parabens, mineral oils and dyes.",
            StateMachine = "active",
            Price = 4.00f
        },
        new Product
        {
            Name = "Grow serum",
            CategoryId = 3,
            Description = "Healthy and preserved hair with Fructis Grow Strong serum Blood Orange! Serum against hair loss nourishes and saves up to 1000 hairs per month. Fructis Grow Strong Blood Orange serum reduces hair breakage and will be your most faithful partner in hair preservation and care. Proven stronger, healthier-looking hair!",
            StateMachine = "active",
            Price = 17.00f
        },
        new Product
        {
            Name = "Balea cream",
            CategoryId = 4,
            Description = "Balea Professional cream for correcting the color of gray and bleached hair. With special particles, it reduces yellow tones in the hair. The special formula nourishes and strengthens the structure of the hair and improves the quality of the hair. For a perfect silvery hair shine.",
            StateMachine = "active",
            Price = 3.00f
        },
        new Product
        {
            Name = "La croa conditioner",
            CategoryId = 5,
            Description = "La Croa Hydrating conditioner with the most modern technology contains gentle ingredients, without silicone. It is enriched with organic coconut, argan and sesame oils, as well as organic aloe vera and green tea. La Croa Hydrating conditioner nourishes the hair with natural moisturizing factors such as hyaluronic and glycerin. It is ideal for everyday use.",
            StateMachine = "active",
            Price = 20.00f
        },
        new Product
        {
            Name = "Hibiscus spray",
            CategoryId = 6,
            Description = "Balea natural beauty moisturizing spray with organic hibiscus extract and coconut milk. The formula contains 97% ingredients of natural origin and does not contain silicones. Nourishes and hydrates dry and brittle hair, gives it softness and natural shine without weighing it down. For healthier looking hair and natural shine from root to hair ends.",
            Price = 5.00f,
            StateMachine = "active"
        },
        new Product
        {
            Name = "Burdock Therapy shampoo",
            CategoryId = 1,
            Description = "Oily scalp and dry ends at the same time? Not a problem for shampoo from the Garnier Fructis line that strengthens hair! Its gentle formula thoroughly cleans the oily scalp, and gives intense moisture to the ends. Coconut water and vitamin B3 and B6 provide your hair with deep care and give it a healthy shine. In addition, silicone-free shampoo gives the hair a certain lightness ",
            StateMachine = "active",
            Price = 7.00f
        },
        new Product
        {
          Name = "Silky Serum",
          CategoryId = 3,
          Description = "Olival Silk On silicone hair serum forms a waterproof film on the hair, prevents moisture loss, and makes the hair more resistant to damage. Additionally, it improves the appearance of the hairstyle, makes detangling easier, while fragile and damaged hair looks shiny and bouncy. Olival Silk On silicone hair serum absorbs quickly, doesn’t make the hair greasy, and is pH neutral.",
          StateMachine = "active",
          Price = 13.00f
        },
      new Product
      {
         Name = "Mievelle Shampoo",
        CategoryId = 1,
        Description = "Mievelle is pH neutral.",
        StateMachine = "active",
        Price = 17.00f
      }
    );
        dataContext.SaveChanges();

        dataContext.Services.AddRange(
          new Service
          {
              Name = "Blow-drying",
              ShortDescription = "Hair styling with a blow-dryer for a perfect look.",
              LongDescription = "Blow-drying includes styling your hair with a blow-dryer according to your preferences. You can choose between a sleek straight look, waves, or voluminous styles that suit your appearance and occasion.",
              Price = 15.00f,
              Duration = 30,
          },
new Service
{
    Name = "Hair Wash",
    ShortDescription = "Professional hair wash for a fresh feel.",
    LongDescription = "This service includes a thorough wash using high-quality shampoos and conditioners that nourish and protect the hair, leaving it fresh and fragrant.",
    Price = 10.00f,
    Duration = 15,
},
new Service
{
    Name = "Haircut",
    ShortDescription = "Professional haircut for your perfect look.",
    LongDescription = "Our skilled hairdressers provide haircuts tailored to your preferences and face shape. The service includes consultation and final styling.",
    Price = 20.00f,
    Duration = 45,
},
new Service
{
    Name = "Hair Coloring",
    ShortDescription = "Change or refresh your hair color.",
    LongDescription = "The coloring service includes the use of high-quality dyes that ensure long-lasting color, shine, and care for your hair. Options include single-color, highlights, or techniques like balayage.",
    Price = 80.00f,
    Duration = 90,
},
new Service
{
    Name = "Hairstyling",
    ShortDescription = "Creating special hairstyles for any occasion.",
    LongDescription = "Whether you're planning a wedding, prom night, or any special event, our stylists create personalized hairstyles that perfectly match your style and wishes.",
    Price = 30.00f,
    Duration = 60,
},
new Service
{
    Name = "Hair Treatment",
    ShortDescription = "Intensive care for healthy and shiny hair.",
    LongDescription = "This treatment includes deep hydration and hair restoration using high-quality products. Ideal for dry, damaged, or lifeless hair. Helps restore elasticity, shine, and strength.",
    Price = 50.00f,
    Duration = 40,
}

    );
        dataContext.SaveChanges();

        string adminpass = "admin";
        string userpass = "customer";
        string hairpass = "hairdresser";
        string pass = "test";

        string adminsalt = GenerateSalt();
        string adminhash = GenerateHash(adminsalt, adminpass);

        string usersalt = GenerateSalt();
        string userhash = GenerateHash(usersalt, userpass);

        string hairsalt = GenerateSalt();
        string hairhash = GenerateHash(hairsalt, hairpass);

        string passsalt = GenerateSalt();
        string passhash = GenerateHash(passsalt, pass);

        dataContext.Users.AddRange(
            new User
            {
             
                FirstName = "Admin",
                LastName = "Admin",
                Username = "admin",
                Email = "admin.admin@gmail.com",
                Phone = "061111111",
                PasswordHash = passhash,
                PasswordSalt = passsalt,
                Address = "ADMIN"
            },
               new User
               {   
                   FirstName = "Hairdresser",
                   LastName = "Hairdresser",
                   Username = "hairdresser",
                   Email = "hairdresser@example.com",
                   Phone = "061111111",
                   PasswordHash = passhash,
                   PasswordSalt = passsalt,
                   Address = "Zalik, Mostar"
               },
                 new User
                 {                   
                     FirstName = "Lejla",
                     LastName = "Kovacevic",
                     Username = "lejlakovacevic",
                     Email = "lejla.kovacevic@example.com",
                     Phone = "061111111",
                     PasswordHash = hairhash,
                     PasswordSalt = hairsalt,
                     Address = "Zelenih beretki, Sarajevo"
                 },
        new User
        {  
            FirstName = "Meliha",
            LastName = "Kazic",
            Username = "melihakazic",
            Email = "meliha.kazic@example.com",
            Phone = "061111111",
            PasswordHash = hairhash,
            PasswordSalt = hairsalt,
            Address = "Branilaca, Sarajevo"
        },
        new User
        { 
            FirstName = "Selma",
            LastName = "Mehmedovic",
            Username = "selmamehmedovic",
            Email = "mehdijabookbeauty@gmail.com",
            Phone = "061111111",
            PasswordHash = userhash,
            PasswordSalt = usersalt,
            Address = "Azize Sacirbegovica, Sarajevo"

        },
      
        new User
        {   
            FirstName = "Customer",
            LastName = "Customer",
            Username = "customer",
            Email = "mehdijabookbeauty@gmail.com",
            Phone = "061111111",
            PasswordHash = passhash,
            PasswordSalt = passsalt,
            Address = "Branilaca, Sarajevo"
        },   
        new User
        {
          
            FirstName = "Zehra",
            LastName = "Sekic",
            Username = "zehrasekic",
            Email = "mehdijabookbeauty@gmail.com",
            Phone = "061111111",
            PasswordHash = userhash,
            PasswordSalt = usersalt,
            Address = "Kijevo, Sanski Most"
        },
         new User
         { 
             FirstName = "Adna",
             LastName = "Burnic",
             Username = "adnaburnic",
             Email = "mehdijabookbeauty@gmail.com",
             Phone = "062222222",
             PasswordHash = userhash,
             PasswordSalt = usersalt,
             Address = "Kijevo, Sanski Most"
         }

    );
        dataContext.SaveChanges();
        dataContext.UserRoles.AddRange(
            new UserRole
            {
                UserId = 1,
                RoleId = 1,
            },
        new UserRole
        {
            UserId = 2,
            RoleId = 2,
        },
        new UserRole
        {
            UserId = 3,
            RoleId = 2,
        },
        new UserRole
        {
            UserId = 4,
            RoleId = 2,
        },
        new UserRole
        {
            UserId = 5,
            RoleId = 3,
        },
        new UserRole
        {
            UserId = 6,
            RoleId = 3,
        },
        new UserRole
        {
            UserId = 7,
            RoleId = 3,
        },
        new UserRole
        {
            UserId = 8,
            RoleId = 3,
        }

    );
        dataContext.SaveChanges();



        dataContext.CommentProduct.AddRange(
            new CommentProduct
            {
                CommentDate = DateTime.Now,
                CommentText = "Product is great",
                UserId = 6,
                ProductId =2
            },
            new CommentProduct
            {
                CommentDate = DateTime.Now,
                CommentText = "Hair smells so nice",
                UserId = 6,
                ProductId = 4
            },
            new CommentProduct
            {
                CommentDate = DateTime.Now,
                CommentText = "Good",
                UserId = 6,
                ProductId = 1
            },
            new CommentProduct
            {
                CommentDate = DateTime.Now,
                CommentText = "Not bad",
                UserId = 5,
                ProductId = 5
            },
            new CommentProduct
            {
                CommentDate = DateTime.Now,
                CommentText = "I dont like it",
                UserId = 7,
                ProductId = 3
            },
             new CommentProduct
             {
                 CommentDate = DateTime.Now,
                 CommentText = "I dont like it",
                 UserId = 7,
                 ProductId = 2
             },
             new CommentProduct
             {
                 CommentDate = DateTime.Now,
                 CommentText = "Nice",
                 UserId = 7,
                 ProductId = 4
             },
              new CommentProduct
              {
                  CommentDate = DateTime.Now,
                  CommentText = "Nice",
                  UserId = 7,
                  ProductId = 6
              },
               new CommentProduct
               {
                   CommentDate = DateTime.Now,
                   CommentText = "Like it",
                   UserId = 5,
                   ProductId = 6
               },
                new CommentProduct
                {
                    CommentDate = DateTime.Now,
                    CommentText = "Super",
                    UserId = 7,
                    ProductId = 7
                },
                 new CommentProduct
                 {
                     CommentDate = DateTime.Now,
                     CommentText = "Great",
                     UserId = 5,
                     ProductId = 8
                 },
                  new CommentProduct
                  {
                      CommentDate = DateTime.Now,
                      CommentText = "Good",
                      UserId = 4,
                      ProductId = 8
                  }
            );

        dataContext.SaveChanges();


        
        dataContext.News.AddRange(
      new News
      {
          Title = "Vitamins for Healthy Hair",
          Text = "Vitamins are essential for hair health. Some of the most important types include biotin, vitamin E, vitamin A, and vitamin D. These vitamins help strengthen the hair, prevent hair loss, and improve its overall health.",
          HairdresserId = 2,
          DateTime = DateTime.Now
      },
new News
{
    Title = "Popular Hairstyles This Month",
    Text = "This month, short hairstyles and wavy bangs are popular. If you're looking for something more modern, a bob haircut with volume on top is trending. Also, natural hair textures are in style.",
    HairdresserId = 3,
    DateTime = new DateTime(year: 2025, month: 2, day: 8, hour: 10, minute: 0, second: 0)
}
         );


        dataContext.SaveChanges();



        dataContext.Appointments.AddRange(
            new Appointment
            {
                DateTime = new DateTime(year: 2025, month: 5, day: 19, hour: 10, minute: 0, second: 0),
                UserId = 5,
                HairdresserId = 2,
                ServiceId = 1,
                Note = "Straight blow-draying",
            },
             new Appointment
             {
                 DateTime = new DateTime(year: 2025, month: 5, day: 19, hour: 12, minute: 0, second: 0),
                 UserId = 6,
                 HairdresserId = 2,
                 ServiceId = 4,
                 Note = "Just hair root",
             },
            new Appointment
            {
              DateTime = new DateTime(year:2025,month: 5,day: 20,hour:9,minute:0,second:0),
              UserId = 5,
              HairdresserId = 3,
              ServiceId = 1,
              Note = "Straight blow-draying",
            },
         new Appointment
         {
             DateTime = new DateTime(year: 2025, month: 5, day: 20, hour: 11, minute: 0, second: 0),
             UserId = 6,
             HairdresserId = 3,
             ServiceId = 3,
             Note = "Just split ends",
         },
          new Appointment
          {
              DateTime = new DateTime(year: 2025, month: 5, day: 20, hour: 14, minute: 0, second: 0),
              UserId = 7,
              HairdresserId = 4,
              ServiceId = 2,
              Note = "I have alergy on SLS and paraben",
          },
            new Appointment
            {
                DateTime = new DateTime(year: 2025, month: 5, day: 21, hour: 8, minute: 0, second: 0),
                UserId = 8,
                HairdresserId = 3,
                ServiceId = 6,
                Note = "Treatment with Olaplex products",
            },
             new Appointment
             {
                 DateTime = new DateTime(year: 2025, month: 5, day: 21, hour: 9, minute: 0, second: 0),
                 UserId = 6,
                 HairdresserId = 2,
                 ServiceId = 5,
                 Note = "Weeding hairstyle",
             },
                 new Appointment
                 {
                     DateTime = new DateTime(year: 2025, month: 5, day: 21, hour: 15, minute: 0, second: 0),
                     UserId = 7,
                     HairdresserId = 4,
                     ServiceId = 4,
                     Note = "Blonde highlights",
                 },
                   new Appointment
                   {
                       DateTime = new DateTime(year: 2025, month: 5, day: 22, hour: 12, minute: 0, second: 0),
                       UserId = 5,
                       HairdresserId = 4,
                       ServiceId = 5,
                       Note = "Big curls",
                   },
                        new Appointment
                        {
                            DateTime = new DateTime(year: 2025, month: 5, day: 22, hour: 10, minute: 0, second: 0),
                            UserId = 5,
                            HairdresserId = 3,
                            ServiceId = 1,
                            Note = "Curly blow-drying",
                        },
                           new Appointment
                           {
                               DateTime = new DateTime(year: 2025, month: 5, day: 22, hour: 13, minute: 0, second: 0),
                               UserId = 6,
                               HairdresserId = 3,
                               ServiceId = 4,
                               Note = "Light-brown balayage",
                           },
                             new Appointment
                             {
                                 DateTime = new DateTime(year: 2025, month: 5, day: 23, hour: 8, minute: 0, second: 0),
                                 UserId = 4,
                                 HairdresserId = 2,
                                 ServiceId = 4,
                                 Note = "Red balayage",
                             },
                               new Appointment
                               {
                                   DateTime = new DateTime(year: 2025, month: 5, day: 23, hour: 9, minute: 0, second: 0),
                                   UserId = 5,
                                   HairdresserId = 2,
                                   ServiceId = 6,
                                   Note = "Include crystals to treatment",
                               },
                                   new Appointment
                                   {
                                       DateTime = new DateTime(year: 2025, month: 5, day: 23, hour: 11, minute: 0, second: 0),
                                       UserId = 8,
                                       HairdresserId = 2,
                                       ServiceId = 6,
                                       Note = "Include crystals to treatment",
                                   },




                                     new Appointment
                                     {
                                         DateTime = new DateTime(year: 2025, month: 5, day: 26, hour: 10, minute: 0, second: 0),
                                         UserId = 5,
                                         HairdresserId = 2,
                                         ServiceId = 1,
                                         Note = "Straight blow-draying",
                                     },
             new Appointment
             {
                 DateTime = new DateTime(year: 2025, month: 5, day: 26, hour: 12, minute: 0, second: 0),
                 UserId = 6,
                 HairdresserId = 2,
                 ServiceId = 4,
                 Note = "Just hair root",
             },
            new Appointment
            {
                DateTime = new DateTime(year: 2025, month: 5, day: 27, hour: 9, minute: 0, second: 0),
                UserId = 5,
                HairdresserId = 3,
                ServiceId = 1,
                Note = "Straight blow-draying",
            },
         new Appointment
         {
             DateTime = new DateTime(year: 2025, month: 5, day: 27, hour: 11, minute: 0, second: 0),
             UserId = 6,
             HairdresserId = 3,
             ServiceId = 3,
             Note = "Just split ends",
         },
          new Appointment
          {
              DateTime = new DateTime(year: 2025, month: 5, day: 27, hour: 14, minute: 0, second: 0),
              UserId = 7,
              HairdresserId = 4,
              ServiceId = 2,
              Note = "I have alergy on SLS and paraben",
          },
            new Appointment
            {
                DateTime = new DateTime(year: 2025, month: 5, day: 28, hour: 8, minute: 0, second: 0),
                UserId = 8,
                HairdresserId = 3,
                ServiceId = 6,
                Note = "Treatment with Olaplex products",
            },
             new Appointment
             {
                 DateTime = new DateTime(year: 2025, month: 5, day: 29, hour: 9, minute: 0, second: 0),
                 UserId = 6,
                 HairdresserId = 2,
                 ServiceId = 5,
                 Note = "Weeding hairstyle",
             },


               new Appointment
               {
                   DateTime = new DateTime(year: 2025, month: 5, day: 29, hour: 12, minute: 0, second: 0),
                   UserId = 5,
                   HairdresserId = 4,
                   ServiceId = 5,
                   Note = "Big curls",
               },
                        new Appointment
                        {
                            DateTime = new DateTime(year: 2025, month: 6, day: 2, hour: 10, minute: 0, second: 0),
                            UserId = 5,
                            HairdresserId = 3,
                            ServiceId = 1,
                            Note = "Curly blow-drying",
                        },
                           new Appointment
                           {
                               DateTime = new DateTime(year: 2025, month: 6, day: 2, hour: 13, minute: 0, second: 0),
                               UserId = 6,
                               HairdresserId = 3,
                               ServiceId = 4,
                               Note = "Light-brown balayage",
                           },
                             new Appointment
                             {
                                 DateTime = new DateTime(year: 2025, month: 6, day: 3, hour: 8, minute: 0, second: 0),
                                 UserId = 4,
                                 HairdresserId = 2,
                                 ServiceId = 4,
                                 Note = "Red balayage",
                             },
                               new Appointment
                               {
                                   DateTime = new DateTime(year: 2025, month: 6, day: 3, hour: 9, minute: 0, second: 0),
                                   UserId = 5,
                                   HairdresserId = 2,
                                   ServiceId = 6,
                                   Note = "Include crystals to treatment",
                               },
                                   new Appointment
                                   {
                                       DateTime = new DateTime(year: 2025, month: 6, day: 3, hour: 11, minute: 0, second: 0),
                                       UserId = 8,
                                       HairdresserId = 2,
                                       ServiceId = 6,
                                       Note = "Include crystals to treatment",
                                   },


                                    new Appointment
                                    {
                                        DateTime = new DateTime(year: 2025, month: 6, day: 4, hour: 9, minute: 0, second: 0),
                                        UserId = 5,
                                        HairdresserId = 3,
                                        ServiceId = 1,
                                        Note = "Straight blow-draying",
                                    },
         new Appointment
         {
             DateTime = new DateTime(year: 2025, month: 6, day: 4, hour: 11, minute: 0, second: 0),
             UserId = 6,
             HairdresserId = 3,
             ServiceId = 3,
             Note = "Just split ends",
         },
          new Appointment
          {
              DateTime = new DateTime(year: 2025, month: 6, day: 5, hour: 14, minute: 0, second: 0),
              UserId = 7,
              HairdresserId = 4,
              ServiceId = 2,
              Note = "I have alergy on SLS and paraben",
          },


            new Appointment
            {
                DateTime = new DateTime(year: 2025, month: 6, day: 6, hour: 8, minute: 0, second: 0),
                UserId = 4,
                HairdresserId = 2,
                ServiceId = 4,
                Note = "Red balayage",
            },
                               new Appointment
                               {
                                   DateTime = new DateTime(year: 2025, month: 6, day: 6, hour: 9, minute: 0, second: 0),
                                   UserId = 5,
                                   HairdresserId = 2,
                                   ServiceId = 6,
                                   Note = "Include crystals to treatment",
                               }




    );

        dataContext.SaveChanges();

        dataContext.Reviews.AddRange(

            new Review {Mark = 5, UserId= 5, ProductId = 1 },
            new Review {Mark = 4, UserId= 5, ProductId = 2 },
            new Review {Mark = 3, UserId= 5, ProductId = 3 },
            new Review {Mark = 5, UserId= 8, ProductId = 4 },
            new Review {Mark = 2, UserId= 5, ProductId = 5 },
            new Review { Mark = 4, UserId = 8, ProductId = 6 },
            new Review { Mark = 3, UserId = 8, ProductId = 8 },
            new Review {Mark = 5, UserId= 6, ProductId = 6 },
            new Review {Mark = 4, UserId= 6, ProductId = 7 },
            new Review {Mark = 3, UserId= 6, ProductId = 8 },
            new Review {Mark = 2, UserId= 6, ProductId = 9 },
            new Review { Mark = 4, UserId = 6, ProductId = 10 },
            new Review { Mark = 4, UserId = 6, ProductId = 11 },
            new Review {Mark = 5, UserId= 7, ProductId = 10 },
            new Review {Mark = 4, UserId= 7, ProductId = 11 },
            new Review {Mark = 3, UserId= 7, ProductId = 2 },
            new Review {Mark = 2, UserId= 7, ProductId = 1 },
            new Review {Mark = 5, UserId= 7, ProductId = 4 },
            new Review {Mark = 2, UserId= 8, ProductId = 5 },
            new Review {Mark = 3, UserId = 8,ProductId = 3 }
         

        );
        dataContext.SaveChanges();

        dataContext.Orders.AddRange(
               new Order { OrderNumber = "#1",  DateTime = new DateTime(2024,1,15),CustomerId =5,Status = "Created" ,TotalPrice=100 },
               new Order { OrderNumber = "#2",  DateTime = new DateTime(2024,1,15),CustomerId =6,Status = "Created" ,TotalPrice=100 },
               new Order { OrderNumber = "#3",  DateTime = new DateTime(2024,1,15),CustomerId =7,Status = "Created" ,TotalPrice=100 },
               new Order { OrderNumber = "#4",  DateTime = new DateTime(2024,1,14),CustomerId =8,Status = "Created" ,TotalPrice=100 },
               new Order { OrderNumber = "#5",  DateTime = new DateTime(2024,1,14),CustomerId =5,Status = "Created" ,TotalPrice=100 },
               new Order { OrderNumber = "#6",  DateTime = new DateTime(2024,1,14),CustomerId =6,Status = "Created" ,TotalPrice=100 },
               new Order { OrderNumber = "#7",  DateTime = new DateTime(2024,12,14),CustomerId =7,Status = "Created" ,TotalPrice=100 },
               new Order { OrderNumber = "#8",  DateTime=  new DateTime(2025,4,12),CustomerId =5,Status = "Sent" ,TotalPrice=100 },
               new Order { OrderNumber = "#9",  DateTime=  new DateTime(2025,4,11),CustomerId =6,Status = "Sent" ,TotalPrice=100 },
               new Order { OrderNumber = "#11", DateTime = new DateTime(2025,5,9) ,CustomerId =8,Status = "Delivered" ,TotalPrice=100 },
               new Order { OrderNumber = "#10", DateTime = new DateTime(2025,5,10),CustomerId =7,Status = "Delivered" ,TotalPrice=100 },
               new Order { OrderNumber = "#12", DateTime = new DateTime(2025,5,9) ,CustomerId =5,Status = "Delivered" ,TotalPrice=100 },
               new Order { OrderNumber = "#13", DateTime = new DateTime(2025,5,13),CustomerId =6,Status = "Sent" ,TotalPrice=100 },
               new Order { OrderNumber = "#14", DateTime = new DateTime(2025,5,13),CustomerId =7,Status = "Sent" ,TotalPrice=100 }
            );

        dataContext.SaveChanges();

        dataContext.OrderItems.AddRange(
            new OrderItem { Quantity = 3, OrderId = 1, ProductId = 1  },
            new OrderItem { Quantity = 1, OrderId = 2, ProductId = 2  },
            new OrderItem { Quantity = 4, OrderId = 3, ProductId = 3  },
            new OrderItem { Quantity = 2, OrderId = 4, ProductId = 4  },
            new OrderItem { Quantity = 3, OrderId = 7, ProductId = 7  },
            new OrderItem { Quantity = 1, OrderId = 14,ProductId = 8  },
            new OrderItem { Quantity = 4, OrderId = 9, ProductId = 10  },
            new OrderItem { Quantity = 2, OrderId = 10,ProductId = 9  },
            new OrderItem { Quantity = 1, OrderId = 11,ProductId = 2  },
            new OrderItem { Quantity = 5, OrderId = 12,ProductId = 1  },
            new OrderItem { Quantity = 3, OrderId = 3, ProductId = 8  },
            new OrderItem { Quantity = 2, OrderId = 14,ProductId = 1  },
            new OrderItem { Quantity = 2, OrderId = 8, ProductId = 10  },
            new OrderItem { Quantity = 4, OrderId = 1, ProductId = 5 },
            new OrderItem { Quantity = 2, OrderId = 2, ProductId = 1 },
            new OrderItem { Quantity = 5, OrderId = 3, ProductId = 1 },
            new OrderItem { Quantity = 3, OrderId = 14,ProductId = 4 },
            new OrderItem { Quantity = 1, OrderId = 5, ProductId = 1 },
            new OrderItem { Quantity = 2, OrderId = 6, ProductId = 1 },
            new OrderItem { Quantity = 4, OrderId = 12,ProductId = 5  },
            new OrderItem { Quantity = 3, OrderId = 8, ProductId = 9 },
            new OrderItem { Quantity = 2, OrderId = 9, ProductId = 1 },
            new OrderItem { Quantity = 5, OrderId = 1, ProductId = 6 },
            new OrderItem { Quantity = 1, OrderId = 11,ProductId = 7  },
            new OrderItem { Quantity = 4, OrderId = 12,ProductId = 11  },
            new OrderItem { Quantity = 2, OrderId = 13,ProductId = 1  },
            new OrderItem { Quantity = 3, OrderId = 14,ProductId = 2  },
            new OrderItem { Quantity = 1, OrderId = 4,ProductId = 9  },
            new OrderItem { Quantity = 4, OrderId = 3,ProductId = 10  },
            new OrderItem { Quantity = 2, OrderId = 2,ProductId = 3  },
            new OrderItem { Quantity = 5, OrderId = 14,ProductId = 5  }
        );
        dataContext.SaveChanges();
    }
}

app.Use(async (context, next) =>
{
    context.Response.Headers.Append("Content-Type", "application/json;");
    await next();
});

app.Run();



 static string GenerateSalt()
{
    var byteArray = RandomNumberGenerator.GetBytes(16);

    return Convert.ToBase64String(byteArray);
}

 static string GenerateHash(string salt, string password)
{
    byte[] src = Convert.FromBase64String(salt);
    byte[] bytes = Encoding.Unicode.GetBytes(password);
    byte[] dst = new byte[src.Length + bytes.Length];

    Buffer.BlockCopy(src, 0, dst, 0, src.Length);
    Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

    HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
    byte[] inArray = algorithm.ComputeHash(dst);
    return Convert.ToBase64String(inArray);
}





