#if CLIENT
  import DOMBuilder
  import EmbeddedSwiftUtilities
  import WebTypes

  /// The data a drag carries, as `DragEvent.dataTransfer` holds it: read and
  /// written through the event the drag dispatched, while that event is being
  /// handled — which is the only time the browser lets either happen.
  public struct DataTransfer: @unchecked Sendable {
    let payload: CallbackString

    init(_ payload: CallbackString) {
      self.payload = payload
    }

    /// `setData(format, data)`: what a drop target reads back by `format`.
    public func setData(_ format: String, _ data: String) {
      withBuffers(format, data) { formatPointer, formatLength, dataPointer, dataLength in
        event_dataTransfer_setData(
          payload.ptr, Int32(payload.len), formatPointer, formatLength, dataPointer, dataLength)
      }
    }

    /// `getData(format)`. Browsers only answer it on `drop`; during the drag
    /// it reads as empty, whatever was set.
    public func getData(_ format: String) -> String {
      var bytes = Array(format.utf8)
      bytes.append(0)
      var size = 256
      while true {
        var buffer = [UInt8](repeating: 0, count: size)
        let length = bytes.withUnsafeBufferPointer { formatBuffer in
          formatBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: bytes.count) {
            formatPointer in
            buffer.withUnsafeMutableBufferPointer { out in
              event_dataTransfer_getData(
                payload.ptr, Int32(payload.len), formatPointer, Int32(bytes.count - 1),
                out.baseAddress!, Int32(size))
            }
          }
        }
        // The bridge reports the whole length when it does not fit, so one
        // retry with that much room, and headroom, reads it.
        if Int(length) < size { return String(decoding: buffer[0..<Int(length)], as: UTF8.self) }
        size = Int(length) + 16
      }
    }

    /// `effectAllowed`: which of copy, link and move the source permits.
    public var effectAllowed: String {
      get { read(event_dataTransfer_getEffectAllowed) }
      nonmutating set {
        withBuffers(newValue, "") { pointer, length, _, _ in
          event_dataTransfer_setEffectAllowed(payload.ptr, Int32(payload.len), pointer, length)
        }
      }
    }

    /// `dropEffect`: what a drop here would do. "none" refuses it.
    public var dropEffect: String {
      get { read(event_dataTransfer_getDropEffect) }
      nonmutating set {
        withBuffers(newValue, "") { pointer, length, _, _ in
          event_dataTransfer_setDropEffect(payload.ptr, Int32(payload.len), pointer, length)
        }
      }
    }

    /// `setDragImage(image, x, y)`: the element drawn under the pointer, and
    /// where on it the pointer holds it.
    public func setDragImage(_ image: DOM.Element, x: Int, y: Int) {
      event_dataTransfer_setDragImage(payload.ptr, Int32(payload.len), image.id, Int32(x), Int32(y))
    }

    private func read(
      _ reader: (UnsafePointer<CChar>, Int32, UnsafeMutablePointer<UInt8>, Int32) -> Int32
    ) -> String {
      var buffer = [UInt8](repeating: 0, count: 32)
      let length = buffer.withUnsafeMutableBufferPointer { out in
        reader(payload.ptr, Int32(payload.len), out.baseAddress!, 32)
      }
      return String(decoding: buffer[0..<Int(min(length, 32))], as: UTF8.self)
    }

    private func withBuffers(
      _ first: String, _ second: String,
      _ body: (UnsafePointer<CChar>, Int32, UnsafePointer<CChar>, Int32) -> Void
    ) {
      var firstBytes = Array(first.utf8)
      firstBytes.append(0)
      var secondBytes = Array(second.utf8)
      secondBytes.append(0)
      firstBytes.withUnsafeBufferPointer { firstBuffer in
        secondBytes.withUnsafeBufferPointer { secondBuffer in
          firstBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: firstBytes.count) {
            firstPointer in
            secondBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: secondBytes.count) {
              secondPointer in
              body(
                firstPointer, Int32(firstBytes.count - 1), secondPointer, Int32(secondBytes.count - 1))
            }
          }
        }
      }
    }
  }

  @_extern(wasm, module: "env", name: "event_dataTransfer_setData")
  func event_dataTransfer_setData(
    _ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32, _ formatPtr: UnsafePointer<CChar>,
    _ formatLen: Int32, _ dataPtr: UnsafePointer<CChar>, _ dataLen: Int32)

  @_extern(wasm, module: "env", name: "event_dataTransfer_getData")
  func event_dataTransfer_getData(
    _ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32, _ formatPtr: UnsafePointer<CChar>,
    _ formatLen: Int32, _ buffer: UnsafeMutablePointer<UInt8>, _ bufferLen: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "event_dataTransfer_getEffectAllowed")
  func event_dataTransfer_getEffectAllowed(
    _ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32, _ buffer: UnsafeMutablePointer<UInt8>,
    _ bufferLen: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "event_dataTransfer_setEffectAllowed")
  func event_dataTransfer_setEffectAllowed(
    _ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32, _ valuePtr: UnsafePointer<CChar>,
    _ valueLen: Int32)

  @_extern(wasm, module: "env", name: "event_dataTransfer_getDropEffect")
  func event_dataTransfer_getDropEffect(
    _ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32, _ buffer: UnsafeMutablePointer<UInt8>,
    _ bufferLen: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "event_dataTransfer_setDropEffect")
  func event_dataTransfer_setDropEffect(
    _ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32, _ valuePtr: UnsafePointer<CChar>,
    _ valueLen: Int32)

  @_extern(wasm, module: "env", name: "event_dataTransfer_setDragImage")
  func event_dataTransfer_setDragImage(
    _ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32, _ elementID: Int32, _ x: Int32, _ y: Int32)
#endif
