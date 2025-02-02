using System.Text;
using Microsoft.Extensions.Configuration;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using RabbitMQConsumer;

class Program
{
    static void Main(string[] args)
    {
        var builder = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("appsettings.json")
            .AddEnvironmentVariables();

        var configuration = builder.Build();

        var emailService = new EmailService(configuration);

        var rabbitMQConsumer = new RabbitMQConsumer.RabbitMQConsumer (configuration, emailService);
        rabbitMQConsumer.SendEmail();
        Console.WriteLine("RabbitMQ Consumer started");
        Thread.Sleep(Timeout.Infinite);
    }
}