using bookBeauty.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;

namespace bookBeauty.Services
{
    public class RecommendResultService : BaseCRUDService<Model.RecommendResult, BaseSearchObject, Database.RecommendResult, RecommendResultUpsertRequest, RecommendResultUpsertRequest>, IRecommendResultService
    {
        static  MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer modeltr = null;

        public RecommendResultService(Database._200101Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public List<Model.Product> Recommend(int? id)
        {
            lock (isLocked)
            {
                if (mlContext == null)
                {
                    mlContext = new MLContext();

                    var tmpData = _context.Orders.Include("OrderItems").ToList();

                    var data = new List<RatingEntry>();

                    foreach (var x in tmpData)
                    {
                        if (x.OrderItems.Count > 1)
                        {
                            var distinctItemId = x.OrderItems.Select(y => y.ProductId).ToList();

                            distinctItemId.ForEach(y =>
                            {
                                var relatedItems = x.OrderItems.Where(z => z.ProductId != y).ToList();

                                foreach (var z in relatedItems)
                                {
                                    data.Add(new RatingEntry()
                                    {
                                        RatingId = (uint)y,
                                        CoRatingId = (uint)z.ProductId,
                                    });
                                }
                            });
                        }
                    }
                    var traindata = mlContext.Data.LoadFromEnumerable(data);
                    MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
                    options.MatrixColumnIndexColumnName = nameof(RatingEntry.RatingId);
                    options.MatrixRowIndexColumnName = nameof(RatingEntry.CoRatingId);
                    options.LabelColumnName = "Label";
                    options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
                    options.Alpha = 0.01;
                    options.Lambda = 0.025;
                    options.NumberOfIterations = 100;
                    options.C = 0.00001;

                    var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                    modeltr = est.Fit(traindata);
                }
            }

            var allItems = _context.Products.Where(x => x.ProductId != id);
            var predictionResult = new List<Tuple<Database.Product, float>>();

            foreach (var item in allItems)
            {
                var predictionEngine = mlContext.Model.CreatePredictionEngine<RatingEntry, Copurchase_prediction>(modeltr);
                var prediction = predictionEngine.Predict(new RatingEntry()
                {
                    RatingId = (uint)id,
                    CoRatingId = (uint)item.ProductId
                });

                predictionResult.Add(new Tuple<Database.Product, float>(item, prediction.Score));
            }
            var finalResult = predictionResult.OrderByDescending(x => x.Item2).Select(x => x.Item1).Take(3).ToList();

            if (finalResult != null)
                return Mapper.Map<List<Model.Product>>(finalResult);
            return null;
        }

        public class RatingEntry
        {
            [KeyType(count: 262111)]
            public uint RatingId { get; set; }
            [KeyType(count: 262111)]
            public uint CoRatingId { get; set; }
            public float Label { get; set; }

        }
        public class Copurchase_prediction
        {
            public float Score { get; set; }
        }

        public async Task<List<Model.RecommendResult>> TrainProductsModel()
        {
            var orderItems = _context.OrderItems.ToList();
            var products = _context.Products.ToList();

            if (products.Count > 4 && orderItems.Count() > 2)
            {
                List<Database.RecommendResult> recommendList = new List<Database.RecommendResult>();

                foreach (var product in products)
                {

                    var recommendedProducts = Recommend(product.ProductId);


                    var resultRecommend = new Database.RecommendResult()
                    {
                        ProductId = product.ProductId,
                        FirstProductId = recommendedProducts[0].ProductId,
                        SecondProductId = recommendedProducts[1].ProductId,
                        ThirdProductId = recommendedProducts[2].ProductId,
                    };
                    recommendList.Add(resultRecommend);
                }

                var list = _context.RecommendResults.ToList();
                var recordCount = list.Count();
                var productsCount = _context.Products.Count();
                if (recordCount != 0)
                {
                    if (recordCount > productsCount)
                    {
                        for (int i = 0; i < productsCount; i++)
                        {
                            list[i].ProductId = recommendList[i].ProductId;
                            list[i].FirstProductId = recommendList[i].FirstProductId;
                            list[i].SecondProductId = recommendList[i].SecondProductId;
                            list[i].ThirdProductId = recommendList[i].ThirdProductId;
                        }

                        for (int i = productsCount; i < recordCount; i++)
                        {
                            _context.RecommendResults.Remove(list[i]);
                        }
                    }
                    else
                    {
                        for (int i = 0; i < recordCount; i++)
                        {
                            list[i].ProductId = recommendList[i].ProductId;
                            list[i].FirstProductId = recommendList[i].FirstProductId;
                            list[i].SecondProductId = recommendList[i].SecondProductId;
                            list[i].ThirdProductId = recommendList[i].ThirdProductId;
                        }
                        var num = recommendList.Count() - recordCount;

                        if (num > 0)
                        {
                            for (int i = recommendList.Count() - num; i < recommendList.Count(); i++)
                            {
                                _context.RecommendResults.Add(recommendList[i]);
                            }
                        }
                    }
                }
                else
                {
                    _context.RecommendResults.AddRange(recommendList);
                }
                await _context.SaveChangesAsync();
                return Mapper.Map<List<Model.RecommendResult>>(recommendList);
            }
            else
            {
                throw new Exception("Not enough data to do recommmedation");
            }
        }

        public Task DeleteAllRecommendation()
        {
            return _context.RecommendResults.ExecuteDeleteAsync();
        }

    }
}
