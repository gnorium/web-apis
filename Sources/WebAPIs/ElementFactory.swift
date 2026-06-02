import WebTypes
#if CLIENT
  import EmbeddedSwiftUtilities
  import HTMLBuilder
  import DOMBuilder

  internal struct ElementFactory {
    /// Creates the appropriate DOM.Element subclass based on the DOM tag name
    internal static func create(id: Int32) -> DOM.Element {
      var buffer = [UInt8](repeating: 0, count: 64)
      let len = element_getTagName(id, &buffer, 64)
      if len > 0 {
        let tagName = String(decoding: buffer[0..<Int(len)], as: UTF8.self)

        if stringEquals(tagName, "INPUT") {
          return HTML.HTMLInputElement(id: id)
        } else if stringEquals(tagName, "TEXTAREA") {
          return HTML.HTMLTextAreaElement(id: id)
        } else if stringEquals(tagName, "SELECT") {
          return HTML.HTMLSelectElement(id: id)
        } else if stringEquals(tagName, "BUTTON") {
          return HTML.HTMLButtonElement(id: id)
        } else if stringEquals(tagName, "OPTION") {
          return HTML.HTMLOptionElement(id: id)
        } else {
          return HTML.HTMLElement(id: id)
        }
      }

      // Fallback if tag name query fails
      return HTML.HTMLElement(id: id)
    }
  }
#endif
