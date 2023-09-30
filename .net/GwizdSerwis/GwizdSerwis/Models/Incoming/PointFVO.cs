using GwizdSerwis.ControllersModels;

namespace GwizdSerwis.Models.Incoming
{
    public class PointFVO
    {
        LocalizationDTO Localization { get; set; } = null!;
        UserDTO User { get; set; } = null!;
    }
}
