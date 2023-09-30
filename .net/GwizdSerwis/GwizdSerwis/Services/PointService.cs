using GwizdSerwis.DbEntities;
using GwizdSerwis.Repository;

namespace GwizdSerwis.Services
{
    public interface IPointService
    {
        Task<IEnumerable<Point>> GetAllAsync();
    }

    public class PointService : IPointService
    {
        private readonly IPointRepository _pointRepository;

        public PointService(IPointRepository pointRepository)
        {
            _pointRepository = pointRepository;
        }

        public async Task<IEnumerable<Point>> GetAllAsync()
        {
            return await _pointRepository.GetAllAsync();
        }
    }
}