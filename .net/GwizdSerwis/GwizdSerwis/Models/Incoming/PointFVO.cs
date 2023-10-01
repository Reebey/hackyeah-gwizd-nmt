using GwizdSerwis.ControllersModels;

namespace GwizdSerwis.Models.Incoming
{
    public class PointFVO
    {
        public LocalizationDTO? Localization { get; set; }
        public string? Annotation { get; set; }
        public int? AnimalId { get; set; }
    }
}
