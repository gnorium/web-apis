#if CLIENT
  /// CustomEvent wrapper for WASM - creates JavaScript CustomEvent objects
  public struct CustomEvent {
    private let eventPointer: Int32

    /// An event of `type` carrying `detail`. As the standard's
    /// `CustomEventInit`, it does not bubble unless `bubbles` is asked for:
    /// one dispatched on an element reaches only that element's listeners
    /// (and ancestors' capturing ones); bubbling, it reaches the document's
    /// as a click does (a gloss opened from the image, `GlossHydration`).
    public init(type: String, detail: String, bubbles: Bool = false) {
      var typeBuffer = Array(type.utf8)
      typeBuffer.append(0)
      var detailBuffer = Array(detail.utf8)
      detailBuffer.append(0)

      var ptr: Int32 = 0
      typeBuffer.withUnsafeBufferPointer { typeBufferPtr in
        typeBufferPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: typeBuffer.count) {
          typePtr in
          detailBuffer.withUnsafeBufferPointer { detailBufferPtr in
            detailBufferPtr.baseAddress!.withMemoryRebound(
              to: CChar.self, capacity: detailBuffer.count
            ) { detailPtr in
              ptr = _createCustomEvent(typePtr, detailPtr, bubbles ? 1 : 0)
            }
          }
        }
      }
      eventPointer = ptr
    }

    public var pointer: Int32 {
      eventPointer
    }

    public var detail: String {
      let bufferSize = 1024 * 4
      let buffer = UnsafeMutablePointer<CChar>.allocate(capacity: bufferSize)
      defer { buffer.deallocate() }
      let len = _getCustomEventDetail(eventPointer, buffer, Int32(bufferSize))
      if len > 0 {
        let bytes = UnsafeBufferPointer(start: buffer, count: Int(len)).map {
          UInt8(bitPattern: $0)
        }
        return String(decoding: bytes, as: UTF8.self)
      }
      return ""
    }
  }

  @_extern(wasm, module: "env", name: "createCustomEvent")
  private func _createCustomEvent(_ type: UnsafePointer<CChar>, _ detail: UnsafePointer<CChar>, _ bubbles: Int32)
    -> Int32

  @_extern(wasm, module: "env", name: "getCustomEventDetail")
  private func _getCustomEventDetail(
    _ eventPointer: Int32, _ buffer: UnsafeMutablePointer<CChar>, _ bufferSize: Int32
  ) -> Int32
#endif
