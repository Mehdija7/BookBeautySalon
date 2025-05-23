﻿using bookBeauty.Model.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace bookBeauty.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProductController : BaseCRUDController<Product, ProductSearchObject, ProductInsertRequest, ProductUpdateRequest>
    {
        public ProductController(ILogger<BaseController<Product, ProductSearchObject>> logger, IProductService service) : base(logger,service)
        {
        }
        [Authorize(Roles ="Admin, Hairdresser")]
        [HttpPut("{id}/activate")]
        public async Task<Product> Activate(int id)
        {
            return await ((IProductService)_service).Activate(id);
        }

        [Authorize(Roles = "Admin,Hairdresser")]
        public override Task<Product> Insert([FromBody] ProductInsertRequest request)
        {

            return base.Insert(request);
        }

        [Authorize(Roles = "Admin,Hairdresser")]
        [HttpPut("{id}/hide")]
        public virtual async Task<Product> Hide(int id)
        {
            return await (_service as IProductService).Hide(id);
        }

        [Authorize(Roles = "Admin,Hairdresser")]
        [HttpPut("{id}/edit")]
        public virtual async Task<Product> Edit(int id)
        {
            return await (_service as IProductService).Edit(id);
        }



        [Authorize(Roles = "Admin,Hairdresser")]
        [HttpGet("{id}/allowedActions")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_service as IProductService).AllowedActions(id);
        }


        [Authorize]
        [HttpGet("{id}/recommend")]
        public List<Product> Recommend(int id)
        {
            return (_service as IProductService).Recommended(id);
        }

        [Authorize]
        public override Task<Product> Update(int id,[FromBody]ProductUpdateRequest request)
        {
            return  _service.Update(id, request);
        }
    }
}
