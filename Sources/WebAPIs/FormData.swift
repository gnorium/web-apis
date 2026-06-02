import WebTypes
#if CLIENT
  import DOMBuilder
  import EmbeddedSwiftUtilities

  public struct FormData: Sendable {
    let formID: Int32

    public init(_ form: DOM.Element) {
      self.formID = Int32(form.id)
    }

    public func toString() -> String {
      let bufferSize = 1024 * 16
      let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: bufferSize)
      defer { buffer.deallocate() }
      let len = formData_serialize(formID, buffer, Int32(bufferSize))
      if len > 0 {
        let bytes = UnsafeBufferPointer(start: buffer, count: Int(len)).map {
          UInt8(bitPattern: $0)
        }
        return String(decoding: bytes, as: UTF8.self)
      }
      return ""
    }
  }

  @_extern(wasm, module: "env", name: "formData_serialize")
  func formData_serialize(_ formID: Int32, _ buffer: UnsafeMutablePointer<Int8>, _ bufferLen: Int32)
    -> Int32
#endif
