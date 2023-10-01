using GwizdSerwis.DbEntities;

namespace GwizdSerwis.Services;

public class NearestNeighborPointService
{
    private readonly IPointService _pointService;

    public NearestNeighborPointService(IPointService pointService)
    {
        _pointService = pointService;
    }

    public async Task<IEnumerable<Point>> FindNearestPoints(Point target, long distancePoint)
    {
        var points = await _pointService.GetAllAsync();

        if (points == null || !points.Any())
            return Enumerable.Empty<Point>();

        List<Point> nearestPoints = new List<Point>();

        foreach (var point in points)
        {
            double distance = CalculateDistance(target, point);

            if (distance <= distancePoint)
            {
                nearestPoints.Add(point);
            }
        }

        return nearestPoints;
    }

    private double CalculateDistance(Point p1, Point p2)
    {
        double deltaX = p1.Longitude - p2.Longitude;
        double deltaY = p1.Latitude - p2.Latitude;
        return Math.Sqrt(deltaX * deltaX + deltaY * deltaY);
    }
}
