var SectionController = new Class({
    initialize: function(sectionElement, index, section) {
        this.index = index
        this.section = section
        this.sectionElement = sectionElement
        this.rowContainer = null
        this.rowCount = 0

        this.setupView()
    },

    setupView: function() {
        labelElement = new Element("label", {
            html: "Namn "
        })
        labelElement.inject(this.sectionElement)

        fieldElement = new Element("input", {
            type: "text",
            name: "places["+this.index+"][name]"
        })
        fieldElement.inject(labelElement)
        
        validMinutesLabel = new Element("label", {
        	html: "Tillåtna minutslag för väckningar (kommaseparerat): "
        })
        validMinutesLabel.inject(this.sectionElement)
        
        validMinutesField = new Element("input", {
        	type: "text",
        	name: "places["+this.index+"][valid_minutes]"
        })
        validMinutesField.inject(this.sectionElement)

        this.rowContainer = new Element("div")
        this.rowContainer.inject(this.sectionElement)

        addRowContainer = new Element("aside")
        addRowContainer.inject(this.sectionElement)

        addRowLink = new Element("a", {
            href: "#",
            html: "Lägg till rad"
        })
        addRowLink.addEvent("click", function(event) {
            event.preventDefault()
            this.addRow()
        }.bind(this))
        addRowLink.inject(addRowContainer)
    },

    addRow: function() {
        this.rowCount++

        rowContainer = new Element("article", {
            'class': "row"
        })
        rowContainer.inject(this.rowContainer)

        rowIndexElement = new Element("span", {
            html: this.rowCount
        })
        rowIndexElement.inject(rowContainer)

        labelElement = new Element("label", {
            html: "Antal platser "
        })
        labelElement.inject(rowContainer)

        fieldElement = new Element("input", {
            type: "text",
            name: "places["+this.index+"][rows]["+this.rowCount+"]"
        })
        fieldElement.inject(rowContainer)
    }
})