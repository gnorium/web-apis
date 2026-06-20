#if CLIENT
  import DOMBuilder
  import EmbeddedSwiftUtilities
  import WebTypes

  public struct Window: Sendable {
    public func matchMedia(_ query: MediaQueryList) -> Bool {
      return query.withCString { pointer, len in
        let result = window_matchMedia(pointer, len)
        return result != 0
      }
    }

    public func matchMedia(_ query: StaticString) -> Bool {
      return matchMedia(MediaQueryList(query))
    }

    public func onMediaQueryChange(
      _ query: MediaQueryList, _ handler: @escaping @Sendable (Bool) -> Void
    ) {
      let callbackID = CallbackRegistry.register { matches in
        handler(matches.equals("true"))
      }
      query.withCString { pointer, len in
        window_matchMediaAddListener(pointer, len, Int32(callbackID))
      }
    }

    public func onMediaQueryChange(
      _ query: StaticString, _ handler: @escaping @Sendable (Bool) -> Void
    ) {
      onMediaQueryChange(MediaQueryList(query), handler)
    }

    public struct URL {
      public static func createObjectURL(_ blobID: Int32) -> String {
        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: bufferSize)
        defer { buffer.deallocate() }
        let len = window_createObjectURL(blobID, buffer, Int32(bufferSize))
        if len > 0 {
          let bytes = UnsafeBufferPointer(start: buffer, count: Int(len)).map {
            UInt8(bitPattern: $0)
          }
          return String(decoding: bytes, as: UTF8.self)
        }
        return ""
      }

      public static func revokeObjectURL(_ url: String) {
        var buffer = Array(url.utf8)
        buffer.append(0)

        buffer.withUnsafeBufferPointer { ptr in
          ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
            window_revokeObjectURL(pointer, Int32(buffer.count - 1))
          }
        }
      }
    }

    public struct Performance: Sendable {
      public func now() -> Double {
        window_performanceNow()
      }
    }

    public struct Navigator: Sendable {
      public struct Clipboard: Sendable {
        public init() {}
        public func writeText(_ text: String) {
          var buffer = Array(text.utf8)
          buffer.append(0)
          buffer.withUnsafeBufferPointer { ptr in
            ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
              navigator_clipboard_writeText(pointer, Int32(buffer.count - 1))
            }
          }
        }
      }
      public let clipboard = Clipboard()
      public init() {}
    }

    public let performance = Performance()
    public let navigator = Navigator()
    public var scrollY: Double {
      window_scrollY()
    }
    public var devicePixelRatio: Double {
      window_devicePixelRatio()
    }
    public var innerWidth: Double {
      window_innerWidth()
    }
  }

  extension Window: EventTargeting {
    public func dispatchEvent(_ event: DOM.Element) {
      window_dispatchEvent(Int32(event.id))
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
          window_addEventListener(
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
          window_removeEventListener(pointer, Int32(buffer.count), callbackID)
        }
      }
      CallbackRegistry.unregister(callbackID)
    }

    public func removeEventListener(_ event: Event.`Type`, _ callbackID: Int32) {
      removeEventListener(event.staticString, callbackID)
    }

    public func dispatchEvent(_ event: StaticString) {
      event.withUTF8Buffer { buffer in
        buffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
          window_dispatchEvent_by_name(pointer, Int32(buffer.count))
        }
      }
    }

    public func dispatchEvent(_ event: CustomEvent) {
      window_dispatchCustomEvent(event.pointer)
    }
    public var location: Location {
      Location()
    }

    public func alert(_ message: String) {
      var buffer = Array(message.utf8)
      buffer.append(0)

      buffer.withUnsafeBufferPointer { ptr in
        ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
          window_alert(pointer, Int32(buffer.count - 1))
        }
      }
    }

    public func confirm(_ message: String) -> Bool {
      var buffer = Array(message.utf8)
      buffer.append(0)

      return buffer.withUnsafeBufferPointer { ptr in
        ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
          let result = window_confirm(pointer, Int32(buffer.count - 1))
          return result != 0
        }
      }
    }

    public func fetch(
      _ url: String, method: String = "GET", body: String? = nil,
      _ callback: @escaping @Sendable (FetchResponse) -> Void
    ) {
      let callbackID = CallbackRegistry.register { result in
        callback(FetchResponse(jsonString: result.toString()))
      }

      var urlBuffer = Array(url.utf8)
      urlBuffer.append(0)
      var methodBuffer = Array(method.utf8)
      methodBuffer.append(0)

      urlBuffer.withUnsafeBufferPointer { urlPtr in
        urlPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: urlBuffer.count) {
          urlPointer in
          methodBuffer.withUnsafeBufferPointer { methodPtr in
            methodPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: methodBuffer.count) {
              methodPointer in
              if let body = body {
                var bodyBuffer = Array(body.utf8)
                bodyBuffer.append(0)
                bodyBuffer.withUnsafeBufferPointer { bodyPtr in
                  bodyPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: bodyBuffer.count)
                  { bodyPointer in
                    window_fetch(
                      urlPointer, Int32(urlBuffer.count - 1), methodPointer,
                      Int32(methodBuffer.count - 1), bodyPointer, Int32(bodyBuffer.count - 1),
                      Int32(callbackID))
                  }
                }
              } else {
                window_fetch(
                  urlPointer, Int32(urlBuffer.count - 1), methodPointer,
                  Int32(methodBuffer.count - 1), nil, 0, Int32(callbackID))
              }
            }
          }
        }
      }
    }

    @discardableResult
    public func requestAnimationFrame(_ callback: @escaping @Sendable () -> Void) -> Int32 {
      let callbackID = CallbackRegistry.register { _ in
        callback()
      }
      return window_requestAnimationFrame(Int32(callbackID))
    }

    public func cancelAnimationFrame(_ id: Int32) {
      window_cancelAnimationFrame(id)
    }

    @discardableResult
    public func setTimeout(_ ms: Double, _ callback: @escaping @Sendable () -> Void) -> Int32 {
      let callbackID = CallbackRegistry.register { _ in
        callback()
      }
      return window_setTimeout(ms, Int32(callbackID))
    }

    public func clearTimeout(_ timerID: Int32) {
      window_clearTimeout(timerID)
    }

    /// Standard scrollTo API - scrolls to specified coordinates
    /// - Parameters:
    ///   - x: X coordinate to scroll to
    ///   - y: Y coordinate to scroll to
    ///   - behavior: 0 for auto (default), 1 for smooth
    public func scrollTo(_ x: Double, _ y: Double, behavior: CSSOM.ScrollBehavior = .auto) {
      window_scrollTo(x, y, Int32(behavior.rawValue))
    }

    public func replaceURL(_ url: String) {
      var buffer = Array(url.utf8)
      buffer.append(0)
      buffer.withUnsafeBufferPointer { ptr in
        ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
          history_replaceURL(pointer, Int32(buffer.count - 1))
        }
      }
    }
  }

  public struct FetchResponse: Sendable {
    public let jsonString: String

    public func text() -> String {
      jsonString
    }
  }

  public let window = Window()

  @_extern(wasm, module: "env", name: "window_alert")
  func window_alert(_ messagePointer: UnsafePointer<CChar>, _ messageLen: Int32)

  @_extern(wasm, module: "env", name: "window_confirm")
  func window_confirm(_ messagePointer: UnsafePointer<CChar>, _ messageLen: Int32) -> Int32

  @_extern(wasm, module: "env", name: "window_fetch")
  func window_fetch(
    _ urlPointer: UnsafePointer<CChar>, _ urlLen: Int32, _ methodPointer: UnsafePointer<CChar>,
    _ methodLen: Int32, _ bodyPointer: UnsafePointer<CChar>?, _ bodyLen: Int32, _ callbackID: Int32)

  @_extern(wasm, module: "env", name: "window_matchMedia")
  func window_matchMedia(_ queryPointer: UnsafePointer<CChar>, _ queryLen: Int32) -> Int32

  @_extern(wasm, module: "env", name: "window_matchMediaAddListener")
  func window_matchMediaAddListener(
    _ queryPointer: UnsafePointer<CChar>, _ queryLen: Int32, _ callbackID: Int32)

  @_extern(wasm, module: "env", name: "window_dispatchEvent")
  func window_dispatchEvent(_ elementID: Int32)

  @_extern(wasm, module: "env", name: "window_addEventListener")
  func window_addEventListener(
    _ eventPointer: UnsafePointer<CChar>, _ eventLen: Int32, _ callbackID: Int32, _ capture: Int32, _ passive: Int32)

  @_extern(wasm, module: "env", name: "window_requestAnimationFrame")
  func window_requestAnimationFrame(_ callbackID: Int32) -> Int32

  @_extern(wasm, module: "env", name: "window_cancelAnimationFrame")
  func window_cancelAnimationFrame(_ id: Int32)

  @_extern(wasm, module: "env", name: "window_setTimeout")
  func window_setTimeout(_ ms: Double, _ callbackID: Int32) -> Int32

  @_extern(wasm, module: "env", name: "window_clearTimeout")
  func window_clearTimeout(_ timerID: Int32)

  @_extern(wasm, module: "env", name: "window_scrollTo")
  func window_scrollTo(_ x: Double, _ y: Double, _ behavior: Int32)

  @_extern(wasm, module: "env", name: "window_getLocationHref")
  func window_getLocationHref(_ buffer: UnsafeMutablePointer<Int8>, _ bufferLen: Int32) -> Int32

  @_extern(wasm, module: "env", name: "getLocationPathname")
  func window_getLocationPathname(_ buffer: UnsafeMutablePointer<Int8>, _ bufferLen: Int32) -> Int32

  @_extern(wasm, module: "env", name: "getLocationSearch")
  func window_getLocationSearch(_ buffer: UnsafeMutablePointer<Int8>, _ bufferLen: Int32) -> Int32

  @_extern(wasm, module: "env", name: "window_setLocationHref")
  func window_setLocationHref(_ hrefPointer: UnsafePointer<CChar>, _ hrefLen: Int32)

  @_extern(wasm, module: "env", name: "history_replaceURL")
  func history_replaceURL(_ urlPointer: UnsafePointer<CChar>, _ urlLen: Int32)

  @_extern(wasm, module: "env", name: "window_performanceNow")
  func window_performanceNow() -> Double

  public func getPerformanceNow() -> Double {
    window_performanceNow()
  }

  @_extern(wasm, module: "env", name: "window_createObjectURL")
  func window_createObjectURL(
    _ blobID: Int32, _ buffer: UnsafeMutablePointer<Int8>, _ bufferLen: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "window_revokeObjectURL")
  func window_revokeObjectURL(_ urlPointer: UnsafePointer<CChar>, _ urlLen: Int32)

  @_extern(wasm, module: "env", name: "navigator_clipboard_writeText")
  func navigator_clipboard_writeText(_ textPointer: UnsafePointer<CChar>, _ textLen: Int32)

  @_extern(wasm, module: "env", name: "canvas_toBlob")
  public func canvas_toBlob(_ canvasID: Int32, _ callbackID: Int32)

  @_extern(wasm, module: "env", name: "window_scrollY")
  func window_scrollY() -> Double

  @_extern(wasm, module: "env", name: "window_devicePixelRatio")
  func window_devicePixelRatio() -> Double

  @_extern(wasm, module: "env", name: "window_innerWidth")
  func window_innerWidth() -> Double

  @_extern(wasm, module: "env", name: "window_removeEventListener")
  func window_removeEventListener(_ eventPointer: UnsafePointer<CChar>, _ eventLen: Int32, _ callbackID: Int32)

  @_extern(wasm, module: "env", name: "window_dispatchEvent_by_name")
  func window_dispatchEvent_by_name(_ eventPointer: UnsafePointer<CChar>, _ eventLen: Int32)

  @_extern(wasm, module: "env", name: "window_dispatchCustomEvent")
  func window_dispatchCustomEvent(_ eventPointer: Int32)
#endif
