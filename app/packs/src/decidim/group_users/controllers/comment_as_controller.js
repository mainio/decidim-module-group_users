import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "menu", "option"]

  connect() {
    this.initializeSelection()
  }

  initializeSelection() {
    const firstOption = this.optionTargets[0]
    if (!firstOption) { 
      return
    }

    const authorInfo = firstOption.querySelector(".comment__as-author-info")
    if (!authorInfo) { 
      return
    }

    this.displayTarget.innerHTML = authorInfo.innerHTML
    firstOption.style.display = "none"
  }

  select(event) {
    const clickedOption = event.currentTarget
    const radio = clickedOption.querySelector("input[type='radio']")
    if (!radio) { 
      return
    }

    radio.checked = true

    const authorInfo = clickedOption.querySelector(".comment__as-author-info")
    if (!authorInfo) { 
      return
    }

    this.displayTarget.innerHTML = authorInfo.innerHTML

    this.optionTargets.forEach((option) => {
      option.style.display = option === clickedOption 
        ? "none" 
        : "";
    })
  }
}
