import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["flashBody"]

  connect() {
    setTimeout(() => {
      this.destroyElement()
    }, 3000)
  }

  destroyElement() {
    const element = this.flashBodyTarget

    element.classList.add("flash--hide")
    element.addEventListener("transitionend", function () {
      element.parentNode.removeChild(element)
    })
  }
}
