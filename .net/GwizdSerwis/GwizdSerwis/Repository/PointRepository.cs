using GwizdSerwis.Context;
using GwizdSerwis.DbEntities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections;

namespace GwizdSerwis.Repository
{
    public interface IPointRepository
    {
        Task<ICollection<Point>> GetAllAsync();
    }

    public class PointRepository : IPointRepository
    {
        public readonly ApplicationDbContext _dbContext;
        public PointRepository(ApplicationDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<ICollection<Point>> GetAllAsync()
        {
            return await _dbContext.Points.ToListAsync();
        }
    }
}
