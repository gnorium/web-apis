#if CLIENT
  /// A Unicode normalization form, as `String.prototype.normalize` names it.
  public enum UnicodeNormalizationForm: Sendable {
    case nfc, nfd, nfkc, nfkd

    /// Its name, as the standard takes it ("NFC").
    var name: String {
      switch self {
      case .nfc: return "NFC"
      case .nfd: return "NFD"
      case .nfkc: return "NFKC"
      case .nfkd: return "NFKD"
      }
    }
  }

  /// `String.prototype.normalize(form)`: `string` in a Unicode normalization
  /// form, NFC by default, as the browser's standard normalizes it. The
  /// embedded client has no Unicode data of its own (Swift's normalization
  /// needs `_swift_stdlib_getNormData`), so it asks the browser. A form can
  /// be longer than the text it normalizes: the answer is read whole, asked
  /// again with room for it where the first buffer was short. The text as
  /// given where the browser refuses (it never does for these four forms).
  public func stringNormalize(_ string: String, _ form: UnicodeNormalizationForm = .nfc) -> String {
    var text = Array(string.utf8)
    let textLength = Int32(text.count)
    text.append(0)
    var name = Array(form.name.utf8)
    let nameLength = Int32(name.count)
    name.append(0)
    var capacity = text.count * 3 + 16
    while true {
      var result = [UInt8](repeating: 0, count: capacity)
      let room = capacity
      let written = text.withUnsafeBufferPointer { textBuffer in
        name.withUnsafeBufferPointer { nameBuffer in
          result.withUnsafeMutableBufferPointer { out in
            textBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: textBuffer.count) { textPointer in
              nameBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: nameBuffer.count) { namePointer in
                string_normalize(textPointer, textLength, namePointer, nameLength, out.baseAddress!, Int32(room))
              }
            }
          }
        }
      }
      if written < 0 { return string }
      if Int(written) < capacity { return String(decoding: result[0..<Int(written)], as: UTF8.self) }
      capacity = Int(written) + 1
    }
  }

  /// Writes `text` normalized to `form` into `buffer`, NUL-terminated, where
  /// it fits whole; returns its UTF-8 length either way (so a short buffer
  /// is asked again), or -1 where the browser refuses the form.
  @_extern(wasm, module: "env", name: "string_normalize")
  private func string_normalize(
    _ text: UnsafePointer<CChar>, _ textLen: Int32, _ form: UnsafePointer<CChar>, _ formLen: Int32,
    _ buffer: UnsafeMutablePointer<UInt8>, _ bufferLen: Int32
  ) -> Int32
#endif
