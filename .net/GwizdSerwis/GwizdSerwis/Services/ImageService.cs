using GwizdSerwis.Repository;

namespace GwizdSerwis.Services
{
    public interface IImageService
    {
        Task<byte[]> GetImageAsync(int id);
    }
    public class ImageService : IImageService
    {
        private readonly IImageRepository _imageRepository;

        public ImageService(IImageRepository imageRepository) 
        {
            _imageRepository = imageRepository;
        }

        public Task<byte[]> GetImageAsync(int id)
        {
            return _imageRepository.GetImageAsync(id);
        }
    }
}
