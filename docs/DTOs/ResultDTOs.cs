namespace RaceDayAPI.DTOs
{
    public class CaptureResultDto
    {
        public int EnrolmentId { get; set; }
        public int FinishTimeSeconds { get; set; }
        public int OverallRank { get; set; }
        public int CategoryRank { get; set; }
    }
}