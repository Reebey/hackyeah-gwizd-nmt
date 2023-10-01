using AutoMapper;
using GwizdSerwis;
using GwizdSerwis.Context;
using GwizdSerwis.DbEntities;
using GwizdSerwis.Filters;
using GwizdSerwis.Repository;
using GwizdSerwis.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Security.Claims;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
//repositories
builder.Services.AddTransient<IAnimalRepository, AnimalRepository>();
builder.Services.AddTransient<IPointRepository, PointRepository>();
builder.Services.AddTransient<IImageRepository, ImageRepository>();
//services
builder.Services.AddScoped<IAnimalService, AnimalService>();
builder.Services.AddScoped<IPointService, PointService>();
builder.Services.AddScoped<IImageService, ImageService>();
builder.Services.AddScoped<ITokenService, TokenService>();
builder.Services.AddScoped<INearestNeighborPointService, NearestNeighborPointService>();
//filter
builder.Services.AddScoped<MyCustomActionFilter>();

builder.Services.AddControllers();

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<ApplicationDbContext>(options => options.UseSqlServer(builder.Configuration.GetConnectionString("SqlConnection")));
builder.Services.AddIdentity<AppUser, IdentityRole<int>>(options => options.SignIn.RequireConfirmedAccount = true)
                .AddEntityFrameworkStores<ApplicationDbContext>()
                .AddDefaultTokenProviders();

builder.Services.Configure<IdentityOptions>(options =>
{
    options.Password.RequireDigit = false;          // Don't require a digit
    options.Password.RequiredLength = 6;            // Minimum password length
    options.Password.RequireUppercase = false;      // Don't require an uppercase letter
    options.Password.RequireLowercase = false;      // Don't require a lowercase letter
    options.Password.RequireNonAlphanumeric = false; // Don't require a non-alphanumeric character
    options.ClaimsIdentity.UserIdClaimType = ClaimTypes.NameIdentifier;
});


// auth
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
}).AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = false,
        ValidateAudience = false,
        ValidateLifetime = false,
        ValidateIssuerSigningKey = false,
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("MySecretKey!@#123")),
        ClockSkew = TimeSpan.Zero
    };
});


builder.Services.AddSingleton(provider => new MapperConfiguration(cfg =>
{
    cfg.AddProfile(typeof(AutoMapperProfiles));
}).CreateMapper());

var app = builder.Build();

//create database
var s = app.Services.GetRequiredService<IServiceScopeFactory>();
using (var scope = s.CreateScope())
{
    scope.ServiceProvider.GetRequiredService<ApplicationDbContext>().Database.EnsureCreated();
}

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
