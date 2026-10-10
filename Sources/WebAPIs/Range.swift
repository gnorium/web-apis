#if CLIENT
  import DOMBuilder
  import WebTypes

  extension DOM {
    /// The DOM's own `Range`: a stretch of the document between two boundary
    /// points, each a node and an offset in it (UTF-16 code units in a text
    /// node, children in an element), as `document.createRange()` makes it.
    /// It is released when the last reference to it goes; a `Highlight` it
    /// was added to keeps it.
    public final class Range: @unchecked Sendable {
      let handle: Int32

      /// `new Range()`: collapsed at the start of the document.
      public init() {
        handle = range_create()
      }

      deinit {
        domObject_release(handle)
      }

      /// `setStart(node, offset)`.
      public func setStart(_ node: DOM.Node, _ offset: Int) {
        range_setStart(handle, node.id, Int32(offset))
      }

      /// `setEnd(node, offset)`.
      public func setEnd(_ node: DOM.Node, _ offset: Int) {
        range_setEnd(handle, node.id, Int32(offset))
      }

      /// `collapsed`: whether its start and end are the same point.
      public var collapsed: Bool {
        range_collapsed(handle) != 0
      }

      /// `toString()`: the text it spans, its text nodes' text in document
      /// order.
      public func toString() -> String {
        let length = Int(range_toStringLength(handle))
        guard length > 0 else { return "" }
        // One byte more for the terminator the copy writes.
        var buffer = [UInt8](repeating: 0, count: length + 1)
        let written = Int(range_toStringCopy(handle, &buffer, Int32(length + 1)))
        return String(decoding: buffer[0..<min(written, length)], as: UTF8.self)
      }
    }
  }

  extension Document {
    /// `document.createRange()`.
    public func createRange() -> DOM.Range {
      DOM.Range()
    }
  }

  @_extern(wasm, module: "env", name: "range_create")
  func range_create() -> Int32

  @_extern(wasm, module: "env", name: "range_setStart")
  func range_setStart(_ handle: Int32, _ nodeID: Int32, _ offset: Int32)

  @_extern(wasm, module: "env", name: "range_setEnd")
  func range_setEnd(_ handle: Int32, _ nodeID: Int32, _ offset: Int32)

  @_extern(wasm, module: "env", name: "range_collapsed")
  func range_collapsed(_ handle: Int32) -> Int32

  /// The text a Range spans, its length in UTF-8 bytes.
  @_extern(wasm, module: "env", name: "range_toStringLength")
  func range_toStringLength(_ handle: Int32) -> Int32

  /// Copies the text a Range spans as UTF-8 into `buffer`, at most `max - 1`
  /// bytes and a terminator; returns how many text bytes it wrote.
  @_extern(wasm, module: "env", name: "range_toStringCopy")
  func range_toStringCopy(_ handle: Int32, _ buffer: UnsafeMutablePointer<UInt8>, _ max: Int32) -> Int32

  /// Lets go of a Range, TreeWalker or Highlight the bridge holds for us.
  @_extern(wasm, module: "env", name: "domObject_release")
  func domObject_release(_ handle: Int32)
#endif
