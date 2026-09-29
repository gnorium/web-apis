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

  /// Lets go of a Range, TreeWalker or Highlight the bridge holds for us.
  @_extern(wasm, module: "env", name: "domObject_release")
  func domObject_release(_ handle: Int32)
#endif
