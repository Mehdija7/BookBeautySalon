using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.ProductStateMachine;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using Microsoft.ML;
using bookBeauty.Model.Model;

namespace bookBeauty.Services.Services
{
    public class ProductService : BaseCRUDService<Product, ProductSearchObject, Database.Product, ProductInsertRequest, ProductUpdateRequest>, IProductService

    {
        ILogger<ProductService> _logger;
        public BaseProductState BaseProductState { get; set; }
        public ProductService(Database._200101Context context, IMapper mapper, BaseProductState baseProductState, ILogger<ProductService> logger) : base(context, mapper)
        {
            BaseProductState = baseProductState;
            _logger = logger;
        }

        public override IQueryable<Database.Product> AddFilter(ProductSearchObject search, IQueryable<Database.Product> query)
        {
            var filteredQuery = base.AddFilter(search, query);

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                filteredQuery = filteredQuery.Where(x => x.Name.Contains(search.FTS));
            }

            return filteredQuery;
        }
        public override async Task<Product> Insert(ProductInsertRequest request)
        {
            var state = BaseProductState.CreateState("initial");
            return await state.Insert(request);
        }
        public override async Task<Product> Update(int id, ProductUpdateRequest request)
        {
            var entity = await GetById(id);
            var state = BaseProductState.CreateState(entity.StateMachine);
            return await state.Update(id, request);

        }
        public async Task<Product> Activate(int id)
        {
            var entity = await GetById(id);
            var state = BaseProductState.CreateState(entity.StateMachine);
            return await state.Activate(id);
        }
        public async Task<Product> Edit(int id)
        {
            var entity = await GetById(id);
            var state = BaseProductState.CreateState(entity.StateMachine);
            return await state.Edit(id);
        }

        public async Task<Product> Hide(int id)
        {
            var entity = await GetById(id);
            var state = BaseProductState.CreateState(entity.StateMachine);
            return await state.Hide(id);
        }

        public async Task<List<string>> AllowedActions(int id)
        {
            _logger.LogInformation($"Allowed actions called for: {id}");

            if (id <= 0)
            {
                var state = BaseProductState.CreateState("initial");
                return await state.AllowedActions(null);
            }
            else
            {
                var entity = Context.Products.Find(id);
                var state = BaseProductState.CreateState(entity.StateMachine);
                return await state.AllowedActions(entity);
            }

        }


        static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer model = null;

        public List<Product> Recommended(int id)
        {
            lock (isLocked)
            {
                if (mlContext == null)
                {
                    mlContext = new MLContext();

                    var tmpData = _context.Orders.Include("OrderItems").ToList();

                    var data = new List<ProductEntry>();

                    int num = 0;
                    foreach (var x in tmpData)
                    {
                        if (x.OrderItems.Count > 1)
                        {
                            var distinctItemId = x.OrderItems.Select(y => y.ProductId).ToList();

                            distinctItemId.ForEach(y =>
                            {
                                var relatedItems = x.OrderItems.Where(z => z.ProductId != y);

                                foreach (var z in relatedItems)
                                {
                                    data.Add(new ProductEntry()
                                    {
                                        ProductID = (uint)y,
                                        CoPurchaseProductID = (uint)z.ProductId,
                                    });
                                }
                            });
                        }


                    }

                    if (data.Count == 0)
                    {
                        return null;
                    }
                    var trainData = mlContext.Data.LoadFromEnumerable(data);

                    MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
                    options.MatrixColumnIndexColumnName = nameof(ProductEntry.ProductID);
                    options.MatrixRowIndexColumnName = nameof(ProductEntry.CoPurchaseProductID);
                    options.LabelColumnName = nameof(ProductEntry.Label);
                    options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
                    options.Alpha = 0.01;
                    options.Lambda = 0.025;
                    options.NumberOfIterations = 100;
                    options.C = 0.00001;

                    var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                    model = est.Fit(trainData);
                }

                if (model == null)
                {
                    return null;
                }

                var products = _context.Products.Where(x => x.ProductId != id);

                var predictionResult = new List<Tuple<Database.Product, float>>();

                foreach (var product in products)
                {
                    var predictionengine = mlContext.Model.CreatePredictionEngine<ProductEntry, Copurchase_prediction>(model);
                    var prediction = predictionengine.Predict(
                    new ProductEntry()
                    {
                        ProductID = (uint)id,
                        CoPurchaseProductID = (uint)product.ProductId,
                    });

                    predictionResult.Add(new Tuple<Database.Product, float>(product, prediction.Score));
                }

                var finalResult = predictionResult.OrderByDescending(x => x.Item2).Select(x => x.Item1).Take(3).ToList();

                return Mapper.Map<List<Product>>(finalResult);
            }
        }

        public class Copurchase_prediction
        {
            public float Score { get; set; }
        }

        public class ProductEntry
        {
            [KeyType(count: 100)]
            public uint ProductID { get; set; }

            [KeyType(count: 100)]
            public uint CoPurchaseProductID { get; set; }

            public float Label { get; set; }
        }

    }
}
