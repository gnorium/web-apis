#if CLIENT
  import CSSBuilder
  import DOMBuilder
  import EmbeddedSwiftUtilities
  import HTMLBuilder
  import WebTypes

  extension DOM.Element: EventTargeting {
    public var style: CSSStyleProperties {
      return CSSStyleProperties(elementID: id)
    }

    public var dataset: DOMStringMap {
      return DOMStringMap(elementID: id)
    }

    public var classList: DOMTokenList {
      return DOMTokenList(elementID: id)
    }

    public var textContent: String {
      get {
        var buffer = [UInt8](repeating: 0, count: 1024)
        let len = element_getTextContent(id, &buffer, 1024)
        return len >= 0 ? String(decoding: buffer[0..<Int(len)], as: UTF8.self) : ""
      }
      set {
        var buffer = Array(newValue.utf8)
        buffer.append(0)
        buffer.withUnsafeBufferPointer { ptr in
          ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
            element_setTextContent(id, pointer, Int32(buffer.count - 1))
          }
        }
      }
    }

    public func querySelector(_ selector: String) -> DOM.Element? {
      var buffer = Array(selector.utf8)
      buffer.append(0)
      return buffer.withUnsafeBufferPointer { bufferPtr in
        bufferPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) {
          pointer in
          let resultID = element_querySelector(id, pointer, Int32(buffer.count - 1))
          return resultID >= 0 ? ElementFactory.create(id: resultID) : nil
        }
      }
    }

    public func querySelectorAll(_ selector: String) -> [DOM.Element] {
      var buffer = Array(selector.utf8)
      buffer.append(0)
      return buffer.withUnsafeBufferPointer { bufferPtr in
        bufferPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) {
          pointer in
          let maxElements: Int32 = 4096
          let resultBuffer = UnsafeMutablePointer<Int32>.allocate(capacity: Int(maxElements))
          defer { resultBuffer.deallocate() }
          let count = element_querySelectorAll(
            id, pointer, Int32(buffer.count - 1), resultBuffer, maxElements)
          return (0..<count).map { ElementFactory.create(id: resultBuffer[Int($0)]) }
        }
      }
    }

    @discardableResult
    public func addEventListener(
      _ event: StaticString,
      _ handler: @escaping @Sendable (Event) -> Void,
      capture: Bool,
      passive: Bool?
    ) -> Int32 {
      let callbackID = CallbackRegistry.register { payload in
        handler(Event(payload: payload))
      }
      event.withUTF8Buffer { buffer in
        buffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
          element_addEventListener(
            id, pointer, Int32(buffer.count), Int32(callbackID),
            capture ? 1 : 0,
            passive.map { $0 ? 1 : 0 } ?? -1
          )
        }
      }
      return Int32(callbackID)
    }

    public func removeEventListener(_ event: StaticString, _ callbackID: Int32) {
      event.withUTF8Buffer { buffer in
        buffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
          element_removeEventListener(id, pointer, Int32(buffer.count), callbackID)
        }
      }
      CallbackRegistry.unregister(callbackID)
    }

    public func removeEventListener(_ type: Event.`Type`, _ callbackID: Int32) {
      self.removeEventListener(type.staticString, callbackID)
    }

    public func dispatchEvent(_ event: StaticString) {
      event.withUTF8Buffer { buffer in
        buffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
          element_dispatchEvent(id, pointer, Int32(buffer.count))
        }
      }
    }

    public func dispatchEvent(_ type: Event.`Type`) {
      self.dispatchEvent(type.staticString)
    }

    public func dispatchEvent(_ event: CustomEvent) {
      element_dispatchCustomEvent(id, event.pointer)
    }

    public func focus() {
      element_focus(id)
    }

    public func click() {
      element_click(id)
    }

    public func blur() {
      element_blur(id)
    }

    public func scrollIntoView(_ options: CSSOM.ScrollIntoViewOptions? = nil) {
      if let options = options {
        var behaviorBuffer = Array(options.behavior.utf8)
        behaviorBuffer.append(0)
        var blockBuffer = Array(options.block.utf8)
        blockBuffer.append(0)
        var inlineBuffer = Array(options.inline.utf8)
        inlineBuffer.append(0)

        behaviorBuffer.withUnsafeBufferPointer { bPtr in
          bPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: behaviorBuffer.count) {
            behaviorPointer in
            blockBuffer.withUnsafeBufferPointer { blPtr in
              blPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: blockBuffer.count) {
                blockPointer in
                inlineBuffer.withUnsafeBufferPointer { iPtr in
                  iPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: inlineBuffer.count)
                  { inlinePointer in
                    element_scrollIntoView(id, behaviorPointer, blockPointer, inlinePointer)
                  }
                }
              }
            }
          }
        }
      } else {
        element_scrollIntoView(id, nil, nil, nil)
      }
    }

    public func getBoundingClientRect() -> DOM.Rect? {
      let buffer = UnsafeMutablePointer<Double>.allocate(capacity: 8)
      defer { buffer.deallocate() }
      let success = element_getBoundingClientRect(id, buffer)
      if success != 0 {
        return DOM.Rect(
          x: buffer[0], y: buffer[1], width: buffer[2], height: buffer[3],
          top: buffer[4], right: buffer[5], bottom: buffer[6], left: buffer[7]
        )
      }
      return nil
    }

    public func closest(_ selector: String) -> DOM.Element? {
      var buffer = Array(selector.utf8)
      buffer.append(0)
      return buffer.withUnsafeBufferPointer { bufferPtr in
        bufferPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) {
          pointer in
          let newID = element_closest(id, pointer, Int32(buffer.count - 1))
          return newID >= 0 ? ElementFactory.create(id: newID) : nil
        }
      }
    }

    public func cloneNode(deep: Bool) -> DOM.Element {
      let newID = element_cloneNode(id, deep ? 1 : 0)
      return ElementFactory.create(id: newID)
    }

    public var firstElementChild: DOM.Element? {
      let resultID = element_firstElementChild(id)
      return resultID >= 0 ? ElementFactory.create(id: resultID) : nil
    }

    public var className: String {
      get { return getAttribute("class") ?? "" }
      set { setAttribute("class", newValue) }
    }

    @discardableResult
    public func setAttribute(_ name: HTMLAttributeName, _ value: ARIA.Live) -> Self {
      return setAttribute(name.rawValue, value.rawValue)
    }

    @discardableResult
    public func setAttribute(_ name: HTMLAttributeName, _ value: ARIA.Role) -> Self {
      return setAttribute(name.rawValue, value.rawValue)
    }

    @discardableResult
    public func setAttribute(_ name: HTMLAttributeName, _ value: HTML.Button.`Type`) -> Self {
      return setAttribute(name.rawValue, value.rawValue)
    }

    @discardableResult
    public func setAttribute(_ name: HTMLAttributeName, _ value: HTML.Input.`Type`) -> Self {
      return setAttribute(name.rawValue, value.rawValue)
    }

    @discardableResult
    public func setAttribute(_ name: HTMLAttributeName, _ value: HTML.Input.Autocomplete) -> Self {
      return setAttribute(name.rawValue, value.rawValue)
    }

    @discardableResult
    public func setAttribute(_ name: HTMLAttributeName, _ value: CSS.Keyword.Global) -> Self {
      return setAttribute(name.rawValue, toString(value.staticRawValue))
    }

    @discardableResult
    public func setAttribute(_ name: HTMLAttributeName, _ value: CSS.Keyword.None) -> Self {
      return setAttribute(name.rawValue, toString(value.staticRawValue))
    }

    @discardableResult
    public func setAttribute(_ name: HTMLAttributeName, _ value: Int) -> Self {
      return setAttribute(name.rawValue, String(value))
    }

    public func setDisabled(_ disabled: Bool) {
      element_setDisabled(Int32(id), disabled ? 1 : 0)
    }

    public var isImageLoaded: Bool {
      element_isImageLoaded(Int32(id)) != 0
    }

    public var firstChild: DOM.Element? {
      let childID = element_firstChild(Int32(id))
      return childID >= 0 ? DOM.Element(id: childID) : nil
    }

    public var inputValue: String {
      var buffer = [UInt8](repeating: 0, count: 256)
      let len = element_getInputValue(Int32(id), &buffer, 256)
      guard len > 0 else { return "" }
      return buffer.withUnsafeBufferPointer { ptr in
        ptr.baseAddress.map { String(cString: $0) } ?? ""
      }
    }

    public var href: String {
      get { getAttribute(.href) ?? "" }
      set { setAttribute(.href, newValue) }
    }

    public func fetch(_ url: String, _ callback: @escaping @Sendable (String?) -> Void) {
      window.fetch(url) { response in
        callback(response.jsonString)
      }
    }

    public var indeterminate: Bool {
      get { element_getIndeterminate(id) != 0 }
      set { element_setIndeterminate(id, newValue ? 1 : 0) }
    }

    public var idString: String {
      get { getAttribute(.id) ?? "" }
      set { setAttribute(.id, newValue) }
    }

    public func getComputedTextLength() -> Double {
      element_getComputedTextLength(id)
    }

    public func appendChild(_ child: DOM.Element) {
      element_appendChild(id, child.id)
    }

    public func removeChild(_ child: DOM.Element) {
      element_removeChild(id, child.id)
    }

    public func insertBefore(_ newChild: DOM.Element, _ reference: DOM.Element) {
      element_insertBefore(id, newChild.id, reference.id)
    }

    // Observe size changes via ResizeObserver. Callback receives (width, height) in CSS pixels.
    // JS encodes payload as "width,height" (e.g. "800.0,600.0").
    public func observeResize(_ callback: @escaping @Sendable (Double, Double) -> Void) {
      let callbackID = CallbackRegistry.register { payload in
        let str = payload.toString()
        let parts = stringSplit(str, separator: ",")
        guard parts.count == 2 else { return }
        let w = parseDouble(parts[0]) ?? 0
        let h = parseDouble(parts[1]) ?? 0
        callback(w, h)
      }
      element_observeResize(Int32(id), Int32(callbackID))
    }

    public var clientHeight: Int {
      Int(element_clientHeight(id))
    }

    public func setInnerHTML(_ html: String) {
      var buffer = Array(html.utf8)
      buffer.append(0)
      buffer.withUnsafeBufferPointer { ptr in
        ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
          element_setInnerHTML(id, pointer, Int32(buffer.count - 1))
        }
      }
    }

    public func setStyleProperty(_ property: String, _ value: String) {
      var propBuf = Array(property.utf8)
      propBuf.append(0)
      var valBuf = Array(value.utf8)
      valBuf.append(0)
      propBuf.withUnsafeBufferPointer { pptr in
        valBuf.withUnsafeBufferPointer { vptr in
          pptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propBuf.count) { propPtr in
            vptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valBuf.count) { valPtr in
              element_setStyleProperty(id, propPtr, Int32(propBuf.count - 1), valPtr, Int32(valBuf.count - 1), nil, 0)
            }
          }
        }
      }
    }

    public func requestFullscreen() {
      element_requestFullscreen(Int32(id))
    }
  }

  @_extern(wasm, module: "env", name: "element_getTextContent")
  func element_getTextContent(
    _ elementID: Int32, _ resultBuffer: UnsafeMutablePointer<UInt8>, _ maxLen: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "element_setTextContent")
  func element_setTextContent(_ elementID: Int32, _ pointer: UnsafePointer<CChar>, _ len: Int32)

  @_extern(wasm, module: "env", name: "element_querySelector")
  func element_querySelector(
    _ elementID: Int32, _ selectorPointer: UnsafePointer<CChar>, _ selectorLen: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "element_querySelectorAll")
  func element_querySelectorAll(
    _ elementID: Int32, _ selectorPointer: UnsafePointer<CChar>, _ selectorLen: Int32,
    _ buffer: UnsafeMutablePointer<Int32>, _ maxElements: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "element_addEventListener")
  func element_addEventListener(
    _ elementID: Int32, _ eventPointer: UnsafePointer<CChar>, _ eventLen: Int32, _ callbackID: Int32, _ capture: Int32, _ passive: Int32
  )

  @_extern(wasm, module: "env", name: "element_removeEventListener")
  func element_removeEventListener(
    _ elementID: Int32, _ eventPointer: UnsafePointer<CChar>, _ eventLen: Int32, _ callbackID: Int32)

  @_extern(wasm, module: "env", name: "element_dispatchEvent")
  func element_dispatchEvent(
    _ elementID: Int32, _ eventPointer: UnsafePointer<CChar>, _ eventLen: Int32)

  @_extern(wasm, module: "env", name: "element_dispatchCustomEvent")
  func element_dispatchCustomEvent(_ elementID: Int32, _ eventPointer: Int32)

  @_extern(wasm, module: "env", name: "element_firstElementChild")
  func element_firstElementChild(_ elementID: Int32) -> Int32

  @_extern(wasm, module: "env", name: "element_getIndeterminate")
  func element_getIndeterminate(_ elementID: Int32) -> Int32

  @_extern(wasm, module: "env", name: "element_setIndeterminate")
  func element_setIndeterminate(_ elementID: Int32, _ value: Int32)

  @_extern(wasm, module: "env", name: "element_focus")
  func element_focus(_ elementID: Int32)

  @_extern(wasm, module: "env", name: "element_scrollIntoView")
  func element_scrollIntoView(
    _ elementID: Int32, _ behavior: UnsafePointer<CChar>?, _ block: UnsafePointer<CChar>?,
    _ inline: UnsafePointer<CChar>?)

  @_extern(wasm, module: "env", name: "element_click")
  func element_click(_ elementID: Int32)

  @_extern(wasm, module: "env", name: "element_blur")
  func element_blur(_ elementID: Int32)

  @_extern(wasm, module: "env", name: "element_getBoundingClientRect")
  func element_getBoundingClientRect(_ elementID: Int32, _ buffer: UnsafeMutablePointer<Double>)
    -> Int32

  @_extern(wasm, module: "env", name: "element_closest")
  func element_closest(
    _ elementID: Int32, _ selectorPointer: UnsafePointer<CChar>, _ selectorLen: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "element_cloneNode")
  func element_cloneNode(_ elementID: Int32, _ deep: Int32) -> Int32

  @_extern(wasm, module: "env", name: "element_getTagName")
  func element_getTagName(
    _ elementID: Int32, _ buffer: UnsafeMutablePointer<UInt8>, _ bufferLen: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "element_setAttribute")
  func element_setAttribute(
    _ elementID: Int32, _ namePointer: UnsafePointer<CChar>, _ nameLen: Int32,
    _ valuePointer: UnsafePointer<CChar>, _ valueLen: Int32)

  @_extern(wasm, module: "env", name: "element_setInnerHTML")
  func element_setInnerHTML(_ elementID: Int32, _ pointer: UnsafePointer<CChar>, _ len: Int32)

  @_extern(wasm, module: "env", name: "element_setStyleProperty")
  func element_setStyleProperty(
    _ elementID: Int32, _ propPointer: UnsafePointer<CChar>, _ propLen: Int32,
    _ valPointer: UnsafePointer<CChar>, _ valLen: Int32, _ priorityPointer: UnsafePointer<CChar>?,
    _ priorityLen: Int32)

  @_extern(wasm, module: "env", name: "element_removeStyleProperty")
  func element_removeStyleProperty(
    _ elementID: Int32, _ propPointer: UnsafePointer<CChar>, _ propLen: Int32)

  @_extern(wasm, module: "env", name: "element_getStyleProperty")
  func element_getStyleProperty(
    _ elementID: Int32, _ propPointer: UnsafePointer<CChar>, _ propLen: Int32,
    _ buffer: UnsafeMutablePointer<UInt8>, _ bufferLen: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "element_addClass")
  func element_addClass(_ elementID: Int32, _ classPointer: UnsafePointer<CChar>, _ classLen: Int32)

  @_extern(wasm, module: "env", name: "element_removeClass")
  func element_removeClass(
    _ elementID: Int32, _ classPointer: UnsafePointer<CChar>, _ classLen: Int32)

  @_extern(wasm, module: "env", name: "element_toggleClass")
  func element_toggleClass(
    _ elementID: Int32, _ classPointer: UnsafePointer<CChar>, _ classLen: Int32)

  @_extern(wasm, module: "env", name: "element_getComputedTextLength")
  func element_getComputedTextLength(_ elementID: Int32) -> Double

  @_extern(wasm, module: "env", name: "element_appendChild")
  func element_appendChild(_ parentID: Int32, _ childID: Int32)

  @_extern(wasm, module: "env", name: "element_removeChild")
  func element_removeChild(_ parentID: Int32, _ childID: Int32)

  @_extern(wasm, module: "env", name: "element_insertBefore")
  func element_insertBefore(_ parentID: Int32, _ newChildID: Int32, _ referenceID: Int32)

  @_extern(wasm, module: "env", name: "element_clientHeight")
  func element_clientHeight(_ elementID: Int32) -> Int32

  @_extern(wasm, module: "env", name: "element_setDisabled")
  func element_setDisabled(_ elementID: Int32, _ disabled: Int32)

  @_extern(wasm, module: "env", name: "element_isImageLoaded")
  func element_isImageLoaded(_ elementID: Int32) -> Int32

  @_extern(wasm, module: "env", name: "element_firstChild")
  func element_firstChild(_ elementID: Int32) -> Int32

  @_extern(wasm, module: "env", name: "element_observeResize")
  func element_observeResize(_ elementID: Int32, _ callbackID: Int32)

  @_extern(wasm, module: "env", name: "element_getInputValue")
  func element_getInputValue(_ elementID: Int32, _ buffer: UnsafeMutablePointer<UInt8>, _ maxLen: Int32) -> Int32

  @_extern(wasm, module: "env", name: "element_requestFullscreen")
  func element_requestFullscreen(_ elementID: Int32)

  @_extern(wasm, module: "env", name: "artifact_preloadImages")
  func artifact_preloadImages(_ urlsPointer: UnsafePointer<CChar>, _ urlsLen: Int32)

  public func preloadImages(urls: [String]) {
    guard !urls.isEmpty else { return }
    let joined = urls.joined(separator: "\n")
    var buffer = Array(joined.utf8)
    buffer.append(0)
    buffer.withUnsafeBufferPointer { ptr in
      ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { cPtr in
        artifact_preloadImages(cPtr, Int32(buffer.count - 1))
      }
    }
  }
#endif
