using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using GwizdSerwis.DbEntities;
using System.Reflection.Emit;
using System.Xml;

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

        modelBuilder.Entity<Point>().HasData(
            new Point() { Id = 1, AnimalId = 1, Added = DateTime.Now, ActiveUntil = DateTime.Now.AddHours(10), Latitude = 50.0500, Longitude = 19.9240, AuthorId = 1, District = "Małopolska", Annotation = "Cokolwiek" },
            new Point() { Id = 2, AnimalId = 2, Added = DateTime.Now, ActiveUntil = DateTime.Now.AddHours(4), Latitude = 50.1500, Longitude = 19.9740, AuthorId = 1, District = "Małopolska", Annotation = "Cokolwiek" },
            new Point() { Id = 3, AnimalId = 4, Added = DateTime.Now, ActiveUntil = DateTime.Now.AddHours(3), Latitude = 50.2500, Longitude = 19.9540, AuthorId = 1, District = "Małopolska", Annotation = "Cokolwiek" },
            new Point() { Id = 4, AnimalId = 7, Added = DateTime.Now, ActiveUntil = DateTime.Now.AddHours(10), Latitude = 51.1500, Longitude = 19.9640, AuthorId = 1, District = "Małopolska" },
            new Point() { Id = 5, AnimalId = 1, Added = DateTime.Now, ActiveUntil = DateTime.Now.AddHours(8), Latitude = 52.0400, Longitude = 21.9440, AuthorId = 1, District = "Małopolska" },
            new Point() { Id = 6, AnimalId = 1, Added = DateTime.Now, ActiveUntil = DateTime.Now.AddHours(10), Latitude = 50.1510, Longitude = 20.9440, AuthorId = 1, District = "Małopolska" },
            new Point() { Id = 7, AnimalId = 1, Added = DateTime.Now, ActiveUntil = DateTime.Now.AddHours(10), Latitude = 54.0200, Longitude = 16.9440, AuthorId = 1, District = "Małopolska", Annotation = "Cokolwiek2" },
            new Point() { Id = 8, AnimalId = 2, Added = DateTime.Now, ActiveUntil = DateTime.Now.AddHours(10), Latitude = 53.0300, Longitude = 18.9440, AuthorId = 1, District = "Małopolska", Annotation = "Cokolwiek3" },
            new Point() { Id = 9, AnimalId = 2, Added = DateTime.Now, ActiveUntil = DateTime.Now.AddHours(10), Latitude = 52.3200, Longitude = 20.5440, AuthorId = 1, District = "Małopolska", Annotation = "Cokolwiek3" },
            new Point() { Id = 10, AnimalId = 1, Added = DateTime.Now, ActiveUntil = DateTime.Now.AddHours(10), Latitude = 49.4400, Longitude = 19.3440, AuthorId = 1, District = "Małopolska", Annotation = "Cokolwiek3" }
        );
    }

    public void Filter(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Point>().HasQueryFilter(e => e.ActiveUntil > DateTime.Now);
    }
}
