var ApplicationController = new Class({
	initialize: function(lampController, pictureFrameController, personController, placeController, alarmController, confirmPlaceController, confirmAlarmController) {
		this.lampController = lampController
		this.pictureFrameController = pictureFrameController
		this.personController = personController
		this.placeController = placeController
		this.alarmController = alarmController
		this.confirmPlaceController = confirmPlaceController
		this.confirmAlarmController = confirmAlarmController
		
		this.currentPerson = null
		
		this.personController.personSelectedCallback = this.personSelected.bind(this)
		
		this.placeController.bookedAndQuitCallback = this.placeBookedAndQuit.bind(this)
		this.placeController.bookedAndContinueCallback = this.placeBookedAndContinue.bind(this)
		
		this.alarmController.changePlaceCallback = this.alarmWentChangePlace.bind(this)
		this.alarmController.cancelCallback = this.alarmExit.bind(this)
		this.alarmController.alarmSetCallback = this.alarmSet.bind(this)
		
		this.initialState()
	},
	
	initialState: function() {
		this.currentPerson = null
		this.pictureFrameController.hide()
		this.personController.show()
		this.lampController.on()
	},
	
	placeBookedAndQuit: function(placeName) {
		this.placeController.hide()
		this.confirmPlaceController.updateAndShow(placeName)
		setTimeout(function() {
			this.confirmPlaceController.hide()
			this.initialState()
		}.bind(this), 5000)
	},
	
	placeBookedAndContinue: function() {
		this.placeController.hide()
		this.alarmController.updateAndShow(this.currentPerson)
	},
	
	personSelected: function(person) {
		this.currentPerson = person
		this.pictureFrameController.updateAndShow(this.currentPerson.avatar_url)
		this.personController.hide()
		
		if (this.currentPerson.place == null) {
			this.placeController.updateAndShow(this.currentPerson)
		} else {
			this.alarmController.updateAndShow(this.currentPerson)
		}
	},
	
	alarmWentChangePlace: function() {
		this.alarmController.hide()
		this.placeController.updateAndShow(this.currentPerson)
	},
	
	alarmExit: function() {
		this.alarmController.hide()
		this.initialState()
	},

	alarmSet: function(placeName, timeString) {
		this.alarmController.hide()
		this.lampController.off()
		this.confirmAlarmController.updateAndShow(placeName, timeString)
		setTimeout(function() {
			this.confirmAlarmController.hide()
			this.initialState()
		}.bind(this), 5000)
	}
})