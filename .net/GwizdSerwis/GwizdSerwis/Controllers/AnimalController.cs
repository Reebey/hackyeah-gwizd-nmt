using GwizdSerwis.DbEntities;
using GwizdSerwis.Models;
using GwizdSerwis.Services;
using Microsoft.AspNetCore.Mvc;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace GwizdSerwis.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AnimalController : ControllerBase
    {
        private readonly IAnimalService _animalService;

        public AnimalController(IAnimalService animalService)
        {
            _animalService = animalService;
        }

        [HttpGet("Animals")]
        public async Task<ActionResult<IEnumerable<AnimalDTO>>> GetAllAsync()
        {
            return Ok(await _animalService.GetAllAsync());
        }
    }
}
