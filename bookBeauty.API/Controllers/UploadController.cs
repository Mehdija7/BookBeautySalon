using bookBeauty.Model.Requests;
using bookBeauty.Services;
using bookBeauty.Services.Database;
using MapsterMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Net.Http.Headers;

namespace bookBeauty.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UploadController : ControllerBase
    {
        private readonly IProductService _ProductService;
        private readonly IMapper Mapper;
        private readonly IServiceService _serviceService;
        public UploadController(IProductService ProductService,IServiceService serviceService, IMapper mapper) 
        {
            _ProductService = ProductService;
            Mapper = mapper;
            _serviceService = serviceService;
        }

        [AllowAnonymous]
        [HttpPost("/uploadproduct")]
        [DisableRequestSizeLimit]
        public async Task<IActionResult> UploadProduct([FromQuery] int productId)
        {
           
            try
            {
                var formCollection = await Request.ReadFormAsync();
                var file = formCollection.Files.First();
                var folderName = Path.Combine("Resources", "Images");
                var pathToSave = Path.Combine(Directory.GetCurrentDirectory(), folderName);

                if (file.Length > 0)
                {
                    var fileName = ContentDispositionHeaderValue.Parse(file.ContentDisposition).FileName.Trim('"');
                    var fullPath = Path.Combine(pathToSave, fileName);
                    var dbPath = Path.Combine(folderName, fileName);

                    using (var stream = new FileStream(fullPath, FileMode.Create))
                    {
                        file.CopyTo(stream);
                    }

                    var fullUrl = $"{Request.Scheme}://{Request.Host}/images/{fileName}";


                    var product = await _ProductService.GetById(productId);
                    if (product == null)
                    {
                        return NotFound($"Product with id {productId} not found.");
                    }

                    product.Image = fullUrl;
                    var editedProduct = Mapper.Map<ProductUpdateRequest>(product);
                    var en =  await _ProductService.Update(productId,editedProduct); 

                    return Ok(new { imageUrl = fullUrl });  
                }
                else
                {
                    return BadRequest("Invalid file.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex}");
            }
        }


        [AllowAnonymous]
        [HttpPost("/uploadservice")]
        [DisableRequestSizeLimit]
       
        public async Task<IActionResult> UploadService([FromQuery] int serviceId)
        {

            try
            {
                var formCollection = await Request.ReadFormAsync();
                var file = formCollection.Files.First();
                var folderName = Path.Combine("Resources", "Images");
                var pathToSave = Path.Combine(Directory.GetCurrentDirectory(), folderName);

                if (file.Length > 0)
                {
                    var fileName = ContentDispositionHeaderValue.Parse(file.ContentDisposition).FileName.Trim('"');
                    var fullPath = Path.Combine(pathToSave, fileName);
                    var dbPath = Path.Combine(folderName, fileName);

                    using (var stream = new FileStream(fullPath, FileMode.Create))
                    {
                        file.CopyTo(stream);
                    }

                    var fullUrl = $"{Request.Scheme}://{Request.Host}/images/{fileName}";


                    var service = await _serviceService.GetById(serviceId);
                    if (service == null)
                    {
                        return NotFound($"Service with id {serviceId} not found.");
                    }

                    service.Image = fullUrl;
                    var editedService = Mapper.Map<ServiceUpdateRequest>(service);
                    var en = await _serviceService.Update(serviceId, editedService);

                    return Ok(new { imageUrl = fullUrl });
                }
                else
                {
                    return BadRequest("Invalid file.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex}");
            }
        }

    }
}
