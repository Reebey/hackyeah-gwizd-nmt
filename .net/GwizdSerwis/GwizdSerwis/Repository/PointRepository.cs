using GwizdSerwis.Context;
using GwizdSerwis.DbEntities;
using GwizdSerwis.Models.Incoming;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections;

namespace GwizdSerwis.Repository
{
    public interface IPointRepository
    {
        Task<IEnumerable<Point>> GetAllAsync();
        Task<Point> CreatePointAync(string userId, PointFVO point);
        Task<IEnumerable<Point>> GetNewestPins(int limit);
    }

    public class PointRepository : IPointRepository
    {
        public readonly ApplicationDbContext _dbContext;
        public PointRepository(ApplicationDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<Point> CreatePointAync(string userId, PointFVO point)
        {
            int userIdInt = Convert.ToInt32(userId);
            Point newPoint = new Point() { AuthorId = userIdInt, Latitude = point.Localization.Latitude, Longitude = point.Localization.Longitude, AnimalId = point.AnimalId.Value };
            await _dbContext.Points.AddAsync(newPoint);
            _dbContext.SaveChanges();
            return _dbContext.Points.Include(p => p.Author).Include(p => p.Animal).Include(p => p.Images).First(p => p.Id == newPoint.Id);
        }

        public async Task<IEnumerable<Point>> GetAllAsync()
        {
            return await _dbContext.Points.ToListAsync();
        }

        public async Task<IEnumerable<Point>> GetNewestPins(int limit)
        {
            return await _dbContext.Points.Include(p => p.Author).Include(p => p.Animal).Include(p => p.Images).OrderByDescending(p => p.Added).Take(limit).ToListAsync();
        }
    }
}
