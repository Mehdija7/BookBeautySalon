using MimeKit;
using MailKit.Net.Smtp;
using Microsoft.Extensions.Configuration;



namespace RabbitMQConsumer
{
    public class EmailService
    {
        private readonly IConfiguration _configuration;

        public EmailService(IConfiguration configuration)
        {
            _configuration = configuration;
        }
        public void SendEmail(string recipientEmail, string message)
        {

            Console.WriteLine("------ RECIPENT EMAIL ----");
            Console.WriteLine(recipientEmail);
            var emailConfig = _configuration.GetSection("Email");
            var emailMessage = new MimeMessage();
           

            var fromEmail = Environment.GetEnvironmentVariable("FromEmail");
            Console.WriteLine("------ FROM EMAIL ----");
            Console.WriteLine(fromEmail);

            Console.WriteLine("   message   ");
            Console.WriteLine(message);
            if (string.IsNullOrEmpty(message))
            {
                Console.WriteLine("Message content is null or empty.");
                return;
            }
           
            emailMessage.From.Add(new MailboxAddress("Book Beauty Salon", fromEmail));
            emailMessage.To.Add(new MailboxAddress("Customer", recipientEmail));
            emailMessage.Subject = "Nova narudzba kreirana";
            emailMessage.Body = new TextPart("plain")
            {
                Text = message
            };
            Console.WriteLine("***** email message ****");
            Console.WriteLine(emailMessage.From);
            Console.WriteLine(emailMessage.To);
            Console.WriteLine(emailMessage.Subject);
            Console.WriteLine(emailMessage.Body);
            using var client = new SmtpClient(); 
            try
            {
                Console.WriteLine(" TRYING TO CONNECT SMTP");
                var host = Environment.GetEnvironmentVariable("SmtpServer");
                var port = Environment.GetEnvironmentVariable("SmtpPort");
                client.Connect(host, int.Parse(port), false);
                Console.WriteLine("CONNECTED TO SMTP");
                var smtpPass = Environment.GetEnvironmentVariable("SmtpPass");
                var smtpUser = Environment.GetEnvironmentVariable("SmtpUser");
                Console.WriteLine(smtpUser);
                Console.WriteLine(smtpPass);
                if (string.IsNullOrEmpty(smtpUser) || string.IsNullOrEmpty(smtpPass))
                {
                    Console.WriteLine("SMTP_USERNAME environment variable is missing.");
                    return;
                }
             

                client.Authenticate(smtpUser, smtpPass);

                Console.WriteLine(" SUCCESSFULLY AUTHENTICATED ");



                Console.WriteLine("TRYING TO SEND MESSAGE");
                client.Send(emailMessage);


                Console.WriteLine(" aKO SE NE ISPISE NE RADI CLIENT SEND ");
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
