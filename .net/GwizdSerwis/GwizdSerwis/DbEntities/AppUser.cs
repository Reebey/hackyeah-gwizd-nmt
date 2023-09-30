using Microsoft.AspNetCore.Identity;
using System.ComponentModel.DataAnnotations.Schema;

namespace GwizdSerwis.DbEntities
{
    public class AppUser : IdentityUser<int>
    {
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;


        [InverseProperty("Author")]
        ICollection<Point> Points { get; set; } = new List<Point>();
    }

}
