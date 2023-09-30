using AutoMapper;
using GwizdSerwis.DbEntities;
using GwizdSerwis.Models;
using GwizdSerwis.Repository;

namespace GwizdSerwis.Services
{
    public interface IAnimalService
    {
        Task<IEnumerable<AnimalDTO>> GetAllAsync();
    }

    public class AnimalService : IAnimalService
    {
        private readonly IMapper _mapper;
        private readonly IAnimalRepository _animalRepository;

        public AnimalService(
            IMapper mapper,
            IAnimalRepository animalRepository)
        {
            _mapper = mapper;
            _animalRepository = animalRepository;
        }

        public async Task<IEnumerable<AnimalDTO>> GetAllAsync()
        {
            var animals = await _animalRepository.GetAllAsync();
            return _mapper.Map<IEnumerable<AnimalDTO>>(animals);
        }
    }
}
