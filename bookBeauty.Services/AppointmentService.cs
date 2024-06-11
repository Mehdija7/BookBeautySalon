using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bookBeauty.Services
{
    public class AppointmentService : BaseCRUDService<Model.Appointment, AppointmentSearchObject, Database.Appointment, AppointmentInsertRequest, AppointmentUpdateRequest>, IAppointmentService
    {
        public AppointmentService(_200101Context context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Database.Appointment> AddFilter(AppointmentSearchObject search, IQueryable<Database.Appointment> query)
        {
            var filteredQuery = base.AddFilter(search, query);

            if (search.Hairdresser != null)
            {
                filteredQuery = filteredQuery.Where(x => x.User.Username.StartsWith(search.Hairdresser.ToString()));
            }
            if (search.Customer != null)
            {
                filteredQuery = filteredQuery.Where(x => x.User.Username.StartsWith(search.Customer.ToString()));
            }
            if (search.Date != null)
            {
                filteredQuery = filteredQuery.Where(x => x.Date.Value.Day == search.Date.Day &&
                                                        x.Date.Value.Month == search.Date.Month &&
                                                        x.Date.Value.Year == search.Date.Year);
            }
            return filteredQuery;
        }

        public override Task<Model.Appointment> Insert(AppointmentInsertRequest insert)
        {
            if (insert.Date == null)
            {
                throw new ArgumentException("Datum ne smije biti null.");
            }

            if (insert.Date.Minute != 0)
            {
                throw new ArgumentException("Minute moraju biti 0.");
            }

            if (insert.Date.Hour < 8 || insert.Date.Hour > 20)
            {
                throw new ArgumentException("Sati moraju biti između 8 i 20.");
            }

            DateTime currentDate = DateTime.Now.Date;
            if (insert.Date <= currentDate)
            {
                throw new ArgumentException("Ne možete zakazati termin za trenutni dan ili dane unazad.");
            }

            return base.Insert(insert);
        }
    }
}
