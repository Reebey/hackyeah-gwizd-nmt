using GwizdSerwis.Context;
using GwizdSerwis.DbEntities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections;

namespace GwizdSerwis.Repository
{
    public interface IPointRepository
    {
        Task<IEnumerable<Point>> GetAllAsync();
        Task<Point> CreatePointAync();
    }

    public class PointRepository : IPointRepository
    {
        public readonly ApplicationDbContext _dbContext;
        public PointRepository(ApplicationDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<Point> CreatePointAync()
        {
            Point newPoint = new Point() { };
            await _dbContext.Points.AddAsync(newPoint);
            return newPoint;
        }

        public async Task<IEnumerable<Point>> GetAllAsync()
        {
            return await _dbContext.Points.ToListAsync();
        }
    }
}
