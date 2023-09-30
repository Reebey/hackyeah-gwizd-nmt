using System.ComponentModel.DataAnnotations.Schema;

namespace GwizdSerwis.DbEntities
{
    public class Animal : EntityBase
    {
        public string Name { get; set; } = null!;
        public ThreatLevel ThreatLevel { get; set; }


        [InverseProperty("Animal")]
        public ICollection<Point> Points { get; set; } = new List<Point>();
    }


    public enum ThreatLevel : byte { Low = 1, High = 2 };
}
