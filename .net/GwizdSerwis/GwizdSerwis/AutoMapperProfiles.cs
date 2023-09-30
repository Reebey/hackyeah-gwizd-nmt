using AutoMapper;
using GwizdSerwis.DbEntities;
using GwizdSerwis.Models;

namespace GwizdSerwis
{
    public class AutoMapperProfiles : Profile
    {
        public AutoMapperProfiles()
        {
            CreateMap<Animal, AnimalDTO>()
                .ReverseMap();

        }
    }
}
