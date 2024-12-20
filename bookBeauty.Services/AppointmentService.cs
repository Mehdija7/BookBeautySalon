﻿using bookBeauty.Model;
using bookBeauty.Model.Requests;
using bookBeauty.Model.SearchObjects;
using bookBeauty.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.Data;
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
                filteredQuery = filteredQuery.Where(x => x.DateTime.Value.Day == search.Date.Day &&
                                                        x.DateTime.Value.Month == search.Date.Month &&
                                                        x.DateTime.Value.Year == search.Date.Year);
            }
            return filteredQuery;
        }

        public override Task<Model.Appointment> Insert(AppointmentInsertRequest insert)
        {
            if (insert.DateTime == null)
            {
                throw new ArgumentException("Datum ne smije biti null.");
            }
            Console.WriteLine("****************************************************");
            Console.WriteLine(insert.DateTime);

            return base.Insert(insert);
        }

        public List<TimeOnly> GetAvailableAppointments(AppointmentInsertRequest request)
        {
            DateTime currentDate = DateTime.Now.Date;
            Console.WriteLine("++++++++++++++++++++++++++++++");
            Console.WriteLine(request.DateTime);
            if (request.DateTime <= currentDate)
            {
                throw new ArgumentException("Ne možete zakazati termin za trenutni dan ili dane unazad.");
            }

            if (request.HairdresserId == null || request.ServiceId == null || request.UserId == null)
            {
                throw new UserException("Polja frizer, usluga i korisnik su obavezna.");
            }

  

            int workStart = 8*60; 
            int workEnd = 16*60;   

            List<TimeOnly> availableAppointments = new List<TimeOnly>();

            List<Database.Appointment> existingAppointments = GetAppointmentsForDate(request.DateTime,request.HairdresserId) ?? new List<Database.Appointment>();

            Database.Service service = Context.Services.FirstOrDefault(s => s.ServiceId == request.ServiceId);

            if (service == null)
            {
                throw new ArgumentException("Invalid Service ID.");
            }

            List<(int start, int? end)> bookedTimes = existingAppointments
                 .Where(a => a.DateTime.HasValue && a.Service != null)
                 .Select(a => (
                     start: a.DateTime.Value.Hour * 60 + a.DateTime.Value.Minute,
                     end: a.DateTime.Value.Hour * 60 + a.DateTime.Value.Minute + a.Service.Duration))
                 .ToList();

            int currentTime = workStart;

             while (currentTime + service.Duration <= workEnd)
             {
                bool isFree = existingAppointments.Any(a=> a.DateTime.Value.Hour*60 == currentTime);
                 if (!isFree)
                 {
                     availableAppointments.Add(TimeOnly.FromTimeSpan(TimeSpan.FromMinutes(currentTime)));
                 }

                currentTime += 60;
             }
            


            return availableAppointments;
        }

        private List<Database.Appointment> GetAppointmentsForDate(DateTime date, int hairdresserId)
        {
            return Context.Appointments
                .Where(a => a.DateTime.HasValue &&
                            a.DateTime.Value.Year == date.Year &&
                            a.DateTime.Value.Month == date.Month &&
                            a.DateTime.Value.Day == date.Day
                            && a.HairdresserId == hairdresserId)
                .ToList();
        }

        public List<Model.Requests.AppointmentGetRequest> GetAppointmentsByUser(int userId)
        {
            var list = Context.Appointments.Where(a => a.UserId == userId).Include(a => a.Service).
                OrderByDescending(a => a.DateTime).
                ToList();

            return Mapper.Map<List<Model.Requests.AppointmentGetRequest>>(list);
        }


    }
}
