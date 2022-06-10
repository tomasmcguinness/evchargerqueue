using EVChargerQueue.Web.API.Models;
using Microsoft.AspNetCore.Mvc;

namespace EVChargerQueue.Web.API.Controllers
{
    [ApiController]
    [Route("api/v1/chargingpoints")]
    public class ChargingPointsController : Controller
    {
        [HttpPost]
        [Route("")]
        public IActionResult Search(double longitude, double latitude)
        {
            List<ChargingPointSummaryViewModel> chargingPoints = new List<ChargingPointSummaryViewModel>();

            chargingPoints.Add(new ChargingPointSummaryViewModel(1, 1));
            chargingPoints.Add(new ChargingPointSummaryViewModel(2, 2));
            chargingPoints.Add(new ChargingPointSummaryViewModel(3, 3));


            return Ok(chargingPoints);
        }

        [HttpGet]
        [Route("{id:int}")]
        public IActionResult Details(int id)
        {
            ChargingPointViewModel chargingPoint = new ChargingPointViewModel();
            return Ok(chargingPoint);
        }
    }
}
