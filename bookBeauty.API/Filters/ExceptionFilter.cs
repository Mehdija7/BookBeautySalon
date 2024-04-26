using bookBeauty.Model;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace bookBeauty.API.Filters
{
    public class ExceptionFilter : ExceptionFilterAttribute
    {
        public override void OnException(ExceptionContext context)
        {
            if(context.Exception is UserException)
            {
                context.ModelState.AddModelError("userError",context.Exception.Message);
                context.HttpContext.Response.StatusCode = 400;
            }
            else
            {
                context.ModelState.AddModelError("Error", "Server side error, check logs");
                context.HttpContext.Response.StatusCode = 500;
            }

            var list = context.ModelState.Where(x => x.Value.Errors.Count() > 0)
                .ToDictionary(x => x.Key, y => y.Value.Errors.Select(z => z.ErrorMessage));

            context.Result = new JsonResult(new { errors = list });
        }

    }
}
