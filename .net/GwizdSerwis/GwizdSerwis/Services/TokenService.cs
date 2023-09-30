using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace GwizdSerwis.Services;

public interface ITokenService
{
    ClaimsPrincipal GetClaimsPrincipalFromToken(string token);
}

public class TokenService
{
    public ClaimsPrincipal GetClaimsPrincipalFromToken(string token)
    {
        var tokenHandler = new JwtSecurityTokenHandler();
        SecurityKey key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("YourSecretKey"));

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
}
