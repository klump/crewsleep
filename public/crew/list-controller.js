var ListController = new Class({
	initialize: function(listView, alarmList) {
		this.listView = listView
		this.alarmList = alarmList

		this.pokeRequest = new Request({
			url: "/api/v1/poke",
			onSuccess: this.update.bind(this)
		})
		this.deleteAlarmRequest = new Request({
			url: "/api/v1/delete_alarm",
			onSuccess: this.update.bind(this)
		})
		this.activeAlarmsRequest = new Request.JSON({
			url: "/api/v1/fetch_active_alarms",
			onSuccess: this.handleActiveAlarmsResponse.bind(this),
			onFailure: this.handleActiveAlarmsFailure.bind(this)
		})
		this.activeAlarmsRequest.get()
	},

	update: function() {
		this.activeAlarmsRequest.get()
	},

	handleActiveAlarmsResponse: function(response) {
		this.renderActiveAlarms(response)
	},

	handleActiveAlarmsFailure: function() {

	},

	renderActiveAlarms: function(activeAlarms) {
		console.log(activeAlarms)
		this.alarmList.empty()
		activeAlarms.each(function(time) {
			var timeHeader = new Element("h2", {
				html: time["time"]
			})
			timeHeader.inject(this.alarmList)

			for (var section in time["sections"]) {
				var sectionHeader = new Element("h3", {
					html: section
				})
				sectionHeader.inject(this.alarmList)

				var listElement = new Element("ul")
				listElement.inject(this.alarmList)

				time["sections"][section].each(function(alarm) {
					var alarmItem = new Element("li")
					alarmItem.inject(listElement)

					var timeSpan = new Element("span", {
						html: alarm.place_name,
						"class": "place"
					})
					timeSpan.inject(alarmItem)
					alarmItem.appendText(" "+alarm.person.username)

					actionsSpan = new Element("span", {
						"class": "actions"
					})
					actionsSpan.inject(alarmItem)

					actionsSpan.appendText(alarm.poked+" pokes ")

					pokeButton = new Element("input", {
						type: "button",
						value: "Poke!"
					})
					pokeButton.addEvent("click", function() {
						this.pokeRequest.post({ alarm: alarm._id})
					}.bind(this))
					pokeButton.inject(actionsSpan)

					deleteButton = new Element("input", {
						type: "button",
						value: "Ta bort"
					})
					deleteButton.addEvent("click", function() {
						this.deleteAlarmRequest.post({ alarm: alarm._id})
					}.bind(this))
					deleteButton.inject(actionsSpan)
				}, this)
			}
		}, this)
	}
})