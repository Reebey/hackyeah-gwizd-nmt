using GwizdSerwis.DbEntities;
using GwizdSerwis.Repository;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace GwizdSerwis.Controllers
{
    [Route("api/images")]
    [ApiController]
    public class ImagesController : ControllerBase
    {
        private readonly IImageRepository _imageRepository;

        public ImagesController(IImageRepository imageRepository)
        {
            _imageRepository = imageRepository;
        }

        [HttpGet("{imageId}")]
        public async Task<IActionResult> GetImage(int imageId)
        {
            var imageData = await _imageRepository.GetImageAsync(imageId);

            if (imageData == null)
            {
                return NotFound();
            }

            var contentType = "image/jpeg";

            return File(imageData, contentType);
        }

        [HttpPost]
        [Route("UploadImage")]
        public async Task<IActionResult> UploadImage([FromQuery] int pointId, IFormFile image)
        {
            try
            {
                if (image != null && image.Length > 0)
                {
                    // Handle the uploaded image here. You can save it to a file or process it as needed.
                    string uniqueFileName = Guid.NewGuid().ToString() + Path.GetExtension(image.FileName);

                    // Combine the path for saving the file
                    string uploadsFolder = Path.Combine(Directory.GetCurrentDirectory(), "images");
                    string filePath = Path.Combine(uploadsFolder, uniqueFileName);

                    // Ensure the folder exists
                    Directory.CreateDirectory(uploadsFolder);

                    using (var stream = new FileStream(filePath, FileMode.Create))
                    {
                        await image.CopyToAsync(stream);
                    }

                    var imageId = await _imageRepository.AddNewImage(new Image { Path = filePath, PointId = pointId });

                    return Ok(imageId);
                }
                else
                {
                    return BadRequest("Image is missing or empty.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
    }
}
