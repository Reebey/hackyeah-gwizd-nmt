using GwizdSerwis.DbEntities;
using System.Text.Json.Serialization;

namespace GwizdSerwis.Models
{
    public class AnimalDTO
    {
        public int Id { get; set; }
        public string Name { get; set; } = null!;

        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ThreatLevel ThreatLevel { get; set; }
    }
}
