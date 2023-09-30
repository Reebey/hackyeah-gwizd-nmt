using Microsoft.AspNetCore.Identity;
using System.ComponentModel.DataAnnotations.Schema;

namespace GwizdSerwis.DbEntities
{
    public class AppUser : IdentityUser<int>
    {

        [InverseProperty("Author")]
        ICollection<Point> Points { get; set; } = new List<Point>();
    }

}
