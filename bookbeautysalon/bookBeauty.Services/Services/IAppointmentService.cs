using bookBeauty.Model.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services.Services
{
    public interface IAppointmentService : ICRUDService<Appointment, AppointmentSearchObject, AppointmentInsertRequest, AppointmentUpdateRequest>
    {
        public List<TimeOnly> GetAvailableAppointments(AppointmentInsertRequest request);
        public List<AppointmentGetRequest> GetAppointmentsByUser(int userId);
    }
}
