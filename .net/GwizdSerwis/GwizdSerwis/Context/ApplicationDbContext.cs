using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using GwizdSerwis.DbEntities;
using System.Reflection.Emit;

namespace GwizdSerwis.Context;

public class ApplicationDbContext : IdentityDbContext<AppUser, IdentityRole<int>, int>
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
               new AppUser() { Id = 1, Email="test@example.com", UserName = "test@example.com", FirstName = "Mateusz", LastName = "Kowalski" },
               new AppUser() { Id = 2, Email="admintest@example.com", UserName = "admintest@example.com", FirstName = "Michal", LastName = "Nowak" }
        );

        modelBuilder.Entity<Animal>().HasData(
               new Animal() { Id = 1, Name = "Żubr", ThreatLevel = ThreatLevel.High },
               new Animal() { Id = 2, Name = "Ryś", ThreatLevel = ThreatLevel.High },
               new Animal() { Id = 3, Name = "Dziki kot", ThreatLevel = ThreatLevel.High },
               new Animal() { Id = 4, Name = "Dziki pies", ThreatLevel = ThreatLevel.High },
               new Animal() { Id = 5, Name = "Sarna", ThreatLevel = ThreatLevel.Low },
               new Animal() { Id = 6, Name = "Jeleń", ThreatLevel = ThreatLevel.High },
               new Animal() { Id = 7, Name = "Wilk", ThreatLevel = ThreatLevel.High },
               new Animal() { Id = 8, Name = "Niedźwiedź", ThreatLevel = ThreatLevel.High },
               new Animal() { Id = 9, Name = "Królik", ThreatLevel = ThreatLevel.Low },
               new Animal() { Id = 10, Name = "Zając", ThreatLevel = ThreatLevel.Low }
        );
    }
}
