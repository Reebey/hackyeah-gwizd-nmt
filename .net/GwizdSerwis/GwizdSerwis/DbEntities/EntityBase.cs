using System.ComponentModel.DataAnnotations;

namespace GwizdSerwis.DbEntities
{
    public class EntityBase
    {
        [Key]
        public int Id { get; set; }
    }
}
