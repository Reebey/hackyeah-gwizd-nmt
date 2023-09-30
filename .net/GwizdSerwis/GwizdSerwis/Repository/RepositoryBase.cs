using GwizdSerwis.Context;

namespace GwizdSerwis.Repository
{
    public class RepositoryBase
    {
        protected readonly ApplicationDbContext _dbContext;
        public RepositoryBase(ApplicationDbContext dbContext)
        {
            _dbContext = dbContext;
        }
    }
}
