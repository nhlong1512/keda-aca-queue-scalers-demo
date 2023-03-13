using Microsoft.Extensions.Configuration;

namespace ServiceBusQueueProducer
{
    public class Configuration
    {
        private IConfigurationRoot config;

        public Configuration()
        {
            config = new ConfigurationBuilder()
                .AddEnvironmentVariables()
                .Build();
        }

        public string ConnectionString => config[ConfigurationKeys.ConnectionString];

        public string QueueName => config[ConfigurationKeys.QueueName];

        public int NumberOfMessages
        {
            get
            {
                if (!int.TryParse(config[ConfigurationKeys.NumberOfMessages], out int n))
                    n = 5;
                return n;
            }
        }
    }
}
