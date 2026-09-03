namespace RaceDayAPI.Models
{
    public class Result
    {
        public int ResultId { get; set; }
        public int EnrolmentId { get; set; }
        public int FinishTimeSeconds { get; set; }
        public int OverallRank { get; set; }
        public int CategoryRank { get; set; }

        public Enrolment? Enrolment { get; set; }
    }
}