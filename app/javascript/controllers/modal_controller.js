import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  connect() {
    this.boundCloseOnEscape = this.closeOnEscape.bind(this)
    document.addEventListener("keydown", this.boundCloseOnEscape)
  }

  disconnect() {
    document.removeEventListener("keydown", this.boundCloseOnEscape)
  }

  close() {
    // Remove the modal from the DOM
    this.element.parentElement.removeAttribute("src") // Remove src from the turbo-frame
    this.element.remove()
  }

  closeOnEscape(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }

  // Allow closing the modal by clicking on the background overlay.
  closeWithBackground(event) {
    if (event.target === this.element) {
      this.close()
    }
  }
}
