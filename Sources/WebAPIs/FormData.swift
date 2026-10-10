import WebTypes
#if CLIENT
  import DOMBuilder
  import EmbeddedSwiftUtilities

  /// The XMLHttpRequest standard's `FormData`: name–value entries, a value
  /// text or a file, held by the page (a handle into the loader's element
  /// table, as a `Blob` is). `fetch` sends it as `multipart/form-data`.
  public struct FormData: Sendable {
    let handle: Int32

    /// `new FormData()`: no entries.
    public init() {
      self.handle = formData_new(-1)
    }

    /// `new FormData(form)`: the form's entries, as a submission would send
    /// them.
    public init(_ form: DOM.Element) {
      self.handle = formData_new(Int32(form.id))
    }

    /// `append(name, value)`: a text entry.
    public func append(_ name: String, _ value: String) {
      var nameBuffer = Array(name.utf8)
      var valueBuffer = Array(value.utf8)
      nameBuffer.withUnsafeMutableBufferPointer { namePointer in
        valueBuffer.withUnsafeMutableBufferPointer { valuePointer in
          formData_appendString(
            handle, namePointer.baseAddress, Int32(namePointer.count), valuePointer.baseAddress,
            Int32(valuePointer.count))
        }
      }
    }

    /// `append(name, blob)`: a file entry, named as the file is.
    public func append(_ name: String, _ blob: Blob) {
      var nameBuffer = Array(name.utf8)
      nameBuffer.withUnsafeMutableBufferPointer { namePointer in
        formData_appendBlob(handle, namePointer.baseAddress, Int32(namePointer.count), blob.id)
      }
    }

    /// The text entries as `application/x-www-form-urlencoded`
    /// (`new URLSearchParams(formData).toString()`).
    public func toString() -> String {
      let bufferSize = 1024 * 16
      let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: bufferSize)
      defer { buffer.deallocate() }
      let len = formData_serialize(handle, buffer, Int32(bufferSize))
      if len > 0 {
        let bytes = UnsafeBufferPointer(start: buffer, count: Int(len)).map {
          UInt8(bitPattern: $0)
        }
        return String(decoding: bytes, as: UTF8.self)
      }
      return ""
    }
  }

  /// A new FormData, of the form with this element id (or empty for -1).
  @_extern(wasm, module: "env", name: "formData_new")
  func formData_new(_ formID: Int32) -> Int32

  @_extern(wasm, module: "env", name: "formData_appendString")
  func formData_appendString(
    _ handle: Int32, _ name: UnsafeMutablePointer<UInt8>?, _ nameLen: Int32, _ value: UnsafeMutablePointer<UInt8>?,
    _ valueLen: Int32)

  @_extern(wasm, module: "env", name: "formData_appendBlob")
  func formData_appendBlob(_ handle: Int32, _ name: UnsafeMutablePointer<UInt8>?, _ nameLen: Int32, _ blobID: Int32)

  @_extern(wasm, module: "env", name: "formData_serialize")
  func formData_serialize(_ handle: Int32, _ buffer: UnsafeMutablePointer<Int8>, _ bufferLen: Int32)
    -> Int32
#endif
