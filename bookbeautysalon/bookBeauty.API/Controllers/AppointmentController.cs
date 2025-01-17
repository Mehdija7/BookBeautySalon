using bookBeauty.Model.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace bookBeauty.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AppointmentController : BaseCRUDController<Appointment, AppointmentSearchObject, AppointmentInsertRequest, AppointmentUpdateRequest>
    {
        public AppointmentController(ILogger<BaseController<Appointment, AppointmentSearchObject>> logger, IAppointmentService service) : base(logger, service)
        {

        }

        [AllowAnonymous]
        public override Task<Appointment> Insert(AppointmentInsertRequest request)
        {
            Console.WriteLine("-------------- REQUEST ------------------");
            Console.WriteLine(request.Note);
            Console.WriteLine(request.DateTime);
            Console.WriteLine(request.UserId);
            return base.Insert(request);
        }


        [AllowAnonymous]
        [HttpPost("availableAppointments")]
        public Task<List<TimeOnly>> GetAvailableAppointments([FromBody] AppointmentInsertRequest req)
        {
            return Task.FromResult(((IAppointmentService)_service).GetAvailableAppointments(req));
        }

        [AllowAnonymous]
        [HttpGet("getAppointmentsByUser")]
        public Task<List<Model.Requests.AppointmentGetRequest>> GetAppointmentsByUser(int userId)
        {
            return Task.FromResult(((IAppointmentService)_service).GetAppointmentsByUser(userId));
        }

    }
}
