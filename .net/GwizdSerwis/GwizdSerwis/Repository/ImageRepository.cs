using GwizdSerwis.Context;
using GwizdSerwis.DbEntities;

namespace GwizdSerwis.Repository;

public interface IImageRepository
{
    Task<byte[]> GetImageAsync(int id);
    Task<int> AddNewImage(Image image);
}

public class ImageRepository : IImageRepository
{
    private readonly ApplicationDbContext _context;

    public ImageRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<int> AddNewImage(Image image)
    {
        _context.Images.Add(image);
        await _context.SaveChangesAsync();
        return image.Id;
    }

    public async Task<byte[]> GetImageAsync(int id)
    {
        Image? image = await _context.Images.FindAsync(id);
        string imagePath = image?.Path ?? string.Empty;

        if (string.IsNullOrEmpty(imagePath))
        {
            return null;
        }

        if (File.Exists(imagePath))
        {
            return await File.ReadAllBytesAsync(imagePath);
        }
        return null;
    }
}
