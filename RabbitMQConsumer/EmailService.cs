
using System.Net.Mail;
using System.Net;


namespace RabbitMQConsumer
{
    public class EmailService 
    {
        public class EmailModelToParse
        {
            public string Sender { get; set; }
            public string Recipient { get; set; }
            public string Subject { get; set; }
            public string Content { get; set; }
        }

        public void SendEmail(string message)
        {
            try
            {
                
                string smtpServer = Environment.GetEnvironmentVariable("SMTP_SERVER") ?? "smtp.gmail.com";
                int smtpPort = int.Parse(Environment.GetEnvironmentVariable("SMTP_PORT") ?? "587");
                string fromMail = Environment.GetEnvironmentVariable("SMTP_USERNAME") ?? "frizerfrizer75@gmail.com";
                string password = Environment.GetEnvironmentVariable("SMTP_PASSWORD") ?? "iqczzyejukuljlgk";

                MailMessage mailMessage = new MailMessage(fromMail, "mehdijabookbeauty@gmail.com", "Nova narudzba",message);

                var smtpClient = new SmtpClient()
                {
                    UseDefaultCredentials = false,
                    Host = smtpServer,
                    Port = smtpPort,
                    Credentials = new NetworkCredential(fromMail, password),
                    EnableSsl = true
                };
               
                smtpClient.Send(mailMessage);

                Console.WriteLine("*********** MAIL MESSAGE******************");
                Console.WriteLine($"{mailMessage.Body}\n{mailMessage.From}\n{mailMessage.To}");

            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error sending email: {ex.Message}");
            }
        }
    }
}
