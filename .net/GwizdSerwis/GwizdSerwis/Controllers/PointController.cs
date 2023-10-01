using GwizdSerwis.DbEntities;
using GwizdSerwis.Models.Incoming;
using GwizdSerwis.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace GwizdSerwis.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(AuthenticationSchemes = "Bearer")]
    public class PointController : ControllerBase
    {
        private readonly IPointService _pointService;
        private readonly UserManager<AppUser> _userManager;

        public PointController(IPointService pointService, UserManager<AppUser> userManager)
        {
            _pointService = pointService;
            _userManager = userManager;
        }

        // GET: api/sample
        [HttpGet("Points")]
        public async Task<ActionResult> GetAsync()
        {
            throw new NotImplementedException();
            var data = await _pointService.GetAllAsync();
            return Ok(data);
        }

        [HttpGet("NewestPoints")]
        public async Task<ActionResult> GetNewestPinsAsymc([FromQuery] int limit = 100)
        {
            var data = await _pointService.GetNewestPins(limit);
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
            string userName = User.FindFirst(ClaimTypes.NameIdentifier)!.Value;
            var user = await _userManager.FindByEmailAsync(userName);
            var point = await _pointService.CreatePointAync(user.Id.ToString(), pointFVO);
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
