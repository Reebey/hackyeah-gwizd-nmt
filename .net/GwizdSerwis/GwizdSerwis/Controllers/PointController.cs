using GwizdSerwis.DbEntities;
using Microsoft.AspNetCore.Mvc;

namespace GwizdSerwis.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PointController : ControllerBase
    {
        // GET: api/sample
        [HttpGet("Points")]
        public ActionResult<ICollection<Point>> Get()
        {
            throw new NotImplementedException();
        }

        // GET: api/sample/{id}
        [HttpGet("{id}")]
        public IActionResult GetById(int id)
        {
            // Your logic to retrieve data by ID goes here
            // For simplicity, we'll return a sample JSON response
            var data = new { Id = id, Message = "Data for ID " + id };
            return Ok(data);
        }

        // POST: api/sample
        [HttpPost]
        public IActionResult Post([FromBody] Point model)
        {
            // Your logic to create a new resource goes here
            // For simplicity, we'll return a sample JSON response
            var data = new { Message = "Resource created successfully", CreatedData = model };
            return CreatedAtAction("Get", data);
        }

        // PUT: api/sample/{id}
        [HttpPut("{id}")]
        public IActionResult Put(int id, [FromBody] Point model)
        {
            // Your logic to update a resource by ID goes here
            // For simplicity, we'll return a sample JSON response
            var data = new { Message = "Resource updated successfully", UpdatedData = model };
            return Ok(data);
        }

        // DELETE: api/sample/{id}
        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            // Your logic to delete a resource by ID goes here
            // For simplicity, we'll return a sample JSON response
            var data = new { Message = "Resource with ID " + id + " deleted successfully" };
            return Ok(data);
        }
    }
}
