using GwizdSerwis.DbEntities;
using GwizdSerwis.Models.Incoming;
using GwizdSerwis.Services;
using Microsoft.AspNetCore.Mvc;

namespace GwizdSerwis.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PointController : ControllerBase
    {
        private readonly IPointService _pointService;
        private readonly ITokenService _tokenService;

        public PointController(IPointService pointService, ITokenService tokenService)
        {
            _pointService = pointService;
            _tokenService = tokenService;
        }

        // GET: api/sample
        [HttpGet("Points")]
        public async Task<ActionResult> GetAsync()
        {
            throw new NotImplementedException();
            var data = await _pointService.GetAllAsync();
            return Ok(data);
        }

        // GET: api/sample/{id}
        [HttpGet("{id}")]
        public IActionResult GetByIdAsync(int id)
        {
            throw new NotImplementedException();
        }

        // POST: api/sample
        [HttpPost("CreatePoint")]
        public async Task<IActionResult> CreatePoint([FromBody] PointFVO pointFVO)
        {
            var principal = _tokenService.GetClaimsPrincipalFromToken(AuthController.Token);
            var point = await _pointService.CreatePointAync();
            return Ok(point);
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
