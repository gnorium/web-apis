#if CLIENT
  /// `DOMParser`: text read as a document the browser's own parser makes of it.
  public enum DOMParser {
    /// `new DOMParser().parseFromString(text, "application/xml")`: the
    /// `<parsererror>`'s words where the text is not well-formed XML, as
    /// the browser's parser says them (its line, its column, the fault);
    /// nil where it is well-formed.
    public static func xmlError(_ text: String) -> String? {
      var input = Array(text.utf8)
      let count = input.count
      // Never empty: an empty array has no address to hand over.
      input.append(0)
      var capacity = 1024
      while true {
        var buffer = [UInt8](repeating: 0, count: capacity)
        let length = input.withUnsafeMutableBufferPointer { text in
          domParser_xmlError(text.baseAddress!, Int32(count), &buffer, Int32(capacity))
        }
        if length == -1 { return nil }
        if length < -1 {
          capacity = Int(-length) + 1
          continue
        }
        return String(decoding: buffer[0..<Int(length)], as: UTF8.self)
      }
    }
  }

  @_extern(wasm, module: "env", name: "domParser_xmlError")
  func domParser_xmlError(
    _ text: UnsafeMutablePointer<UInt8>, _ length: Int32, _ buffer: UnsafeMutablePointer<UInt8>, _ capacity: Int32
  ) -> Int32
#endif
