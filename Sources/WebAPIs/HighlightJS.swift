#if CLIENT
  @_extern(wasm, module: "env", name: "hljs_highlightAll")
  private func js_hljs_highlightAll()

  @_extern(wasm, module: "env", name: "hljs_highlightElement")
  private func js_hljs_highlightElement(_ elementID: Int32)

  @_extern(wasm, module: "env", name: "hljs_highlight")
  private func js_hljs_highlight(
    _ codePointer: UnsafePointer<UInt8>?, _ codeLen: Int32, _ languagePointer: UnsafePointer<UInt8>?,
    _ languageLen: Int32, _ buffer: UnsafeMutablePointer<UInt8>, _ bufferLen: Int32) -> Int32

  public enum HighlightJS {
    public static func highlightAll() {
      js_hljs_highlightAll()
    }

    public static func highlightElement(elementID: Int32) {
      js_hljs_highlightElement(elementID)
    }

    /// `hljs.highlight(code, { language, ignoreIllegals: true }).value`:
    /// `code` as colored markup, to be set as HTML; escaped as it is where
    /// `language` is none highlight.js has.
    public static func highlight(_ code: String, language: String) -> String {
      // Each terminated, so an empty one still has an address (the
      // loader reads a pointer equal to its length as terminated).
      var codeBytes = Array(code.utf8)
      codeBytes.append(0)
      var languageBytes = Array(language.utf8)
      languageBytes.append(0)
      // The code's own length first; its markup, longer, is asked for
      // again at the length the bridge answers.
      var capacity = codeBytes.count
      while true {
        var buffer = [UInt8](repeating: 0, count: capacity + 1)
        let length = codeBytes.withUnsafeBufferPointer { codePtr in
          languageBytes.withUnsafeBufferPointer { languagePtr in
            buffer.withUnsafeMutableBufferPointer { out in
              js_hljs_highlight(
                codePtr.baseAddress, Int32(codeBytes.count - 1), languagePtr.baseAddress, Int32(languageBytes.count - 1),
                out.baseAddress!, Int32(capacity + 1))
            }
          }
        }
        if length >= 0 { return String(decoding: buffer[0..<Int(length)], as: UTF8.self) }
        let needed = Int(-length) - 1
        if needed <= capacity { return "" }
        capacity = needed
      }
    }
  }
#endif
