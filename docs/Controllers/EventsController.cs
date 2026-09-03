using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RaceDayAPI.DTOs;

namespace RaceDayAPI.Controllers
{
    [Route("api/events")]
    [ApiController]
    public class EventsController : ControllerBase
    {
        private readonly RaceDayDbContext _context;

        public EventsController(RaceDayDbContext context)
        {
            _context = context;
        }

        // GET: api/events
        [HttpGet]
        public async Task<IActionResult> GetAllEvents()
        {
            var events = await _context.Events
                .Include(e => e.Categories)
                .ToListAsync();

            return Ok(events);
        }

        // POST: api/events
        [HttpPost]
        public async Task<IActionResult> CreateEvent([FromBody] CreateEventDto dto)
        {
            var newEvent = new Event
            {
                EventName = dto.EventName,
                Description = dto.Description,
                EventDate = dto.EventDate,
                Location = dto.Location,
                OrganiserId = dto.OrganiserId
            };

            _context.Events.Add(newEvent);
            await _context.SaveChangesAsync();

            return StatusCode(201, new { eventID = newEvent.EventId });
        }

        // POST: api/events/{eventId}/categories
        [HttpPost("{eventId}/categories")]
        public async Task<IActionResult> AddCategory(int eventId, [FromBody] CreateCategoryDto dto)
        {
            var raceEvent = await _context.Events.FindAsync(eventId);
            if (raceEvent == null)
            {
                return NotFound(new { message = "Event not found." });
            }

            var category = new Category
            {
                EventId = eventId,
                CategoryName = dto.CategoryName,
                DistanceKM = dto.DistanceKM,
                Fee = dto.Fee
            };

            _context.Categories.Add(category);
            await _context.SaveChangesAsync();

            return StatusCode(201, new { categoryID = category.CategoryId });
        }
    }
}