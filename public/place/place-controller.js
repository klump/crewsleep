var PlaceController = new Class({
	initialize: function(placeStep, placeNickname, placeForm, placeSections, placeRows, placePlaces, placeButtons, bookAndQuitButton, bookAndContinueButton, cancelButton) {
		this.placeStep = placeStep
		this.placeNickname = placeNickname
		this.placeForm = placeForm
		this.placeSections = placeSections
		this.placeRows = placeRows
		this.placePlaces = placePlaces
		this.placeButtons = placeButtons
		this.bookAndQuitButton = bookAndQuitButton
		this.bookAndContinueButton = bookAndContinueButton
		this.cancelButton = cancelButton
		
		this.person = null
		this.places = null
		this.bookedAndQuitCallback = null
		this.bookedAndContinueCallback = null
		this.cancelCallback = null
		this.shouldContinue = null
		
		this.bookAndQuitButton.addEvent("click", this.bookAndQuit.bind(this))
		this.bookAndContinueButton.addEvent("click", this.bookAndContinue.bind(this))
		this.placeForm.addEvent("submit", function(event) { event.preventDefault() })
		this.cancelButton.addEvent("click", this.cancel.bind(this))
		
		this.placesRequest = new Request.JSON({
			url: "/api/v1/fetch_places",
			onSuccess: this.handlePlacesResponse.bind(this),
			onFailure: this.handlePlacesFailure.bind(this)
			
		})
		this.bookRequest = new Request({
		    url: this.placeForm.get("action"),
		    onSuccess: this.handleBookResponse.bind(this),
		    onFailure: this.handleBookFailure.bind(this)
		})
		
	},
	
	
	// Control logic
	
	cancel: function(event) {
	  event.preventDefault()
	  this.shouldContinue = false
	  this.cancelCallback()
	},
	
	bookAndQuit: function(event) {
		event.preventDefault()
		this.shouldContinue = false
		this.bookPlace()
	},
	
	bookAndContinue: function(event) {
		event.preventDefault()
		this.shouldContinue = true
		this.bookPlace()
	},
	
	bookPlace: function() {
		this.bookRequest.post(
			"person="+this.person._id+
			"&section="+this.placeSections.getElement(":checked").get("value")+
			"&row="+this.placeRows.getElement(":checked").get("value")+
			"&place="+this.placePlaces.getElement(":checked").get("value")
		)
	},
	
	handlePlacesResponse: function(response) {
		this.places = response
		this.showSections()
	},
	
	handlePlacesFailure: function() {
	
	},
	
	handleBookResponse: function(response) {
		this.person.place = this.selectedPlace()
		if (this.shouldContinue) {
			if (this.bookedAndContinueCallback != null) {
				this.bookedAndContinueCallback()
			}
		} else {
			if (this.bookedAndQuitCallback != null) {
				this.bookedAndQuitCallback(this.selectedSection.name+" "+this.selectedRow().index+"-"+this.selectedPlace().index)
			}
		}
	},
	
	handleBookFailure: function() {
	
	},
	
	
	// Basic view controlling
	
	setup: function() {
		this.placeNickname.set("html", this.person.username)
		this.placesRequest.get()
	},
	
	show: function() {
		this.setup()
		this.hideSections()
		this.hideRows()
		this.hidePlaces()
		this.hideButtons()
		this.placeStep.removeClass("hidden")
	},
	
	hide: function() {
		this.placeStep.addClass("hidden")
	},
	
	showSections: function() {
		this.renderSections()
		this.placeSections.removeClass("hidden")
		this.hideRows()
		this.hidePlaces()
		this.hideButtons()
	},
	
	hideSections: function() {
		this.placeSections.addClass("hidden")
	},
	
	showRows: function() {
		this.renderRows()
		this.placeRows.removeClass("hidden")
		this.hidePlaces();
		this.hideButtons()
	},
	
	hideRows: function() {
		this.placeRows.addClass("hidden")
	},
	
	showPlaces: function() {
		this.renderPlaces()
		this.placePlaces.removeClass("hidden")
		this.hideButtons()
	},
	
	hidePlaces: function() {
		this.placePlaces.addClass("hidden")
	},
	
	updateAndShow: function(person) {
		this.person = person
		this.show()
	},
	
	showButtons: function() {
		this.placeButtons.removeClass("hidden")
	},
	
	hideButtons: function() {
		this.placeButtons.addClass("hidden")
	},
	
	
	// DOM generation logic
	
	renderSections: function() {
		var sectionChoices = this.placeSections.getElement(".choices")
		sectionChoices.empty()
		this.places.each(function(section) {
			sectionLabel = new Element("label")
			
			radioInput = new Element("input", {
				type: "radio",
				name: "section",
				value: section._id
			})
			radioInput.addEvent("click", this.showRows.bind(this))
			radioInput.inject(sectionLabel)
			
			spanLabel = new Element("span")
			spanLabel.appendText(section.name)
			spanLabel.inject(sectionLabel)
			
			sectionLabel.appendText(" ")
			sectionLabel.inject(sectionChoices)
		}, this)
	},
	
	renderRows: function() {
		var rowChoices = this.placeRows.getElement(".choices")
		rowChoices.empty()
		this.selectedSection().rows.each(function(row) {
			rowLabel = new Element("label")
			
			radioInput = new Element("input", {
				type: "radio",
				name: "row",
				value: row._id
			})
			radioInput.addEvent("click", this.showPlaces.bind(this))
			radioInput.inject(rowLabel)
			
			spanLabel = new Element("span")
			spanLabel.appendText(row.index)
			spanLabel.inject(rowLabel)
			
			rowLabel.appendText(" ")
			rowLabel.inject(rowChoices)
		}, this)
		rowChoices.appendText(" ") // Works around a rendering bug in Safari (possibly WebKit)
	},
	
	renderPlaces: function() {
		var placeChoices = this.placePlaces.getElement(".choices")
		placeChoices.empty()
		this.selectedRow().places.each(function(place, index) {
			placeLabel = new Element("label")
			
			radioInput = new Element("input", {
				type: "radio",
				name: "place",
				value: place._id
			})
			radioInput.addEvent("click", this.showButtons.bind(this))
			radioInput.inject(placeLabel)
			
			spanLabel = new Element("span")
			spanLabel.appendText(place.index)
			spanLabel.inject(placeLabel)
			
			if (index != 0 && index % 10 == 0) {
				new Element("br").inject(placeChoices)
			} else {
				placeLabel.appendText(" ")
			}
			placeLabel.inject(placeChoices)
		}, this)
		placeChoices.appendText(" ") // Works around a rendering bug in Safari (possibly WebKit)
	},
	
	selectedSection: function() {
		var selectedSectionId = this.placeSections.getElement(":checked").get("value")
		var selectedSection = null
		this.places.each(function(section) {
			if (section._id == selectedSectionId) {
				selectedSection = section
			}
		})
		return selectedSection
	},
	
	selectedRow: function() {
		var selectedRowId = this.placeRows.getElement(":checked").get("value")
		var selectedRow = null
		this.selectedSection().rows.each(function(row) {
			if (row._id == selectedRowId) {
				selectedRow = row
			}
		})
		return selectedRow
	},
	
	selectedPlace: function() {
		var selectedPlaceId = this.placePlaces.getElement(":checked").get("value")
		var selectedPlace = null
		this.selectedRow().places.each(function(place) {
			if (place._id == selectedPlaceId) {
				selectedPlace = place
			}
		})
		return selectedPlace
	}
})