using System.ComponentModel.DataAnnotations.Schema;

namespace GwizdSerwis.DbEntities
{
    public class Point : EntityBase
    {
        public int AuthorId { get; set; }
        public int AnimalId { get; set; }
        public double Longitude { get; set; }
        public double Latitude { get; set; }
        public string? Annotation { get; set; }


        [ForeignKey("AuthorId")]
        public AppUser Author { get; set; } = null!;
        [ForeignKey("AnimalId")]
        [InverseProperty("Points")]
        public Animal Animal { get; set; } = null!;
        [InverseProperty("Point")]
        public ICollection<Image> Images { get; set; } = new List<Image>();
    }
}
