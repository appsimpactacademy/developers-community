import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="disable-end-date-for-event"
export default class extends Controller {
  connect() {
    console.log('Disable end date for event')
    this.disableEndDateAndTimeForEvent()
  }
  
  initialize() {
    this.element.setAttribute("data-action", "click->disable-end-date-for-event#disableEndDateAndTimeForEvent")
  }

  disableEndDateAndTimeForEvent(){
    const endDateElement = document.getElementById('event_end_date')
    const endTimeElement = document.getElementById('event_end_time')
    if(this.element.checked) {
      endDateElement.value = null
      endTimeElement.value = null
      endDateElement.setAttribute("disabled", true)
      endTimeElement.setAttribute("disabled", true)
    } else {
      endDateElement.removeAttribute("disabled")
      endTimeElement.removeAttribute("disabled")
    }
  }
}
