#if CLIENT
  import DOMBuilder
  import WebTypes

  extension DOM {
    /// The DOM's own `NodeFilter` constants: which kinds of node a
    /// `TreeWalker` shows (`whatToShow`, a bit mask).
    public enum NodeFilter {
      public static let SHOW_ALL: UInt32 = 0xFFFF_FFFF
      public static let SHOW_ELEMENT: UInt32 = 0x1
      public static let SHOW_TEXT: UInt32 = 0x4
      public static let SHOW_COMMENT: UInt32 = 0x80
    }

    /// The DOM's own `TreeWalker`, as `document.createTreeWalker(root,
    /// whatToShow)` makes it: the nodes under `root` of the kinds shown, in
    /// document order. A text node comes back as a `DOM.Text`, an element as
    /// the element it is.
    public final class TreeWalker: @unchecked Sendable {
      let handle: Int32

      init(root: DOM.Node, whatToShow: UInt32) {
        handle = document_createTreeWalker(root.id, whatToShow)
      }

      deinit {
        domObject_release(handle)
      }

      /// `nextNode()`: the next node shown, nil after the last.
      public func nextNode() -> DOM.Node? {
        node(treeWalker_nextNode(handle))
      }

      /// `currentNode`: where the walker stands (the root before the first
      /// `nextNode()`).
      public var currentNode: DOM.Node? {
        node(treeWalker_currentNode(handle))
      }

      private func node(_ id: Int32) -> DOM.Node? {
        guard id >= 0 else { return nil }
        switch node_nodeType(id) {
        case 1: return ElementFactory.create(id: id)
        case 3: return DOM.Text(id: id)
        default: return DOM.Node(id: id)
        }
      }
    }
  }

  extension DOM.Text {
    /// `CharacterData.data`: the text node's text, whole.
    public var data: String {
      var capacity = 1024
      while true {
        var buffer = [UInt8](repeating: 0, count: capacity + 1)
        let length = element_getTextContent(id, &buffer, Int32(capacity))
        if length >= 0 { return String(decoding: buffer[0..<Int(length)], as: UTF8.self) }
        // Too small: the bridge answers -(bytes + 1); ask again with room for
        // its terminator.
        let needed = Int(-length) - 1 + 16
        if needed <= capacity { return "" }
        capacity = needed
      }
    }
  }

  extension Document {
    /// `document.createTreeWalker(root, whatToShow)`, with no filter.
    public func createTreeWalker(_ root: DOM.Node, _ whatToShow: UInt32 = DOM.NodeFilter.SHOW_ALL)
      -> DOM.TreeWalker
    {
      DOM.TreeWalker(root: root, whatToShow: whatToShow)
    }
  }

  @_extern(wasm, module: "env", name: "document_createTreeWalker")
  func document_createTreeWalker(_ rootID: Int32, _ whatToShow: UInt32) -> Int32

  @_extern(wasm, module: "env", name: "treeWalker_nextNode")
  func treeWalker_nextNode(_ handle: Int32) -> Int32

  @_extern(wasm, module: "env", name: "treeWalker_currentNode")
  func treeWalker_currentNode(_ handle: Int32) -> Int32

  @_extern(wasm, module: "env", name: "node_nodeType")
  func node_nodeType(_ nodeID: Int32) -> Int32
#endif
