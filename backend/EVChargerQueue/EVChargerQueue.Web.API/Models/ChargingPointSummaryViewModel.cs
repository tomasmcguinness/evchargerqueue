namespace EVChargerQueue.Web.API.Models
{
    public class ChargingPointSummaryViewModel
    {
        public ChargingPointSummaryViewModel(int chargePointId, int networkId)
        {
            Id = chargePointId;
            NetworkId = networkId;
        }

        public int Id { get; set; }

        public int NetworkId { get; }
    }
}
