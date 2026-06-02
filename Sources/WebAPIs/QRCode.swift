import WebTypes
#if CLIENT
  import DOMBuilder

  /// QR Code generator - mirrors JavaScript's `new QRCode(element, options)` API
  ///
  /// Usage:
  /// ```swift
  /// let element = document.getElementById("qrcode")!
  /// QRCode(element, text: "https://example.com")
  /// ```
  public struct QRCode {
    @discardableResult
    public init(_ element: DOM.Element, text: String, width: Int32 = 200, height: Int32 = 200) {
      let len = Int32(text.utf8.count)
      text.withCString { ptr in
        qrcode_init(element.id, ptr, len, width, height)
      }
    }
  }

  @_extern(wasm, module: "env", name: "qrcode_init")
  private func qrcode_init(
    _ elementID: Int32, _ textPointer: UnsafePointer<CChar>, _ textLen: Int32, _ width: Int32,
    _ height: Int32)
#endif
