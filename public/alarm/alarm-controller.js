var AlarmController = new Class({
	initialize: function(alarmStep, alarmPlace, alarmForm, alarmExisting, alarmRemaining, changePlaceButton, cancelButton, setButton) {
		this.alarmStep = alarmStep
		this.alarmPlace = alarmPlace
		this.alarmForm = alarmForm
		this.alarmExisting = alarmExisting
		this.alarmRemaining = alarmRemaining
		this.changePlaceButton = changePlaceButton
		this.cancelButton = cancelButton
		this.setButton = setButton
		
		this.changePlaceCallback = null
		this.cancelCallback = null
		this.alarmSetCallback = null
		
		this.person = null
		this.placeInfo = null
		this.alarmTime = null
		
		this.alarmForm.addEvent("submit", function(event) { event.preventDefault() })
		this.changePlaceButton.addEvent("click", this.changePlace.bind(this))
		this.cancelButton.addEvent("click", this.cancel.bind(this))
		this.setButton.addEvent("click", this.setAlarm.bind(this))
		this.alarmForm["hour"].addEvent("change", this.updateTime.bind(this))
		this.alarmForm["minute"].addEvent("change", this.updateTime.bind(this))
		
		this.placeInfoRequest = new Request.JSON({
			url: "/api/v1/fetch_place_info",
			onSuccess: this.handlePlaceInfoResponse.bind(this),
			onFailure: this.handlePlaceInfoFailure.bind(this)
		})
		this.setAlarmRequest = new Request({
			url: this.alarmForm.get("action"),
			onSuccess: this.handleSetAlarmResponse.bind(this),
			onFailure: this.handleSetAlarmFailure.bind(this)
		})
	},
	
	// Control logic
	
	setup: function() {
		this.alarmPlace.set("html", this.placeInfo.name)
		
		this.renderTimeDropdowns()
		this.renderExistingAlarms()
	},
	
	setAlarm: function(event) {
		this.setAlarmRequest.post("person="+this.person._id+"&time="+this.alarmTime)
	},
	
	changePlace: function(event) {
		event.preventDefault()
		if (this.changePlaceCallback != null) {
			this.changePlaceCallback()
		}
	},
	
	cancel: function(event) {
		event.preventDefault()
		if (this.cancelCallback != null) {
			this.cancelCallback()
		}
	},
	
	updateTime: function() {
		var hour = this.alarmForm["hour"].get("value")
		var minute = this.alarmForm["minute"].get("value")
		var date = new Date()
		if (date.getHours() > hour) {
			date = new Date(date.getTime()+(24*60*60*1000))
		}
		date.setHours(hour)
		date.setMinutes(minute)
		date.setSeconds(0)
		this.alarmTime = date
		this.alarmRemaining.set("html", this.timeRemainingString(this.alarmTime))
	},
	
	handleSetAlarmResponse: function(response) {
		
	},
	
	handleSetAlarmFailure: function() {
		if (this.alarmSetCallback != null) {
			this.alarmSetCallback()
		}
	},
	
	handlePlaceInfoResponse: function(response) {
		this.placeInfo = response
		this.setup()
		this.show()
	},
	
	handlePlaceInfoFailure: function() {
	
	},
	
	// Support logic
	
	timeRemainingString: function(then) {
		var delta = then.getTime()-new Date().getTime()
		var hours = Math.floor(delta/(1000*60*60))
		var minutes = Math.floor((delta % (1000*60*60))/(1000*60))
		var string = "Om "
		if (hours > 0) {
			string += hours + " tim "
		}
		string += minutes + " min"
		return string
	},
	
	// View controlling
	
	show: function() {
		this.alarmStep.removeClass("hidden")
	},
	
	hide: function() {
		this.alarmStep.addClass("hidden")
	},
	
	updateAndShow: function(person) {
		this.person = person
		this.placeInfoRequest.get("place="+person.place._id)
	},
	
	// View logic
	
	renderTimeDropdowns: function() {
		var hourSelect = this.alarmForm["hour"]
		hourSelect.empty()
		hour = new Date().getHours()
		recommendedHour = hour+7
		for (i=0; i<14; i++) {
			var option = new Element("option", {
				value: hour,
				html: hour
			})
			if (hour == recommendedHour) {
				option.set("selected", "selected")
			}
			option.inject(hourSelect)
			hour++
		}
		
		var minuteSelect = this.alarmForm["minute"]
		minuteSelect.empty()
		this.placeInfo.valid_minutes.each(function(minute) {
			var option = new Element("option", {
				value: minute,
				html: minute
			})
			option.inject(minuteSelect)
		})
		
		this.updateTime()
	},
	
	renderExistingAlarms: function() {
		this.alarmExisting.empty()
		this.person.alarms.each(function(alarm) {
			var time = parseISO8601(alarm.time)
			
			var alarmParagraph = new Element("p")
			
			var timeSpan = new Element("span", {
				"class": "time",
				html: time.getHours()+":"+time.getMinutes()
			})
			timeSpan.inject(alarmParagraph)
			
			var remainingSpan = new Element("span", {
				"class": "remaining",
				html: this.timeRemainingString(time)
			})
			remainingSpan.inject(alarmParagraph)
			
			var removeLink = new Element("a", {
				href: "#",
				"class": "remove",
				html: "Ta bort"
			})
			removeLink.inject(alarmParagraph)
			
			alarmParagraph.inject(this.alarmExisting)
		}, this)
		this.alarmExisting.removeClass("hidden")
	}
})

function parseISO8601(str) {
 // we assume str is a UTC date ending in 'Z'

 var parts = str.split('T'),
 dateParts = parts[0].split('-'),
 timeParts = parts[1].split('+'),
 timeSubParts = timeParts[0].split(':'),
 timeSecParts = timeSubParts[2].split('.'),
 timezoneParts = timeSubParts[1].split(":"),
 timezone = timezoneParts[0],
 timeHours = Number(timeSubParts[0]),
 _date = new Date;

 _date.setUTCFullYear(Number(dateParts[0]));
 _date.setUTCMonth(Number(dateParts[1])-1);
 _date.setUTCDate(Number(dateParts[2]));
 _date.setUTCHours(Number(timeHours));
 _date.setUTCMinutes(Number(timeSubParts[1]));
 _date.setUTCSeconds(Number(timeSecParts[0]));
 if (timeSecParts[1]) _date.setUTCMilliseconds(Number(timeSecParts[1]));

 // by using setUTC methods the date has already been converted to local time(?)
 return new Date(_date.getTime()-(timezone*60*60*100));
}