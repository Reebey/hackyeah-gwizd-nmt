using GwizdSerwis.DbEntities;
using GwizdSerwis.Repository;
using Microsoft.AspNetCore.Mvc;

namespace GwizdSerwis.Services
{
    public interface IPointService
    {
        Task<ICollection<Point>> GetAllAsync();
    }

    public class PointService : IPointRepository
    {
        private readonly PointRepository _pointRepository;

        public PointService(PointRepository pointRepository)
        {
            _pointRepository = pointRepository;
        }

        public async Task<ICollection<Point>> GetAllAsync()
        {
            return await _pointRepository.GetAllAsync();
        }
    }
}
