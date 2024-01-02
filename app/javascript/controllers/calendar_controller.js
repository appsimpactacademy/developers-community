import { Controller } from "@hotwired/stimulus";
import { Calendar } from "@fullcalendar/core";
import dayGridPlugin from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";

export default class extends Controller {
  connect() {
    this.initializeCalendar();
  }

  initializeCalendar() {
    const calendarEl = this.element;
    const calendar = new Calendar(calendarEl, {
      plugins: [dayGridPlugin, timeGridPlugin],
      eventDisplay: 'block',
      eventOverlap: true,
      initialView: 'dayGridMonth',
      headerToolbar: {
        left: 'prev,next today',
        center: 'title',
        right: 'dayGridMonth,timeGridWeek,timeGridDay'
      },
      eventClick: (info) => this.handleEventClick(info),
      selectable: true,
      events: (info, successCallback, failureCallback) => this.loadEvents(info, successCallback, failureCallback)
    });

    calendar.render();
    console.log("calendar++");

	  calendarEl.addEventListener('click', async (ev) => {
	    const isValidClick = this.isValidCalendarClick(ev.target);
		  if (isValidClick) {
		    const dateString = this.getClickedDate(ev.target);
		    const formattedDate = this.formatClickedDate(dateString);

		    if (formattedDate) {
		      const isValidDate = this.validateDate(formattedDate);
		      if (!isValidDate) {
		        alert('Cannot create events in the past!');
		        return;
		      }

		      // Open Bootstrap modal
		      $('#eventModal').modal('show');

		      // Handle Save button click in the modal
		      document.getElementById('saveEvent').addEventListener('click', async () => {
		        const eventData = this.getEventDataFromForm(); // Implement this function to get form data
		        if (!eventData) return;

		        try {
		          const response = await this.createEvent('/events', eventData);
		          if (response.ok) {
		            const createdEvent = await response.json();
		            console.log('Event created:', createdEvent);
		            await this.updateCalendarEvents(calendar);
		            $('#eventModal').modal('hide'); // Close modal after successful event creation
		            // You might add the created event to the calendar UI here
		          } else {
		            console.error('Failed to create event:', response.status);
		            // Handle the error response if needed
		          }
		        } catch (error) {
		          console.error('Error creating event:', error);
		          // Handle any network-related errors
		        }
		      });
		    }
		  }
		});
  }

  isValidCalendarClick(target) {
    return (
      target.classList.contains('fc-daygrid-day-frame') ||
      target.classList.contains('fc-daygrid-day-top') ||
      target.classList.contains('fc-daygrid-day-events') ||
      target.classList.contains('fc-daygrid-day-bottom')
    );
  }

  getClickedDate(target) {
    const aElement = target.closest('.fc-daygrid-day-frame')?.querySelector('a.fc-daygrid-day-number');
    return aElement ? aElement.getAttribute('aria-label') : null;
  }

  formatClickedDate(dateString) {
    const dateObj = new Date(dateString);
    const year = dateObj.getFullYear();
    const month = (dateObj.getMonth() + 1).toString().padStart(2, '0');
    const day = dateObj.getDate().toString().padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  validateDate(clickedDate) {
    const today = new Date().toISOString().split('T')[0];
    return clickedDate >= today;
  }

  getEventDataFromForm() {
	  const eventName = document.getElementById('eventName').value.trim();
	  const eventType = document.getElementById('eventType').value.trim();
	  const startDate = document.getElementById('startDate').value;
	  const startTime = document.getElementById('startTime').value;
	  const endDate = document.getElementById('endDate').value;
	  const endTime = document.getElementById('endTime').value;
	  const eventDescription = document.getElementById('eventDescription').value.trim();

	  // Validate if required fields are not empty
	  if (!eventName || !eventType || !startDate || !startTime || !endDate || !endTime || !eventDescription) {
	  	document.querySelector('.event-error').textContent = 'Please fill in all fields.';
	    return null;
	  }

	  return {
	    event_name: eventName,
	    event_type: eventType,
	    start_date: startDate,
	    end_date: endDate,
	    start_time: startTime,
	    end_time: endTime,
	    description: eventDescription
	  };
	}

  async createEvent(url, eventData) {
    try {
      return await fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify({ event: eventData })
      });
    } catch (error) {
      throw new Error('Error creating event:', error);
    }
  }

  async updateCalendarEvents(calendar) {
    try {
      const updatedEventsResponse = await fetch("/events/calendar.json");
      const updatedEventsData = await updatedEventsResponse.json();
      calendar.refetchEvents();
    } catch (error) {
      console.error('Error updating calendar events:', error);
    }
  }

  loadEvents(info, successCallback, failureCallback) {
    fetch("/events/calendar.json")
      .then((response) => {
        if (!response.ok) {
          throw new Error(`Network response was not ok. Status: ${response.status}`);
        }
        return response.json();
      })
      .then((data) => {
        successCallback(data);
      })
      .catch((error) => {
        console.error('Error fetching events:', error);
        failureCallback(error);
      });
  }

  handleEventClick(info) {
    if (info.event && info.event._def.publicId) {
      const eventId = info.event._def.publicId;
      window.location.href = `/events/${eventId}`;
    }
  }
}
