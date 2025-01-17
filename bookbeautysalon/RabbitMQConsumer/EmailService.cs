using MimeKit;
using MailKit.Net.Smtp;
using Microsoft.Extensions.Configuration;
using System.Net.Mail;



namespace RabbitMQConsumer
{
    public class EmailService(IConfiguration configuration)
    {
        private readonly IConfiguration _configuration = configuration;

        public void SendEmail(string recipientEmail, string message)
        {
            var emailConfig = _configuration.GetSection("Email");
            var emailMessage = new MimeMessage();


            var fromEmail = Environment.GetEnvironmentVariable("FromEmail");

            emailMessage.From.Add(new MailboxAddress("Informacija o narudzbi", fromEmail));
            emailMessage.To.Add(new MailboxAddress("Customer", recipientEmail));
            emailMessage.Subject = "Nova narudzba kreirana";
            emailMessage.Body = new TextPart("plain")
            {
                Text = message
            };

            using var client = new MailKit.Net.Smtp.SmtpClient();
            try
            {
                client.Connect(emailConfig["SmtpServer"], int.Parse(emailConfig["SmtpPort"]), false);

                var smtpPass = Environment.GetEnvironmentVariable("SMTP_PASSWORD");
                var smtpUser = Environment.GetEnvironmentVariable("SMTP_USERNAME");

                client.Authenticate(smtpUser, smtpPass);

                client.Send(emailMessage);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"An error occurred while sending email to {recipientEmail}: {ex.Message}");
            }
            finally
            {
                client.Disconnect(true);
                client.Dispose();
            }
        }
    }
}
