
namespace bookBeauty.Services
{
    internal class SendMessageRequestModel
    {
        public string SenderUsername { get; set; }
        public string ReceiverUsername { get; set; }
        public DateTime DateSent { get; set; }
        public string Content { get; set; }
    }
}