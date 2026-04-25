#if CLIENT
  import DOMBuilder

  public struct CallbackString: @unchecked Sendable {
    let ptr: UnsafePointer<CChar>
    public let len: Int

    public var isEmpty: Bool {
      return len == 0
    }

    public func equals(_ literal: StaticString) -> Bool {
      guard len == literal.utf8CodeUnitCount else { return false }
      return literal.withUTF8Buffer { litBuffer in
        for i in 0..<len {
          if ptr[i] != CChar(bitPattern: litBuffer[i]) {
            return false
          }
        }
        return true
      }
    }

    public func withCString<R>(_ body: (UnsafePointer<CChar>) -> R) -> R {
      return body(ptr)
    }

    public func toString() -> String {
      let buffer = UnsafeBufferPointer(start: ptr, count: len)
      let bytes = Array(buffer).map { UInt8(bitPattern: $0) }
      return String(decoding: bytes, as: UTF8.self)
    }

    // Event properties (matching JavaScript event API)
    public var key: String {
      var buffer = [CChar](repeating: 0, count: 256)
      let written = event_key(ptr, Int32(len), &buffer, 256)
      if written > 0 {
        let bytes = buffer.prefix(Int(written)).map { UInt8(bitPattern: $0) }
        return String(decoding: bytes, as: UTF8.self)
      }
      return ""
    }

    public func preventDefault() {
      event_preventDefault(ptr, Int32(len))
    }

    public func stopPropagation() {
      event_stopPropagation(ptr, Int32(len))
    }

    public var target: Element? {
      let targetID = event_target(ptr, Int32(len))
      return targetID >= 0 ? Element(id: targetID) : nil
    }

    public var detail: String {
      var buffer = [CChar](repeating: 0, count: 4096)
      let written = event_detail(ptr, Int32(len), &buffer, 4096)
      if written > 0 {
        let bytes = buffer.prefix(Int(written)).map { UInt8(bitPattern: $0) }
        return String(decoding: bytes, as: UTF8.self)
      }
      return ""
    }

    public var clientX: Double {
      event_clientX(ptr, Int32(len))
    }

    public var clientY: Double {
      event_clientY(ptr, Int32(len))
    }

    public var relatedTarget: Element? {
      let targetID = event_relatedTarget(ptr, Int32(len))
      return targetID >= 0 ? Element(id: targetID) : nil
    }
  }

  @_extern(wasm, module: "env", name: "event_key")
  private func event_key(
    _ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32, _ buffer: UnsafeMutablePointer<CChar>,
    _ bufferLen: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "event_preventDefault")
  private func event_preventDefault(_ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32)

  @_extern(wasm, module: "env", name: "event_stopPropagation")
  private func event_stopPropagation(_ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32)

  @_extern(wasm, module: "env", name: "event_target")
  private func event_target(_ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32) -> Int32

  @_extern(wasm, module: "env", name: "event_relatedTarget")
  private func event_relatedTarget(_ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32) -> Int32

  @_extern(wasm, module: "env", name: "event_detail")
  private func event_detail(
    _ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32, _ buffer: UnsafeMutablePointer<CChar>,
    _ bufferLen: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "event_clientX")
  private func event_clientX(_ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32) -> Double

  @_extern(wasm, module: "env", name: "event_clientY")
  private func event_clientY(_ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32) -> Double
#endif
