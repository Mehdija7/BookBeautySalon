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
            new Category { CategoryId = 1, Name = "Šampon" },
            new Category { CategoryId = 2, Name = "Ulje" },
            new Category { CategoryId = 3, Name = "Serum" },
            new Category { CategoryId = 4, Name = "Krema" },
            new Category { CategoryId = 5, Name = "Regenerator" },
            new Category { CategoryId = 6, Name = "Sprej" },
            new Category { CategoryId = 7, Name = "Maska" }
        );

        dataContext.Roles.AddRange(
            new Role { Name = "Admin", Description = "Administrator ima omoguæene sve funkcionalnosti. Jedna od glavnih jeste dodavanje/brisanje frizera." },
            new Role { Name = "Frizer", Description = "Frizer ima ulogu da manipulise narudzbama i terminima" },
            new Role { Name = "Kupac", Description = "Dostupne su mu funkcinonalnosti poput online kupovine i rezervacije termina" }

        );

        dataContext.Genders.AddRange(
          new Gender { GenderId = 1, Name = "Ženski" },
          new Gender { GenderId = 2, Name = "Muški" }
      );


        dataContext.Products.AddRange(new Product
        {
            Name = "Burdock Therapy šampon",
            CategoryId = 1,
            Description = "Eveline šampon za kosu èièak pogodan je za slabu, tanku i krhku kosu. Zahvaljujæi inovativnoj obnavljajuæoj formuli, temeljito èisti kosu i vlasište, sprijeèava ispadanje kose, potièe njen rast, umiruje iritacije, elimira perut, jaèa i obnavlja strukturu kose. Eveline šampon za kosu èièak hrani kosu i sadrži protuupalna svojstva.",
            StateMachine = "active",
            Price = 6.00f
        },
        new Product
        {
            Name = "Aqua Hyaluron maska",
            CategoryId = 7,
            Description = "Balea PROFESSIONAL Aqua Hyaluron 3u1 maska za kosu idealna je za suhu kosu. Uèinkovita formula za njegu sadrži hijaluronsku kiselinu i 40 % aloe vere. Ova maska pruža intenzivnu njegu bez otežavanja i olakšava rašèešljavanje. Pružite kosu potrebnu hidrataciju s Balea PROFESSIONAL Aqua Hyaluron 3u1 maskom.",
            StateMachine = "active",
            Price = 10.00f
        },
        new Product
        {
            Name = "Garnier maska",
            CategoryId = 7,
            Description = "Njega svježeg mirisa za vašu kosu! 3u1 maska za kosu s aloe verom intenzivno njeguje kosu, raspetljava je i èini je nevjerojatno podatnom. Pritom se ova kura može upotrijebiti kao regenerator, maska ili njega bez ispiranja. Bogata formula sastoji se od 98 posto prirodnih tvari i pogodna je za vegane.",
            StateMachine = "active",
            Price = 12.00f
        },
        new Product
        {
            Name = "Repair ulje",
            CategoryId = 2,
            Description = "Luxurious Coconut Repair ulje za kosu obnavlja jako suhu i ošteæenu kosu. Obnavlja je i ne masti. Obogaæeno je vitaminima A, B i E potièe rast i obnovu ošteæene kose. Štiti je od štetnih vanjskih utjecaja. Iznimno zaglaðuje površinu vlasi, a pomaže i kod ispucalih vrhova. Ne sadrži paraben, mineralna ulja i bojila.",
            StateMachine = "active",
            Price = 4.00f
        },
        new Product
        {
            Name = "Grow serum",
            CategoryId = 3,
            Description = "Zdrava i oèuvana kosa uz Fructis Grow Strong serum Blood Orange! Serum protiv ispadanja kose njeguje i spašava i do 1000 vlasi kose mjeseèno. Fructis Grow Strong Blood Orange serum umanjuje lomljenje kose i bit æe vaš najvjerniji partner u oèuvanju kose i njenoj njezi. Dokazano jaèa kosa zdravijeg izgleda!",
            StateMachine = "active",
            Price = 17.00f
        },
        new Product
        {
            Name = "Balea krema",
            CategoryId = 4,
            Description = "Balea Professional krema za korekciju boje sijede i izbijeljene kose. Posebnim èesticama reducira žute tonove u kosi. Posebna formula njeguje i jaèa strukturu vlasi i poboljšava kvalitetu kose. Za savršeni srebrnkasti sjaj kose.",
            StateMachine = "active",
            Price = 3.00f
        },
        new Product
        {
            Name = "La croa regenerator",
            CategoryId = 5,
            Description = "La Croa Hydrating regenerator s najmodernijom tehnologijom sadrži nježne sastojke, bez silikona. Obogaæen je organskim uljima kokosa, argana i sezama te organskom aloe verom i zelenim èajem. La Croa Hydrating regenerator njeguje kosu prirodnim hidratizirajuæim faktorima kao što su hijaluron i glicerin. Idealan je za svakodnevno korištenje.",
            StateMachine = "active",
            Price = 20.00f
        },
        new Product
        {
            Name = "Hibiskus sprej",
            CategoryId = 6,
            Description = "Balea natural beauty hidratantna njega u spreju s organskim ekstraktom hibiskusa i kokosovim mlijekom. Formula sadrži 97 % sastojaka prirodnog podrijetla i ne sadrži silikone. Hrani, njeguje i hidratizira suhu i lomljivu kosu, daje joj mekoæu i prirodan sjaj bez otežavanja. Za zdraviji izgled kose i prirodan sjaj od korijena do vrhova.",
            Price = 5.00f
        },
        new Product
        {
            Name = "Burdock Therapy šampon",
            CategoryId = 1,
            Description = "Masno vlasište i istovremeno suhi vrhovi? Nije problem za šampon iz linije Garnier Fructis koji jaèa kosu! Njegova nježna formula temeljito èisti masno vlasište, a vrhovima daje intenzivnu vlagu. Kokosova voda i vitamin B3 i B6 pružaju vašoj kosi dubinsku njegu i daju joj zdrav sjaj. Osim toga, šampon bez silikona daje kosi odreðenu lakoæu.",
            StateMachine = "active",
            Price = 7.00f
        },
        new Product
        {
            Name = "Silky serum",
            CategoryId = 3,
            Description = "Olival Silk On silikonski serum za kosu na kosi stvara vodootporni film, sprjeèava gubitak vlažnosti te kosu èini otpornijom na ošteæenja. Uz to, poboljšava izgled frizure, olakšava rašèešljavanje dok krhka i ošteæena kosa djeluje sjajno i lepršavo. Olival Silk On silikonski serum za kosu brzo se upija i ne masti kosu te je pH neutralan ",
            StateMachine = "active",
            Price = 13.00f
        },
         new Product
         {
             Name = "Mievelle šampon",
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
               ShortDescription = "Stiliziranje kose fenom za savršenu frizuru",
               LongDescription = "Feniranje ukljuèuje stiliziranje vaše kose fenom prema vašim željama. Možete birati izmeðu ravnog izgleda, valova ili voluminoznih stilova koji odgovaraju vašem izgledu i prigodi." ,
               Price = 15.00f,
               Duration = 30,
            },
       new Service
       {
           Name = "Pranje kose",
           ShortDescription = "Profesionalno pranje kose za osvježavanje.",
           LongDescription = "Ova usluga ukljuèuje temeljito pranje vaše kose s visokokvalitetnim šamponima i regeneratorima koji njeguju i štite kosu, ostavljajuæi je svježom i mirisnom.",
           Price = 10.00f,
           Duration = 15,
       },
        new Service
        {
            Name = "Šišanje",
            ShortDescription = "Profesionalno šišanje za vaš savršen izgled",
            LongDescription = "Naši struèni frizeri pružaju uslugu šišanja prilagoðenu vašim željama i obliku lica. Ukljuèuje konzultacije i završno stiliziranje.",
            Price = 20.00f,
            Duration = 45,
        },
        new Service
        {
            Name = "Farbanje",
            ShortDescription = "Promjena ili osvježavanje boje vaše kose.",
            LongDescription = "Usluga farbanja ukljuèuje korištenje visokokvalitetnih boja koje osiguravaju dugotrajnu boju, sjaj i njegu vaše kose. Moguæe su jednobojne boje, pramenovi ili tehnike poput balayage-a.",
            Price = 80.00f,
            Duration = 90,
        },
        new Service
        {
            Name = "Frizure",
            ShortDescription = "Kreiranje posebnih frizura za svaku prigodu.",
            LongDescription = "Bez obzira planirate li vjenèanje, maturalnu veèer ili bilo koju posebnu priliku, naši frizeri kreiraju personalizirane frizure koje savršeno odgovaraju vašem stilu i željama.",
            Price = 30.00f,
            Duration = 60,
        },
       new Service
       {
           Name = "Tretman",
           ShortDescription = "Intenzivna njega za zdravu i sjajnu kosu.",
           LongDescription = "Ovaj tretman ukljuèuje dubinsku hidrataciju i obnovu vaše kose pomoæu visokokvalitetnih proizvoda. Idealno za suhu, ošteæenu ili beživotnu kosu. Pomaže u vraæanju elastiènosti, sjaja i snage kosi",
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





