using System.ComponentModel.DataAnnotations.Schema;

namespace GwizdSerwis.DbEntities
{
    public class Image : EntityBase
    {
        public int PointId { get; set; }
        public string Path { get; set; } = null!;


        [ForeignKey("PointId")]
        [InverseProperty("Images")]
        public Point Point { get; set; } = null!;
    }
}
