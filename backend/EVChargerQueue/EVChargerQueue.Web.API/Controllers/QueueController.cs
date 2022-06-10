using Microsoft.AspNetCore.Mvc;

namespace EVChargerQueue.Web.API.Controllers
{
    [Route("queues")]
    public class QueuesController : Controller
    {
        [HttpPost]
        [Route("/")]
        public IActionResult Get(int chargerPointId)
        {
            return View();
        }
    }
}
