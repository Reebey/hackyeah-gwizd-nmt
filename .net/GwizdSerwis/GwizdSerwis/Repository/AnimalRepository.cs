using GwizdSerwis.Context;
using GwizdSerwis.DbEntities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections;

namespace GwizdSerwis.Repository
{
    public interface IAnimalRepository
    {
        Task<IEnumerable<Animal>> GetAllAsync();
    }

    public class AnimalRepository : IAnimalRepository
    {
        public readonly ApplicationDbContext _dbContext;
        public readonly DbSet<Animal> _table;
        public AnimalRepository(ApplicationDbContext dbContext)
        {
            _dbContext = dbContext;
            _table = dbContext.Set<Animal>();
        }

        public async Task<IEnumerable<Animal>> GetAllAsync()
        {
            return await _table.ToListAsync();
        }
    }
}
