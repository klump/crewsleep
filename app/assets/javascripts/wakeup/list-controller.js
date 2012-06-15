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

		this.activeAlarmsRequest = new Request.JSON({
			url: "/api/alarms/active",
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
		this.alarmList.empty()
		activeAlarms.each(function(time) {
		  var t = new Date()
		  t.setTime(Date.parse(time["time"]))
		  var d = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"][t.getDay()]
		  var h = t.getHours()
		  if(h < 10) h = "0"+h
		  var m = t.getMinutes()
		  if(m < 10) m = "0" + m
			var timeHeader = new Element("h2", {
				html: d + " " + h + ":" + m
			})
			timeHeader.inject(this.alarmList)

			for (var i = 0; i < time["sections"].length; i++) {

        var section = time["sections"][i]
				var sectionHeader = new Element("h3", {
					html: section["name"]
				})
				sectionHeader.inject(this.alarmList)

				var listElement = new Element("ul")
				listElement.inject(this.alarmList)

				section["alarms"].each(function(alarm) {
          itemHtml  = "<span class=\"place\">"+alarm.row_index+"-"+alarm.place_index+"</span> "+alarm.person_username
          itemHtml += "<span class=\"actions\">"
          itemHtml += "<a class=\"button poke-button\"><span class=\"extra\">Poke (</span>"+alarm.poked+"<span class=\"extra\">)</span></a> "
          itemHtml += "<a class=\"button delete-button\"><span class=\"extra\">Ta bort</span> <span class=\"minimal\">x</span></a>"
          itemHtml += "</span>"
					var alarmItem = new Element("li")
          alarmItem.set("html", itemHtml)
					alarmItem.inject(listElement)

					alarmItem.getElement(".poke-button").addEvent("click", function() {
            new Request({
              url: "/api/alarms/"+alarm._id+"/poke",
              onSuccess: this.update.bind(this)
            }).post()
					}.bind(this))

					alarmItem.getElement("delete-button").addEvent("click", function() {
            new Request({
              url: "/api/alarms/"+alarm._id,
              onSuccess: this.update.bind(this)
            }).delete()
					}.bind(this))
				}, this)
			}
		}, this)
	}
})