var ConfirmAlarmController = new Class({
	initialize: function(confirmAlarmStep, confirmAlarmPlace, confirmAlarmTime) {
		this.confirmAlarmStep = confirmAlarmStep
		this.confirmAlarmPlace = confirmAlarmPlace
		this.confirmAlarmTime = confirmAlarmTime
	},

	show: function() {
		this.confirmAlarmStep.removeClass("hidden")
	},

	hide: function() {
		this.confirmAlarmStep.addClass("hidden")
	},

	updateAndShow: function(placeName, timeString) {
		this.confirmAlarmPlace.set("html", placeName)
		this.confirmAlarmTime.set("html", timeString)
		this.show()
	}
})