using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace GwizdSerwis.DbEntities
{
    public class Image : EntityBase
    {
        public int PointId { get; set; }
        public string Path { get; set; } = null!;


        [JsonIgnore]
        [ForeignKey("PointId")]
        [InverseProperty("Images")]
        public Point Point { get; set; } = null!;
    }
}
