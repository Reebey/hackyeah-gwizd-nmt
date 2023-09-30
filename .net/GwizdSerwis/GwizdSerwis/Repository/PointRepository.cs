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
        public readonly DbSet<Point> _table;
        public PointRepository(ApplicationDbContext dbContext)
        {
            _dbContext = dbContext;
            _table = dbContext.Set<Point>();
        }

        public async Task<ICollection<Point>> GetAllAsync()
        {
            return await _table.ToListAsync();
        }
    }
}
