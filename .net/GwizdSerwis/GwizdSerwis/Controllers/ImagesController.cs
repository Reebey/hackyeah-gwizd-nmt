using GwizdSerwis.Repository;
using Microsoft.AspNetCore.Mvc;

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
    }
}
