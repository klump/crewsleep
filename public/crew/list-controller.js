// Date.prototype.setISO8601 = function (string) {
//     var regexp = "([0-9]{4})(-([0-9]{2})(-([0-9]{2})" +
//         "(T([0-9]{2}):([0-9]{2})(:([0-9]{2})(\.([0-9]+))?)?" +
//         "(Z|(([-+])([0-9]{2}):([0-9]{2})))?)?)?)?";
//     var d = string.match(new RegExp(regexp));
// 
//     var offset = 0;
//     var date = new Date(d[1], 0, 1);
// 
//     if (d[3]) { date.setMonth(d[3] - 1); }
//     if (d[5]) { date.setDate(d[5]); }
//     if (d[7]) { date.setHours(d[7]); }
//     if (d[8]) { date.setMinutes(d[8]); }
//     if (d[10]) { date.setSeconds(d[10]); }
//     if (d[12]) { date.setMilliseconds(Number("0." + d[12]) * 1000); }
//     if (d[14]) {
//         offset = (Number(d[16]) * 60) + Number(d[17]);
//         offset *= ((d[15] == '-') ? 1 : -1);
//     }
// 
//     offset -= date.getTimezoneOffset();
//     time = (Number(date) + (offset * 60 * 1000));
//     this.setTime(Number(time));
// }

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
		  var t = new Date()
		  t.setTime(Date.parse(time["time"]))
		  var d = ["Sunday", "Monday", "Tuesday", "Wednesday", "Tusday", "Friday", "Saturday"][t.getDay()]
		  var h = t.getHours()
		  if(h < 10) h = "0"+h
		  var m = t.getMinutes()
		  if(m < 10) m = "0" + m
			var timeHeader = new Element("h2", {
				html: d + " " + h + ":" + m
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