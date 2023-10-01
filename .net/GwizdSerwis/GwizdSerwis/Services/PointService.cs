using GwizdSerwis.DbEntities;
using GwizdSerwis.Models.Incoming;
using GwizdSerwis.Repository;

namespace GwizdSerwis.Services
{
    public interface IPointService
    {
        Task<IEnumerable<Point>> GetAllAsync();
        Task<Point> CreatePointAync(string userId, PointFVO point);
        Task<IEnumerable<Point>> GetNewestPins(int limit);
    }

    public class PointService : IPointService
    {
        private readonly IPointRepository _pointRepository;

        public PointService(IPointRepository pointRepository)
        {
            _pointRepository = pointRepository;
        }

        public async Task<Point> CreatePointAync(string userId, PointFVO point)
        {
            var newPoint = await _pointRepository.CreatePointAync(userId, point);
            return newPoint;
        }

        public async Task<IEnumerable<Point>> GetAllAsync()
        {
            return await _pointRepository.GetAllAsync();
        }

        public async Task<IEnumerable<Point>> GetNewestPins(int limit)
        {
            return await _pointRepository.GetNewestPins(limit);
        }
    }
}
