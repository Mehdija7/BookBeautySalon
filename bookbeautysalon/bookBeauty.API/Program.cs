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

var builder = WebApplication.CreateBuilder(args);

// Configure Swagger with schema ID and basic authentication
builder.Services.AddSwaggerGen(options =>
{
    options.CustomSchemaIds(type => type.ToString());
    options.AddSecurityDefinition("basicAuth", new OpenApiSecurityScheme
    {
        Type = SecuritySchemeType.Http,
        Scheme = "basic",
        Description = "Basic Authentication"
    });
    options.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "basicAuth"
                }
            },
            new string[] { }
        }
    });
});

// Register application services
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
builder.Services.AddTransient<IGenderService, GenderService>();
builder.Services.AddTransient<INewsService, NewsService>();


// Register product state machine services
builder.Services.AddTransient<BaseProductState>();
builder.Services.AddTransient<InitialProductState>();
builder.Services.AddTransient<DraftProductState>();
builder.Services.AddTransient<ActiveProductState>();
builder.Services.AddTransient<HiddenProductState>();

// Add exception filter
builder.Services.AddControllers(options =>
{
    options.Filters.Add<ExceptionFilter>();
});

// Configure database connection
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<_200101Context>(options =>
    options.UseSqlServer(connectionString));

// Add Mapster for object mapping
builder.Services.AddMapster();

// Configure authentication
builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);

// Add RabbitMQ connection factory as a singleton service
var rabbitMqFactory = new ConnectionFactory
{
    HostName = builder.Configuration["RabbitMQ:HostName"]
};
builder.Services.AddSingleton(rabbitMqFactory);

// Add endpoints API explorer
builder.Services.AddEndpointsApiExplorer();

var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();




// SEEDING  


