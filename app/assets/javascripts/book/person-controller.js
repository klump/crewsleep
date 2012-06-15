/**
 * Person controller
 */
var PersonController = new Class({
    initialize: function(personStep, personForm) {
    	this.personStep = personStep
        this.personForm = personForm
        this.personSelectedCallback = null

        this.personForm.addEvent("submit", this.formSubmitted.bind(this))

        this.personRequest = new Request.JSON({
            url: this.personForm.get("action"),
            onSuccess: this.handleResponse.bind(this),
            onFailure: this.handleFailure.bind(this)
        })
    },
    
    setup: function() {
    	this.personForm.elements["q"].set("value", "")
    },
    
    show: function() {
    	this.setup()
    	this.personStep.removeClass("hidden")
    	this.personForm.elements["q"].focus()
    },
    
    hide: function() {
    	this.personStep.addClass("hidden")
    },

    formSubmitted: function(event) {
        event.preventDefault()
        this.personRequest.get("q="+this.personForm.elements["q"].get("value"))
    },

    handleResponse: function(response) {
        if (this.personSelectedCallback != null) {
        	this.personSelectedCallback(response)
        }
    },

    handleFailure: function() {
    }
})