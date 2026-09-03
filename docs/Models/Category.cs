namespace RaceDayAPI.Models
{
    public class Category
    {
        public int CategoryId { get; set; }
        public int EventId { get; set; }
        public string CategoryName { get; set; } = string.Empty;
        public decimal DistanceKM { get; set; }
        public decimal Fee { get; set; }

        public Event? Event { get; set; }
    }
}