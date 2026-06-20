#if CLIENT
  import DOMBuilder
  import EmbeddedSwiftUtilities
  import HTMLBuilder
  import WebTypes

  public struct Document: Sendable {
    public func fontsReady(_ callback: @escaping @Sendable () -> Void) {
      let callbackID = CallbackRegistry.register { _ in
        callback()
      }
      document_fontsReady(Int32(callbackID))
    }

    public func querySelector(_ selector: StaticString) -> DOM.Element? {
      return selector.withUTF8Buffer { buffer in
        buffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
          let id = document_querySelector(pointer, Int32(buffer.count))
          return id >= 0 ? ElementFactory.create(id: id) : nil
        }
      }
    }

    public func querySelector(_ selector: String) -> DOM.Element? {
      var buffer = Array(selector.utf8)
      buffer.append(0)
      return buffer.withUnsafeBufferPointer { bufferPtr in
        bufferPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) {
          pointer in
          let id = document_querySelector(pointer, Int32(buffer.count - 1))
          return id >= 0 ? ElementFactory.create(id: id) : nil
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
          let count = document_querySelectorAll(
            pointer, Int32(buffer.count - 1), resultBuffer, maxElements)
          return (0..<count).map { ElementFactory.create(id: resultBuffer[Int($0)]) }
        }
      }
    }

    public func getElementById(_ id: String) -> DOM.Element? {
      var buffer = Array(id.utf8)
      buffer.append(0)
      return buffer.withUnsafeBufferPointer { bufferPtr in
        bufferPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) {
          pointer in
          let elementID = document_getElementById(pointer, Int32(buffer.count - 1))
          return elementID >= 0 ? ElementFactory.create(id: elementID) : nil
        }
      }
    }

    public func createElement(_ tagName: String) -> DOM.Element {
      var buffer = Array(tagName.utf8)
      buffer.append(0)
      return buffer.withUnsafeBufferPointer { bufferPtr in
        bufferPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) {
          pointer in
          let id = document_createElement(pointer, Int32(buffer.count - 1))
          return ElementFactory.create(id: id)
        }
      }
    }

    public func createElement(_ tagName: StaticString) -> DOM.Element {
      return tagName.withUTF8Buffer { buffer in
        buffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
          let id = document_createElement(pointer, Int32(buffer.count))
          return ElementFactory.create(id: id)
        }
      }
    }

    public func createElementNS(_ namespace: String, _ tagName: String) -> DOM.Element {
      var nsBuffer = Array(namespace.utf8)
      nsBuffer.append(0)
      var tagBuffer = Array(tagName.utf8)
      tagBuffer.append(0)

      return nsBuffer.withUnsafeBufferPointer { nsBufPtr in
        nsBufPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: nsBuffer.count) {
          nsPointer in
          tagBuffer.withUnsafeBufferPointer { tagBufPtr in
            tagBufPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: tagBuffer.count) {
              tagPointer in
              let id = document_createElementNS(
                nsPointer, Int32(nsBuffer.count - 1), tagPointer, Int32(tagBuffer.count - 1))
              return ElementFactory.create(id: id)
            }
          }
        }
      }
    }

    public func createElement(_ tag: HTML.TagName) -> DOM.Element {
      return createElement(tag.value)
    }

    public func createElementNS(_ namespace: String, _ tag: HTML.TagName) -> DOM.Element {
      return tag.value.withUTF8Buffer { buffer in
        let tagStr = String(decoding: buffer, as: UTF8.self)
        return createElementNS(namespace, tagStr)
      }
    }

    public var body: DOM.Element {
      querySelector("body")!
    }

    public var activeElement: DOM.Element? {
      let elementID = document_getActiveElement()
      return elementID >= 0 ? ElementFactory.create(id: elementID) : nil
    }

    public func createCustomEvent(_ type: String, detail: String) -> CustomEvent {
      return CustomEvent(type: type, detail: detail)
    }

    public func createTextNode(_ text: String) -> DOM.Node {
      var buffer = Array(text.utf8)
      buffer.append(0)
      return buffer.withUnsafeBufferPointer { bufferPtr in
        bufferPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) {
          pointer in
          let nodeID = document_createTextNode(pointer, Int32(buffer.count - 1))
          return DOM.Node(id: nodeID)
        }
      }
    }

    public func exitFullscreen() {
      document_exitFullscreen()
    }

    public var isFullscreen: Bool {
      document_isFullscreen() != 0
    }

    public func setCookie(name: String, value: String, maxAge: Int32) {
      var nameBuf = Array(name.utf8)
      nameBuf.append(0)
      var valBuf = Array(value.utf8)
      valBuf.append(0)
      nameBuf.withUnsafeBufferPointer { namePtr in
        namePtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: nameBuf.count) { namePointer in
          valBuf.withUnsafeBufferPointer { valPtr in
            valPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valBuf.count) { valPointer in
              document_setCookie(namePointer, Int32(nameBuf.count - 1), valPointer, Int32(valBuf.count - 1), maxAge)
            }
          }
        }
      }
    }

  }

  extension Document: EventTargeting {
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
          document_addEventListener(
            pointer, Int32(buffer.count), Int32(callbackID),
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
          document_removeEventListener(pointer, Int32(buffer.count), callbackID)
        }
      }
      CallbackRegistry.unregister(callbackID)
    }

    public func dispatchEvent(_ event: StaticString) {
      event.withUTF8Buffer { buffer in
        buffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
          document_dispatchEvent(pointer, Int32(buffer.count))
        }
      }
    }

    public func dispatchEvent(_ event: CustomEvent) {
      document_dispatchCustomEvent(event.pointer)
    }

    public func on(_ event: StaticString, _ handler: @escaping @Sendable (Event) -> Void)
      -> Int32
    {
      return addEventListener(event, handler)
    }

    public func on(_ event: Event.`Type`, _ handler: @escaping @Sendable (Event) -> Void)
      -> Int32
    {
      return addEventListener(event.staticString, handler)
    }
  }

  public let document = Document()

  @_extern(wasm, module: "env", name: "document_addEventListener")
  func document_addEventListener(
    _ eventPointer: UnsafePointer<CChar>, _ eventLen: Int32, _ callbackID: Int32, _ capture: Int32, _ passive: Int32)

  @_extern(wasm, module: "env", name: "document_removeEventListener")
  func document_removeEventListener(_ eventPointer: UnsafePointer<CChar>, _ eventLen: Int32, _ callbackID: Int32)

  @_extern(wasm, module: "env", name: "document_dispatchEvent")
  func document_dispatchEvent(_ eventPointer: UnsafePointer<CChar>, _ eventLen: Int32)

  @_extern(wasm, module: "env", name: "document_dispatchCustomEvent")
  func document_dispatchCustomEvent(_ eventPointer: Int32)

  @_extern(wasm, module: "env", name: "document_createElement")
  func document_createElement(_ tagNamePointer: UnsafePointer<CChar>, _ tagNameLen: Int32) -> Int32

  @_extern(wasm, module: "env", name: "document_createElementNS")
  func document_createElementNS(
    _ nsPointer: UnsafePointer<CChar>, _ nsLen: Int32, _ tagPointer: UnsafePointer<CChar>,
    _ tagLen: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "document_querySelector")
  func document_querySelector(_ selectorPointer: UnsafePointer<CChar>, _ selectorLen: Int32)
    -> Int32

  @_extern(wasm, module: "env", name: "document_querySelectorAll")
  func document_querySelectorAll(
    _ selectorPointer: UnsafePointer<CChar>, _ selectorLen: Int32,
    _ buffer: UnsafeMutablePointer<Int32>, _ maxElements: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "document_fontsReady")
  func document_fontsReady(_ callbackID: Int32)

  @_extern(wasm, module: "env", name: "document_getActiveElement")
  func document_getActiveElement() -> Int32

  @_extern(wasm, module: "env", name: "document_getElementById")
  func document_getElementById(_ idPointer: UnsafePointer<CChar>, _ idLen: Int32) -> Int32

  @_extern(wasm, module: "env", name: "document_createTextNode")
  func document_createTextNode(_ textPointer: UnsafePointer<CChar>, _ textLen: Int32) -> Int32

  @_extern(wasm, module: "env", name: "document_exitFullscreen")
  func document_exitFullscreen()

  @_extern(wasm, module: "env", name: "document_isFullscreen")
  func document_isFullscreen() -> Int32

  @_extern(wasm, module: "env", name: "document_setCookie")
  func document_setCookie(
    _ namePointer: UnsafePointer<CChar>, _ nameLen: Int32,
    _ valuePointer: UnsafePointer<CChar>, _ valueLen: Int32,
    _ maxAge: Int32
  )
#endif
