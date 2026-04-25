#if CLIENT
  import EmbeddedSwiftUtilities
  import HTMLBuilder
  import DOMBuilder

  internal struct ElementFactory {
    /// Creates the appropriate Element subclass based on the DOM tag name
    internal static func create(id: Int32) -> Element {
      var buffer = [UInt8](repeating: 0, count: 64)
      let len = element_getTagName(id, &buffer, 64)
      if len > 0 {
        let tagName = String(decoding: buffer[0..<Int(len)], as: UTF8.self)

        if stringEquals(tagName, "INPUT") {
          return HTMLInputElement(id: id)
        } else if stringEquals(tagName, "TEXTAREA") {
          return HTMLTextAreaElement(id: id)
        } else if stringEquals(tagName, "SELECT") {
          return HTMLSelectElement(id: id)
        } else if stringEquals(tagName, "BUTTON") {
          return HTMLButtonElement(id: id)
        } else if stringEquals(tagName, "OPTION") {
          return HTMLOptionElement(id: id)
        } else {
          return HTMLElement(id: id)
        }
      }

      // Fallback if tag name query fails
      return HTMLElement(id: id)
    }
  }
#endif
