var ConfirmPlaceController = new Class({
	initialize: function(confirmPlaceStep, confirmPlacePlace) {
		this.confirmPlaceStep = confirmPlaceStep
		this.confirmPlacePlace = confirmPlacePlace
	},

	show: function() {
		this.confirmPlaceStep.removeClass("hidden")
	},

	hide: function() {
		this.confirmPlaceStep.addClass("hidden")
	},

	updateAndShow: function(placeName) {
		this.confirmPlacePlace.set("html", placeName)
		this.show()
	}
})