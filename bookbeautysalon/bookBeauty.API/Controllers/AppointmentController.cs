using bookBeauty.Model.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Services;
using MapsterMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace bookBeauty.API.Controllers
{
    [ApiController]
    public class AppointmentController : BaseCRUDController<Appointment, AppointmentSearchObject, AppointmentInsertRequest, AppointmentUpdateRequest>
    {
        public AppointmentController(ILogger<BaseController<Appointment, AppointmentSearchObject>> logger, IAppointmentService service) : base(logger, service)
        {

        }

     

        [Authorize]
        [HttpPost("availableAppointments")]
        public Task<List<TimeOnly>> GetAvailableAppointments([FromBody] AppointmentInsertRequest req)
        {
            return Task.FromResult(((IAppointmentService)_service).GetAvailableAppointments(req));
        }

        [Authorize]
        [HttpGet("getAppointmentsByUser")]
        public Task<List<Model.Requests.AppointmentGetRequest>> GetAppointmentsByUser(int userId)
        {
            return Task.FromResult(((IAppointmentService)_service).GetAppointmentsByUser(userId));
        }

        [Authorize]
        public override Task<Model.Model.Appointment>Update(int id, AppointmentUpdateRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize]
        public override Task<IActionResult> Delete(int id)
        {
            return base.Delete(id);
        }

        [Authorize]
        [HttpGet("getAppointments")]
        public Task<List<Model.Model.Appointment>> Get()
        {
            return Task.FromResult(((IAppointmentService)_service).Get());
        }
    }
}
