using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace GwizdSerwis.Services;

public interface ITokenService
{
    ClaimsPrincipal GetClaimsPrincipalFromToken(string token);
    (string userId, string userName, string userEmail, string userRole) GetUserInfo(ClaimsPrincipal user);
}

public class TokenService : ITokenService
{
    public ClaimsPrincipal GetClaimsPrincipalFromToken(string token)
    {
        var tokenHandler = new JwtSecurityTokenHandler();
        SecurityKey key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("MySecretKey!@#123"));

        try
        {
            var claimsPrincipal = tokenHandler.ValidateToken(token, new TokenValidationParameters
            {
                ValidateIssuerSigningKey = true, 
                IssuerSigningKey = key, 
                ValidateIssuer = false, 
                ValidateAudience = false, 
                ClockSkew = TimeSpan.Zero 
            }, out var validatedToken);

            return claimsPrincipal;
        }
        catch (Exception ex)
        {
            throw new Exception("Token validation failed: " + ex.Message);
        }
    }

    public (string userId, string userName, string userEmail, string userRole) GetUserInfo(ClaimsPrincipal user)
    {
        if (user.Identity.IsAuthenticated)
        {
            var userId = user.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            var userName = user.Identity.Name;
            var userEmail = user.FindFirst(ClaimTypes.Email)?.Value;
            var userRole = user.FindFirst(ClaimTypes.Role)?.Value;
            return (userId, userName, userEmail, userRole);
        }
        else
        {
            return (string.Empty, string.Empty, string.Empty, string.Empty);
        }
    }
}
