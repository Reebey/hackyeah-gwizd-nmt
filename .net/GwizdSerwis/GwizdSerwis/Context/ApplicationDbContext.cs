using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using GwizdSerwis.DbEntities;
using System.Reflection.Emit;

namespace GwizdSerwis.Context;

public class ApplicationDbContext : IdentityDbContext<IdentityUser>
{
    public DbSet<Animal> Animals { get; set; }
    public DbSet<Image> Images { get; set; }
    public DbSet<Point> Points { get; set; }


    public ApplicationDbContext(DbContextOptions options) : base(options)
    {
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Animal>();
        modelBuilder.Entity<Image>();
        modelBuilder.Entity<Point>();

        Seed(modelBuilder);
    }

    public void Seed(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<AppUser>().HasData(
               new AppUser() { Id = 1, Email="test@example.com", UserName = "Mateusz" },
               new AppUser() { Id = 2, Email="admintest@example.com", UserName = "Michal" }
        );
    }
}
