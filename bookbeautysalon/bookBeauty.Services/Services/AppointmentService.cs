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

namespace bookBeauty.Services.Services
{
    public class AppointmentService : BaseCRUDService<Model.Model.Appointment, AppointmentSearchObject, Database.Appointment, AppointmentInsertRequest, AppointmentUpdateRequest>, IAppointmentService
    {
        public AppointmentService(_200101Context context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Database.Appointment> AddFilter(AppointmentSearchObject search, IQueryable<Database.Appointment> query)
        {
            var filteredQuery = base.AddFilter(search, query);

            if (search.Hairdresser != null)
            {
                filteredQuery = filteredQuery.Where(x => x.User != null && x.User.Username != null && x.User.Username.StartsWith(search.Hairdresser.ToString()));
            }
            if (search.Customer != null)
            {
                filteredQuery = filteredQuery.Where(x => x.User != null && x.User.Username != null && x.User.Username.StartsWith(search.Customer.ToString()));
            }
            filteredQuery = filteredQuery.Where(x =>  
                                         x.DateTime.Day == search.Date.Day &&
                                         x.DateTime.Month == search.Date.Month &&
                                         x.DateTime.Year == search.Date.Year);
            return filteredQuery;
        }

        public override Task<Model.Model.Appointment> Insert(AppointmentInsertRequest insert)
        {
            Console.WriteLine(" console from insert appoiintment service");
            Console.WriteLine(insert.UserId);
            Console.WriteLine(insert.HairdresserId);
            Console.WriteLine(insert.ServiceId);
            Console.WriteLine(insert.DateTime);
            Console.WriteLine(insert.Note);
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
            int workStart = 8 * 60;
            int workEnd = 16 * 60;

            List<TimeOnly> availableAppointments = [];

            List<Database.Appointment> existingAppointments = GetAppointmentsForDate(request.DateTime, request.HairdresserId) ?? new List<Database.Appointment>();

            Database.Service? service = Context.Services.FirstOrDefault(s => s.ServiceId == request.ServiceId) ?? throw new ArgumentException("Invalid Service ID.");
            List<(int start, int end)> bookedTimes = existingAppointments
             .Where(a =>  a.Service != null)
            .Select(a => (
             start: (a.DateTime.Hour * 60 + a.DateTime.Minute),
             end: (a.DateTime.Hour * 60 + a.DateTime.Minute + a.Service!.Duration)))
            .ToList();
            int currentTime = workStart;

            while (currentTime + service.Duration <= workEnd)
            {
                bool isFree = existingAppointments.Any(a => a.DateTime.Hour * 60 == currentTime);
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
            return [.. Context.Appointments
                .Where(a => 
                            a.DateTime.Year == date.Year &&
                            a.DateTime.Month == date.Month &&
                            a.DateTime.Day == date.Day
                            && a.HairdresserId == hairdresserId)];
        }

        public List<AppointmentGetRequest> GetAppointmentsByUser(int userId)
        {
            var list = Context.Appointments.Where(a => a.UserId == userId).Include(a => a.Service).
                OrderByDescending(a => a.DateTime).
                ToList();

            return Mapper.Map<List<AppointmentGetRequest>>(list);
        }

        public  List<Model.Model.Appointment> Get()
        {
            var list = Context.Appointments.Include(a => a.Service).
                OrderByDescending(a => a.DateTime).ToList();
            return Mapper.Map<List<Model.Model.Appointment>>(list);
        }
    }
}
