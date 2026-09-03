using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RaceDayAPI.DTOs;

namespace RaceDayAPI.Controllers
{
    [Route("api/results")]
    [ApiController]
    public class ResultsController : ControllerBase
    {
        private readonly RaceDayDbContext _context;

        public ResultsController(RaceDayDbContext context)
        {
            _context = context;
        }

        // POST: api/results
        [HttpPost]
        public async Task<IActionResult> CaptureResult([FromBody] CaptureResultDto dto)
        {
            var enrolment = await _context.Enrolments.FindAsync(dto.EnrolmentId);
            if (enrolment == null)
            {
                return NotFound(new { message = "Enrolment record not found." });
            }

            var result = new Result
            {
                EnrolmentId = dto.EnrolmentId,
                FinishTimeSeconds = dto.FinishTimeSeconds,
                OverallRank = dto.OverallRank,
                CategoryRank = dto.CategoryRank
            };

            _context.Results.Add(result);
            await _context.SaveChangesAsync();

            return StatusCode(201, new { resultID = result.ResultId });
        }

        // GET: api/results/my-results/{participantId}
        [HttpGet("my-results/{participantId}")]
        public async Task<IActionResult> GetMyResults(int participantId)
        {
            var results = await _context.Results
                .Include(r => r.Enrolment)
                    .ThenInclude(e => e.Category)
                        .ThenInclude(c => c.Event)
                .Where(r => r.Enrolment.ParticipantId == participantId)
                .ToListAsync();

            return Ok(results);
        }
    }
}