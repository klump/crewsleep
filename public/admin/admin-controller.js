var AdminController = new Class({
    initialize: function(containerElement, addSectionLink) {
        this.containerElement = containerElement
        this.addSectionLink = addSectionLink
        this.sections = new Array()

        this.addSectionLink.addEvent("click", function(event) {
            event.preventDefault()
            this.addSection()
        }.bind(this))
    },

    addSection: function(section) {
        sectionElement = new Element("article", {
            "class": "section"
        })
        this.sections.push(new SectionController(sectionElement, this.sections.length, section))
        sectionElement.inject(this.containerElement)
    }
})