using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<_200101Context>();
    if (dataContext.Database.EnsureCreated())
    {
        dataContext.Database.Migrate();

        dataContext.Categories.AddRange(
            new Category { CategoryId = 1, Name = "�ampon" },
            new Category { CategoryId = 2, Name = "Ulje" },
            new Category { CategoryId = 3, Name = "Serum" },
            new Category { CategoryId = 4, Name = "Krema" },
            new Category { CategoryId = 5, Name = "Regenerator" },
            new Category { CategoryId = 6, Name = "Sprej" },
            new Category { CategoryId = 7, Name = "Maska" }
        );

        dataContext.Roles.AddRange(
            new Role { Name = "Admin", Description = "Administrator ima omogu�ene sve funkcionalnosti. Jedna od glavnih jeste dodavanje/brisanje frizera." },
            new Role { Name = "Frizer", Description = "Frizer ima ulogu da manipulise narudzbama i terminima" },
            new Role { Name = "Kupac", Description = "Dostupne su mu funkcinonalnosti poput online kupovine i rezervacije termina" }

        );

        dataContext.Genders.AddRange(
          new Gender { GenderId = 1, Name = "�enski" },
          new Gender { GenderId = 2, Name = "Mu�ki" }
      );


        dataContext.Products.AddRange(new Product
        {
            Name = "Burdock Therapy �ampon",
            CategoryId = 1,
            Description = "Eveline �ampon za kosu �i�ak pogodan je za slabu, tanku i krhku kosu. Zahvaljuj�i inovativnoj obnavljaju�oj formuli, temeljito �isti kosu i vlasi�te, sprije�ava ispadanje kose, poti�e njen rast, umiruje iritacije, elimira perut, ja�a i obnavlja strukturu kose. Eveline �ampon za kosu �i�ak hrani kosu i sadr�i protuupalna svojstva.",
            StateMachine = "active",
            Price = 6.00f
        },
        new Product
        {
            Name = "Aqua Hyaluron maska",
            CategoryId = 7,
            Description = "Balea PROFESSIONAL Aqua Hyaluron 3u1 maska za kosu idealna je za suhu kosu. U�inkovita formula za njegu sadr�i hijaluronsku kiselinu i 40 % aloe vere. Ova maska pru�a intenzivnu njegu bez ote�avanja i olak�ava ra��e�ljavanje. Pru�ite kosu potrebnu hidrataciju s Balea PROFESSIONAL Aqua Hyaluron 3u1 maskom.",
            StateMachine = "active",
            Price = 10.00f
        },
        new Product
        {
            Name = "Garnier maska",
            CategoryId = 7,
            Description = "Njega svje�eg mirisa za va�u kosu! 3u1 maska za kosu s aloe verom intenzivno njeguje kosu, raspetljava je i �ini je nevjerojatno podatnom. Pritom se ova kura mo�e upotrijebiti kao regenerator, maska ili njega bez ispiranja. Bogata formula sastoji se od 98 posto prirodnih tvari i pogodna je za vegane.",
            StateMachine = "active",
            Price = 12.00f
        },
        new Product
        {
            Name = "Repair ulje",
            CategoryId = 2,
            Description = "Luxurious Coconut Repair ulje za kosu obnavlja jako suhu i o�te�enu kosu. Obnavlja je i ne masti. Oboga�eno je vitaminima A, B i E poti�e rast i obnovu o�te�ene kose. �titi je od �tetnih vanjskih utjecaja. Iznimno zagla�uje povr�inu vlasi, a poma�e i kod ispucalih vrhova. Ne sadr�i paraben, mineralna ulja i bojila.",
            StateMachine = "active",
            Price = 4.00f
        },
        new Product
        {
            Name = "Grow serum",
            CategoryId = 3,
            Description = "Zdrava i o�uvana kosa uz Fructis Grow Strong serum Blood Orange! Serum protiv ispadanja kose njeguje i spa�ava i do 1000 vlasi kose mjese�no. Fructis Grow Strong Blood Orange serum umanjuje lomljenje kose i bit �e va� najvjerniji partner u o�uvanju kose i njenoj njezi. Dokazano ja�a kosa zdravijeg izgleda!",
            StateMachine = "active",
            Price = 17.00f
        },
        new Product
        {
            Name = "Balea krema",
            CategoryId = 4,
            Description = "Balea Professional krema za korekciju boje sijede i izbijeljene kose. Posebnim �esticama reducira �ute tonove u kosi. Posebna formula njeguje i ja�a strukturu vlasi i pobolj�ava kvalitetu kose. Za savr�eni srebrnkasti sjaj kose.",
            StateMachine = "active",
            Price = 3.00f
        },
        new Product
        {
            Name = "La croa regenerator",
            CategoryId = 5,
            Description = "La Croa Hydrating regenerator s najmodernijom tehnologijom sadr�i nje�ne sastojke, bez silikona. Oboga�en je organskim uljima kokosa, argana i sezama te organskom aloe verom i zelenim �ajem. La Croa Hydrating regenerator njeguje kosu prirodnim hidratiziraju�im faktorima kao �to su hijaluron i glicerin. Idealan je za svakodnevno kori�tenje.",
            StateMachine = "active",
            Price = 20.00f
        },
        new Product
        {
            Name = "Hibiskus sprej",
            CategoryId = 6,
            Description = "Balea natural beauty hidratantna njega u spreju s organskim ekstraktom hibiskusa i kokosovim mlijekom. Formula sadr�i 97 % sastojaka prirodnog podrijetla i ne sadr�i silikone. Hrani, njeguje i hidratizira suhu i lomljivu kosu, daje joj meko�u i prirodan sjaj bez ote�avanja. Za zdraviji izgled kose i prirodan sjaj od korijena do vrhova.",
            Price = 5.00f
        },
        new Product
        {
            Name = "Burdock Therapy �ampon",
            CategoryId = 1,
            Description = "Masno vlasi�te i istovremeno suhi vrhovi? Nije problem za �ampon iz linije Garnier Fructis koji ja�a kosu! Njegova nje�na formula temeljito �isti masno vlasi�te, a vrhovima daje intenzivnu vlagu. Kokosova voda i vitamin B3 i B6 pru�aju va�oj kosi dubinsku njegu i daju joj zdrav sjaj. Osim toga, �ampon bez silikona daje kosi odre�enu lako�u.",
            StateMachine = "active",
            Price = 7.00f
        },
        new Product
        {
            Name = "Silky serum",
            CategoryId = 3,
            Description = "Olival Silk On silikonski serum za kosu na kosi stvara vodootporni film, sprje�ava gubitak vla�nosti te kosu �ini otpornijom na o�te�enja. Uz to, pobolj�ava izgled frizure, olak�ava ra��e�ljavanje dok krhka i o�te�ena kosa djeluje sjajno i lepr�avo. Olival Silk On silikonski serum za kosu brzo se upija i ne masti kosu te je pH neutralan ",
            StateMachine = "active",
            Price = 13.00f
        },
         new Product
         {
             Name = "Mievelle �ampon",
             CategoryId = 1,
             Description = "Mievelle te je pH neutralan ",
             StateMachine = "active",
             Price = 17.00f
         }
    );

        dataContext.Services.AddRange(
            new Service
            {
               Name = "Feniranje",
               ShortDescription = "Stiliziranje kose fenom za savr�enu frizuru",
               LongDescription = "Feniranje uklju�uje stiliziranje va�e kose fenom prema va�im �eljama. Mo�ete birati izme�u ravnog izgleda, valova ili voluminoznih stilova koji odgovaraju va�em izgledu i prigodi." ,
               Price = 15.00f,
               Duration = 30,
            },
       new Service
       {
           Name = "Pranje kose",
           ShortDescription = "Profesionalno pranje kose za osvje�avanje.",
           LongDescription = "Ova usluga uklju�uje temeljito pranje va�e kose s visokokvalitetnim �amponima i regeneratorima koji njeguju i �tite kosu, ostavljaju�i je svje�om i mirisnom.",
           Price = 10.00f,
           Duration = 15,
       },
        new Service
        {
            Name = "�i�anje",
            ShortDescription = "Profesionalno �i�anje za va� savr�en izgled",
            LongDescription = "Na�i stru�ni frizeri pru�aju uslugu �i�anja prilago�enu va�im �eljama i obliku lica. Uklju�uje konzultacije i zavr�no stiliziranje.",
            Price = 20.00f,
            Duration = 45,
        },
        new Service
        {
            Name = "Farbanje",
            ShortDescription = "Promjena ili osvje�avanje boje va�e kose.",
            LongDescription = "Usluga farbanja uklju�uje kori�tenje visokokvalitetnih boja koje osiguravaju dugotrajnu boju, sjaj i njegu va�e kose. Mogu�e su jednobojne boje, pramenovi ili tehnike poput balayage-a.",
            Price = 80.00f,
            Duration = 90,
        },
        new Service
        {
            Name = "Frizure",
            ShortDescription = "Kreiranje posebnih frizura za svaku prigodu.",
            LongDescription = "Bez obzira planirate li vjen�anje, maturalnu ve�er ili bilo koju posebnu priliku, na�i frizeri kreiraju personalizirane frizure koje savr�eno odgovaraju va�em stilu i �eljama.",
            Price = 30.00f,
            Duration = 60,
        },
       new Service
       {
           Name = "Tretman",
           ShortDescription = "Intenzivna njega za zdravu i sjajnu kosu.",
           LongDescription = "Ovaj tretman uklju�uje dubinsku hidrataciju i obnovu va�e kose pomo�u visokokvalitetnih proizvoda. Idealno za suhu, o�te�enu ili be�ivotnu kosu. Poma�e u vra�anju elasti�nosti, sjaja i snage kosi",
           Duration = 40,
           Price = 50.00f
       }

    );

        string adminpass = "admin";
        string userpass = "korisnik";
        string hairpass = "frizer";

        string adminsalt = GenerateSalt();
        string adminhash = GenerateHash(adminsalt, adminpass);

        string usersalt = GenerateSalt();
        string userhash = GenerateHash(usersalt, userpass);

        string hairsalt = GenerateSalt();
        string hairhash = GenerateHash(hairsalt, hairpass);


        dataContext.Users.AddRange(
            new User
            {
                FirstName = "Admin",
                LastName = "Admin",
                Username = "admin",
                Email = "admin.admin@gmail.com",
                Phone = "061111111",
                PasswordHash = adminhash,
                PasswordSalt = adminsalt,
                Address = "ADMIN"
            },
               new User
               {
                   FirstName = "Frizer",
                   LastName = "Frizer",
                   Username = "frizer",
                   Email = "frizer@example.com",
                   Phone = "061111111",
                   PasswordHash = hairhash,
                   PasswordSalt = hairsalt,
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
            Email = "selma.mehmedovic@example.com",
            Phone = "061111111",
            PasswordHash = userhash,
            PasswordSalt = usersalt,
            Address = "Azize Sacirbegovica, Sarajevo"

        },
      
        new User
        {
            FirstName = "Korisnik",
            LastName = "Korisnik",
            Username = "korisnik",
            Email = "korisnikkorisnik227@gmail.com",
            Phone = "061111111",
            PasswordHash = userhash,
            PasswordSalt = usersalt,
            Address = "Branilaca, Sarajevo"
        },   
        new User
        {
            FirstName = "Zehra",
            LastName = "Sekic",
            Username = "zehrasekic",
            Email = "zehra.sekic@example.com",
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
             Email = "adna.burnic@example.com",
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

        dataContext.Appointments.AddRange(
            new Appointment
            {
                DateTime = new DateTime(year: 2024, month: 1, day: 16, hour: 10, minute: 0, second: 0),
                UserId = 5,
                HairdresserId = 2,
                ServiceId = 1,
                Note = "Ravno feniranje",
            },
             new Appointment
             {
                 DateTime = new DateTime(year: 2024, month: 1, day: 31, hour: 10, minute: 0, second: 0),
                 UserId = 5,
                 HairdresserId = 2,
                 ServiceId = 4,
                 Note = "Farabnje samo izrasta",
             },
            new Appointment
            {
              DateTime = new DateTime(year:2024,month: 1,day: 28,hour:9,minute:0,second:0),
              UserId = 5,
              HairdresserId = 2,
              ServiceId = 1,
              Note ="Ravno feniranje",
            },
         new Appointment
         {
             DateTime = new DateTime(year: 2024, month: 1, day: 31, hour: 11, minute: 0, second: 0),
             UserId = 6,
             HairdresserId = 3,
             ServiceId = 3,
             Note = "Samo ispucali vrhovi",
         },
          new Appointment
          {
              DateTime = new DateTime(year: 2024, month: 1, day: 30, hour: 14, minute: 0, second: 0),
              UserId = 7,
              HairdresserId = 4,
              ServiceId = 2,
              Note = "Alergija na SLS i paraben",
          },
            new Appointment
            {
                DateTime = new DateTime(year: 2024, month: 1, day: 29, hour: 8, minute: 0, second: 0),
                UserId = 8,
                HairdresserId = 3,
                ServiceId = 6,
                Note = "Tretman s Olaplex proizvodima",
            },
             new Appointment
             {
                 DateTime = new DateTime(year: 2024, month: 1, day: 29, hour: 14, minute: 0, second: 0),
                 UserId = 6,
                 HairdresserId = 2,
                 ServiceId = 5,
                 Note = "Svadbena frizura",
             },
                 new Appointment
                 {
                     DateTime = new DateTime(year: 2024, month: 1, day: 23, hour: 10, minute: 0, second: 0),
                     UserId = 7,
                     HairdresserId = 4,
                     ServiceId = 4,
                     Note = "Plavi pramenovi",
                 },
                   new Appointment
                   {
                       DateTime = new DateTime(year: 2024, month: 1, day: 24, hour: 12, minute: 0, second: 0),
                       UserId = 5,
                       HairdresserId = 4,
                       ServiceId = 5,
                       Note = "Krupne lokne",
                   },
                        new Appointment
                        {
                            DateTime = new DateTime(year: 2024, month: 1, day: 27, hour: 10, minute: 0, second: 0),
                            UserId = 5,
                            HairdresserId = 3,
                            ServiceId = 1,
                            Note = "Ravno feniranje",
                        },
                           new Appointment
                           {
                               DateTime = new DateTime(year: 2024, month: 1, day: 27, hour: 11, minute: 0, second: 0),
                               UserId = 6,
                               HairdresserId = 3,
                               ServiceId = 4,
                               Note = "Svijetlo-smedji balayage",
                           },
                             new Appointment
                             {
                                 DateTime = new DateTime(year: 2024, month: 1, day: 27, hour: 8, minute: 0, second: 0),
                                 UserId = 4,
                                 HairdresserId = 2,
                                 ServiceId = 4,
                                 Note = "Crveni balayage",
                             },
                               new Appointment
                               {
                                   DateTime = new DateTime(year: 2024, month: 1, day: 29, hour: 8, minute: 0, second: 0),
                                   UserId = 5,
                                   HairdresserId = 2,
                                   ServiceId = 6,
                                   Note = "Ukljuciti i kristale",
                               },
                                   new Appointment
                                   {
                                       DateTime = new DateTime(year: 2024, month: 1, day: 24, hour: 8, minute: 0, second: 0),
                                       UserId = 8,
                                       HairdresserId = 2,
                                       ServiceId = 6,
                                       Note = "Ukljuciti i kristale",
                                   }



    );

       
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

        dataContext.Orders.AddRange(
               new Order { OrderNumber = "#1",  DateTime = new DateTime(2024,1,15),CustomerId =5,Status = "Kreirana" ,TotalPrice=100 },
               new Order { OrderNumber = "#2",  DateTime = new DateTime(2024,1,15),CustomerId =6,Status = "Kreirana" ,TotalPrice=100 },
               new Order { OrderNumber = "#3",  DateTime = new DateTime(2024,1,15),CustomerId =7,Status = "Kreirana" ,TotalPrice=100 },
               new Order { OrderNumber = "#4",  DateTime = new DateTime(2024,1,14),CustomerId =8,Status = "Kreirana" ,TotalPrice=100 },
               new Order { OrderNumber = "#5",  DateTime = new DateTime(2024,1,14),CustomerId =5,Status = "Kreirana" ,TotalPrice=100 },
               new Order { OrderNumber = "#6",  DateTime = new DateTime(2024,1,14),CustomerId =6,Status = "Kreirana" ,TotalPrice=100 },
               new Order { OrderNumber = "#7",  DateTime = new DateTime(2024,1,14),CustomerId =7,Status = "Kreirana" ,TotalPrice=100 },
               new Order { OrderNumber = "#8",  DateTime=  new DateTime(2024,1,12),CustomerId =5,Status = "Isporucena" ,TotalPrice=100 },
               new Order { OrderNumber = "#9",  DateTime=  new DateTime(2024,1,11),CustomerId =6,Status = "Isporucena" ,TotalPrice=100 },
               new Order { OrderNumber = "#10", DateTime = new DateTime(2024,1,10),CustomerId =7,Status = "Dostavljena" ,TotalPrice=100 },
               new Order { OrderNumber = "#11", DateTime = new DateTime(2024,1,9) ,CustomerId =8,Status = "Dostavljena" ,TotalPrice=100 },
               new Order { OrderNumber = "#12", DateTime = new DateTime(2024,1,9) ,CustomerId =5,Status = "Dostavljena" ,TotalPrice=100 },
               new Order { OrderNumber = "#13", DateTime = new DateTime(2024,1,13),CustomerId =6,Status = "Isporucena" ,TotalPrice=100 },
               new Order { OrderNumber = "#14", DateTime = new DateTime(2024,1,13),CustomerId =7,Status = "Isporucena" ,TotalPrice=100 }
            );

        dataContext.SaveChanges();

        dataContext.OrderItems.AddRange(
            new OrderItem { Quantity = 3, OrderId = 1,   },
            new OrderItem { Quantity = 1, OrderId = 2,   },
            new OrderItem { Quantity = 4, OrderId = 3,   },
            new OrderItem { Quantity = 2, OrderId = 4,   },
            new OrderItem { Quantity = 5, OrderId = 15   },
            new OrderItem { Quantity = 2, OrderId = 16   },
            new OrderItem { Quantity = 3, OrderId = 7,   },
            new OrderItem { Quantity = 1, OrderId = 14,  },
            new OrderItem { Quantity = 4, OrderId = 9,   },
            new OrderItem { Quantity = 2, OrderId = 10,  },
            new OrderItem { Quantity = 1, OrderId = 11,  },
            new OrderItem { Quantity = 5, OrderId = 12,  },
            new OrderItem { Quantity = 3, OrderId = 3,   },
            new OrderItem { Quantity = 2, OrderId = 14,  },
            new OrderItem { Quantity = 4, OrderId = 15,  },
            new OrderItem { Quantity = 1, OrderId = 16,  },
            new OrderItem { Quantity = 3, OrderId = 17,  },
            new OrderItem { Quantity = 2, OrderId = 8,   },
            new OrderItem { Quantity = 5, OrderId = 19,  },
            new OrderItem { Quantity = 1, OrderId = 20,  },
            new OrderItem { Quantity = 4, OrderId = 1,  },
            new OrderItem { Quantity = 2, OrderId = 2,  },
            new OrderItem { Quantity = 5, OrderId = 3,  },
            new OrderItem { Quantity = 3, OrderId = 14  },
            new OrderItem { Quantity = 1, OrderId = 5,  },
            new OrderItem { Quantity = 2, OrderId = 6,  },
            new OrderItem { Quantity = 4, OrderId = 12,  },
            new OrderItem { Quantity = 3, OrderId = 8,  },
            new OrderItem { Quantity = 2, OrderId = 9,  },
            new OrderItem { Quantity = 5, OrderId = 1,  },
            new OrderItem { Quantity = 1, OrderId = 11,  },
            new OrderItem { Quantity = 4, OrderId = 12,  },
            new OrderItem { Quantity = 2, OrderId = 13,  },
            new OrderItem { Quantity = 3, OrderId = 14,  },
            new OrderItem { Quantity = 1, OrderId = 15,  },
            new OrderItem { Quantity = 4, OrderId = 16,  },
            new OrderItem { Quantity = 2, OrderId = 17,  },
            new OrderItem { Quantity = 5, OrderId = 14,  },
            new OrderItem { Quantity = 3, OrderId = 19,  },
            new OrderItem { Quantity = 1, OrderId = 20,  }
        );
        dataContext.SaveChanges();
    }
}


app.Run();



static string GenerateSalt()
{
    int saltSize = 16;

    byte[] saltBytes = new byte[saltSize];


#pragma warning disable SYSLIB0023 // Type or member is obsolete
    using (var rng = new RNGCryptoServiceProvider())
    {
      rng.GetBytes(saltBytes);
    }
#pragma warning restore SYSLIB0023 // Type or member is obsolete

    return Convert.ToBase64String(saltBytes);
}

static string GenerateHash(string salt, string password)
{
    string saltedPassword = salt + password;

    using (var sha256 = SHA256.Create())
    {
        byte[] saltedPasswordBytes = System.Text.Encoding.UTF8.GetBytes(saltedPassword);
        byte[] hashBytes = sha256.ComputeHash(saltedPasswordBytes);

        // Convert the hash byte array to a base64 string
        return Convert.ToBase64String(hashBytes);
    }
}





