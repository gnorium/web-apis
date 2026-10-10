#if CLIENT
  import DOMBuilder
  import WebTypes

  extension DOM {
    /// The DOM's own `CaretPosition`: where a caret would stand at a point
    /// of the viewport, a node and an offset in it (UTF-16 code units in a
    /// text node), as `document.caretPositionFromPoint(x, y)` answers.
    public final class CaretPosition: @unchecked Sendable {
      let handle: Int32

      init(handle: Int32) {
        self.handle = handle
      }

      deinit {
        domObject_release(handle)
      }

      /// `offsetNode`: the node the caret stands in.
      public var offsetNode: DOM.Node? {
        bridgedNode(caretPosition_offsetNode(handle))
      }

      /// `offset`: its place in that node.
      public var offset: Int {
        Int(caretPosition_offset(handle))
      }
    }
  }

  extension Document {
    /// `document.caretPositionFromPoint(x, y)`: the caret position at a
    /// point of the viewport (client coordinates); nil where there is none.
    public func caretPositionFromPoint(_ x: Double, _ y: Double) -> DOM.CaretPosition? {
      let handle = document_caretPositionFromPoint(x, y)
      guard handle >= 0 else { return nil }
      return DOM.CaretPosition(handle: handle)
    }
  }

  @_extern(wasm, module: "env", name: "document_caretPositionFromPoint")
  func document_caretPositionFromPoint(_ x: Double, _ y: Double) -> Int32

  @_extern(wasm, module: "env", name: "caretPosition_offsetNode")
  func caretPosition_offsetNode(_ handle: Int32) -> Int32

  @_extern(wasm, module: "env", name: "caretPosition_offset")
  func caretPosition_offset(_ handle: Int32) -> Int32
#endif
