using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RaceDayAPI.DTOs;

namespace RaceDayAPI.Controllers
{
    [Route("api/enrolments")]
    [ApiController]
    public class EnrolmentsController : ControllerBase
    {
        private readonly RaceDayDbContext _context;

        public EnrolmentsController(RaceDayDbContext context)
        {
            _context = context;
        }

        // POST: api/enrolments
        [HttpPost]
        public async Task<IActionResult> Enroll([FromBody] CreateEnrolmentDto dto)
        {
            var category = await _context.Categories.FindAsync(dto.CategoryId);
            if (category == null)
            {
                return NotFound(new { message = "Selected race category does not exist." });
            }

            var enrolment = new Enrolment
            {
                ParticipantId = dto.ParticipantId,
                CategoryId = dto.CategoryId,
                EnrolmentDate = DateTime.UtcNow,
                Status = "Confirmed"
            };

            _context.Enrolments.Add(enrolment);
            await _context.SaveChangesAsync();

            return StatusCode(201, new { enrolmentID = enrolment.EnrolmentId });
        }

        // GET: api/enrolments/event/{eventId}
        [HttpGet("event/{eventId}")]
        public async Task<IActionResult> GetEnrolmentsByEvent(int eventId)
        {
            var enrolments = await _context.Enrolments
                .Include(e => e.Category)
                .Include(e => e.Participant)
                .Where(e => e.Category.EventId == eventId)
                .ToListAsync();

            return Ok(enrolments);
        }
    }
}