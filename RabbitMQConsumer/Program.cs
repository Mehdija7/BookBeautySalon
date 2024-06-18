using System.Text;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using RabbitMQConsumer;

var factory = new ConnectionFactory { HostName = "localhost" };
using var connection = factory.CreateConnection();
using var channel = connection.CreateModel();

channel.QueueDeclare(queue: "orders",
                     durable: false,
                     exclusive: false,
                     autoDelete: false,
                     arguments: null);

Console.WriteLine(" [*] Waiting for messages.");

var consumer = new EventingBasicConsumer(channel);
consumer.Received += (model, ea) =>
{
    var body = ea.Body.ToArray();
    var message = Encoding.UTF8.GetString(body);
    EmailService emailService = new EmailService();
    emailService.SendEmail(message);

    channel.BasicAck(ea.DeliveryTag, false);
    Console.WriteLine($" [x] Received {message}");
};
channel.BasicConsume(queue: "orders",
                     autoAck: true,
                     consumer: consumer);

Thread.Sleep(Timeout.Infinite);

channel.Close();
connection.Close();

Console.WriteLine(" Press [enter] to exit.");
Console.ReadLine();