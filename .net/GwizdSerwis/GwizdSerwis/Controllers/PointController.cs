using GwizdSerwis.DbEntities;
using GwizdSerwis.Services;
using Microsoft.AspNetCore.Mvc;

namespace GwizdSerwis.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PointController : ControllerBase
    {
        protected readonly IPointService _pointService;

        public PointController(IPointService pointService)
        {
            _pointService = pointService;
        }

        // GET: api/sample
        [HttpGet("Points")]
        public async Task<ActionResult<ICollection<Point>>> GetAsync()
        {
            throw new NotImplementedException();
            return await _pointService.GetAllAsync();
        }

        // GET: api/sample/{id}
        [HttpGet("{id}")]
        public IActionResult GetByIdAsync(int id)
        {
            throw new NotImplementedException();
        }

        // POST: api/sample
        [HttpPost]
        public IActionResult Post([FromBody] Point model)
        {
            throw new NotImplementedException();
        }

        // PUT: api/sample/{id}
        [HttpPut("{id}")]
        public IActionResult Put(int id, [FromBody] Point model)
        {
            throw new NotImplementedException();
        }

        // DELETE: api/sample/{id}
        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            throw new NotImplementedException();
        }
    }
}
