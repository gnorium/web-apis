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

      /// `getBoundingClientRect()`: the box around what it spans; for a
      /// range over a line break alone, the line it ends (the first of its
      /// client rects with a height). Nil when the bridge holds no range.
      public func getBoundingClientRect() -> DOM.Rect? {
        let buffer = UnsafeMutablePointer<Double>.allocate(capacity: 8)
        defer { buffer.deallocate() }
        guard range_getBoundingClientRect(handle, buffer) != 0 else { return nil }
        return DOM.Rect(
          x: buffer[0], y: buffer[1], width: buffer[2], height: buffer[3],
          top: buffer[4], right: buffer[5], bottom: buffer[6], left: buffer[7])
      }

      /// `getClientRects()`: a box for each piece of what it spans as it is
      /// laid out, a text node's for each line it is set on.
      public func getClientRects() -> [DOM.Rect] {
        var capacity = Self.clientRectsCapacity
        while true {
          let buffer = UnsafeMutablePointer<Double>.allocate(capacity: capacity * Self.rectValues)
          defer { buffer.deallocate() }
          let count = Int(range_getClientRects(handle, buffer, Int32(capacity)))
          if count > capacity {
            capacity = count
            continue
          }
          var rects: [DOM.Rect] = []
          for index in 0..<count {
            let at = index * Self.rectValues
            rects.append(
              DOM.Rect(
                x: buffer[at], y: buffer[at + 1], width: buffer[at + 2], height: buffer[at + 3],
                top: buffer[at + 4], right: buffer[at + 5], bottom: buffer[at + 6], left: buffer[at + 7]))
          }
          return rects
        }
      }

      /// The values a rect takes in the bridge's buffer.
      static let rectValues = 8
      /// The rects `getClientRects` first makes room for: a few lines.
      static let clientRectsCapacity = 8

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

  @_extern(wasm, module: "env", name: "range_getBoundingClientRect")
  func range_getBoundingClientRect(_ handle: Int32, _ buffer: UnsafeMutablePointer<Double>) -> Int32

  /// A Range's client rects into `buffer` (eight values each, as
  /// `range_getBoundingClientRect` writes one), at most `capacity` of them;
  /// returns how many it has.
  @_extern(wasm, module: "env", name: "range_getClientRects")
  func range_getClientRects(_ handle: Int32, _ buffer: UnsafeMutablePointer<Double>, _ capacity: Int32) -> Int32

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
