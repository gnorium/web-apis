#if CLIENT
  import DOMBuilder
  import WebTypes

  /// `Selection`: the text range the reader has selected, as
  /// `window.getSelection()` returns it, read when asked.
  public struct Selection {
    init() {}

    /// `Selection.isCollapsed`: true when nothing is selected (the range
    /// starts where it ends), as after a plain click.
    public var isCollapsed: Bool {
      window_selectionIsCollapsed() != 0
    }

    /// `Selection.rangeCount`: how many ranges it holds.
    public var rangeCount: Int {
      Int(window_selectionRangeCount())
    }

    /// `Selection.anchorNode`: the node the selection starts from (where
    /// it was begun), nil when there is none.
    public var anchorNode: DOM.Node? {
      bridgedNode(window_selectionAnchorNode())
    }

    /// `Selection.anchorOffset`: the anchor's place in its node (UTF-16
    /// code units in a text node, children in an element).
    public var anchorOffset: Int {
      Int(window_selectionAnchorOffset())
    }

    /// `Selection.focusNode`: the node the selection ends in (where the
    /// caret is), nil when there is none.
    public var focusNode: DOM.Node? {
      bridgedNode(window_selectionFocusNode())
    }

    /// `Selection.focusOffset`: the focus's place in its node.
    public var focusOffset: Int {
      Int(window_selectionFocusOffset())
    }

    /// `Selection.setBaseAndExtent(anchorNode, anchorOffset, focusNode,
    /// focusOffset)`: the selection made to run from the anchor to the
    /// focus.
    public func setBaseAndExtent(_ anchorNode: DOM.Node, _ anchorOffset: Int, _ focusNode: DOM.Node, _ focusOffset: Int) {
      window_selectionSetBaseAndExtent(anchorNode.id, Int32(anchorOffset), focusNode.id, Int32(focusOffset))
    }

    /// `Selection.collapse(node, offset)`: a caret at the point.
    public func collapse(_ node: DOM.Node, _ offset: Int) {
      window_selectionCollapse(node.id, Int32(offset))
    }

    /// `Selection.toString()`: the selected text.
    public func toString() -> String {
      let length = Int(window_selectionLength())
      guard length > 0 else { return "" }
      // One byte more for the terminator the copy writes.
      var buffer = [UInt8](repeating: 0, count: length + 1)
      let written = Int(window_selectionCopy(&buffer, Int32(length + 1)))
      return String(decoding: buffer[0..<min(written, length)], as: UTF8.self)
    }
  }

  extension Window {
    /// `Window.getSelection()`: the document's selection; nil where the
    /// browser has none to give.
    public func getSelection() -> Selection? {
      window_hasSelection() != 0 ? Selection() : nil
    }
  }

  @_extern(wasm, module: "env", name: "window_hasSelection")
  func window_hasSelection() -> Int32

  @_extern(wasm, module: "env", name: "window_selectionIsCollapsed")
  func window_selectionIsCollapsed() -> Int32

  @_extern(wasm, module: "env", name: "window_selectionAnchorNode")
  func window_selectionAnchorNode() -> Int32

  @_extern(wasm, module: "env", name: "window_selectionAnchorOffset")
  func window_selectionAnchorOffset() -> Int32

  @_extern(wasm, module: "env", name: "window_selectionFocusNode")
  func window_selectionFocusNode() -> Int32

  @_extern(wasm, module: "env", name: "window_selectionFocusOffset")
  func window_selectionFocusOffset() -> Int32

  @_extern(wasm, module: "env", name: "window_selectionSetBaseAndExtent")
  func window_selectionSetBaseAndExtent(_ anchorID: Int32, _ anchorOffset: Int32, _ focusID: Int32, _ focusOffset: Int32)

  @_extern(wasm, module: "env", name: "window_selectionCollapse")
  func window_selectionCollapse(_ nodeID: Int32, _ offset: Int32)

  @_extern(wasm, module: "env", name: "window_selectionRangeCount")
  func window_selectionRangeCount() -> Int32

  /// The selected text's length in UTF-8 bytes.
  @_extern(wasm, module: "env", name: "window_selectionLength")
  func window_selectionLength() -> Int32

  /// Copies the selected text's UTF-8 into `buffer`, at most `max - 1`
  /// bytes and a terminator; returns how many text bytes it wrote.
  @_extern(wasm, module: "env", name: "window_selectionCopy")
  func window_selectionCopy(_ buffer: UnsafeMutablePointer<UInt8>, _ max: Int32) -> Int32
#endif
