import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    // Close modal on Escape key press
    this.closeOnEscape = (e) => {
      if (e.key === "Escape" && !this.containerTarget.classList.contains("hidden")) {
        this.close(e)
      }
    }
    document.addEventListener("keydown", this.closeOnEscape)
  }

  disconnect() {
    document.removeEventListener("keydown", this.closeOnEscape)
  }

  open(e) {
    if (e) e.preventDefault()
    this.containerTarget.classList.remove("hidden")
    // Focus first input if possible
    const input = this.containerTarget.querySelector("input:not([type='hidden']), textarea")
    if (input) input.focus()
  }

  close(e) {
    if (e) e.preventDefault()
    this.containerTarget.classList.add("hidden")
  }

  // Close if clicked outside the content (on the background)
  closeBackground(e) {
    if (e.target === this.containerTarget) {
      this.close(e)
    }
  }
}
