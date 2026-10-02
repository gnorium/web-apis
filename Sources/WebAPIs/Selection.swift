#if CLIENT
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
