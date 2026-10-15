#if CLIENT
  import DOMBuilder
  import WebTypes

  extension DOM.TreeWalker {
    /// `firstChild()`: the walker's current node's first child shown, the
    /// walker moved to it; nil where it has none.
    public func firstChild() -> DOM.Node? {
      bridgedNode(treeWalker_firstChild(handle))
    }

    /// `nextSibling()`: the current node's next sibling shown, the walker
    /// moved to it; nil after the last.
    public func nextSibling() -> DOM.Node? {
      bridgedNode(treeWalker_nextSibling(handle))
    }
  }

  extension DOM.Node {
    /// `Node.nodeName`: an element's tag name (uppercase for HTML), "#text"
    /// for a text node, "#comment" for a comment.
    public var nodeName: String {
      var capacity = 64
      while true {
        var buffer = [UInt8](repeating: 0, count: capacity + 1)
        let length = node_nodeName(id, &buffer, Int32(capacity + 1))
        if length >= 0 { return String(decoding: buffer[0..<Int(length)], as: UTF8.self) }
        let needed = Int(-length) + 16
        if needed <= capacity { return "" }
        capacity = needed
      }
    }

    /// `Node.isEqualNode(other)`: whether both are of one kind, with the
    /// same name, attributes and data, and children equal in order.
    public func isEqualNode(_ other: DOM.Node) -> Bool {
      node_isEqualNode(id, other.id) != 0
    }

    /// `ChildNode.replaceWith(node)`: this node replaced in its parent by
    /// `node` (moved, where it stood elsewhere).
    public func replaceWith(_ node: DOM.Node) {
      node_replaceWith(id, node.id)
    }

    /// `Node.isConnected`: whether it stands in the document.
    public var isConnected: Bool {
      node_isConnected(id) != 0
    }

    /// The node's children in order, its text nodes and comments among them
    /// (`childNodes`, read with a `TreeWalker`'s `firstChild()` and
    /// `nextSibling()`).
    public var childNodes: [DOM.Node] {
      let walker = document.createTreeWalker(self)
      var children: [DOM.Node] = []
      var child = walker.firstChild()
      while let node = child {
        children.append(node)
        child = walker.nextSibling()
      }
      return children
    }

    /// Drops the bridge's handle on a node no longer in the document (no
    /// DOM API: the bridge holds every node it has handed Swift until told).
    /// A node still connected keeps its handle.
    public func forgetIfDetached() {
      node_forgetIfDetached(id)
    }
  }

  extension DOM.Element {
    /// `Element.getAttributeNames()`: its attributes' qualified names, in
    /// order.
    public func getAttributeNames() -> [String] {
      var capacity = 256
      while true {
        var buffer = [UInt8](repeating: 0, count: capacity + 1)
        let length = element_getAttributeNames(id, &buffer, Int32(capacity + 1))
        if length >= 0 {
          // The bridge separates names with a space: no attribute name holds one.
          var names: [String] = []
          var start = 0
          for index in 0...Int(length) where index == Int(length) || buffer[index] == 0x20 {
            if index > start { names.append(String(decoding: buffer[start..<index], as: UTF8.self)) }
            start = index + 1
          }
          return names
        }
        let needed = Int(-length) + 16
        if needed <= capacity { return [] }
        capacity = needed
      }
    }
  }

  @_extern(wasm, module: "env", name: "treeWalker_firstChild")
  func treeWalker_firstChild(_ handle: Int32) -> Int32

  @_extern(wasm, module: "env", name: "treeWalker_nextSibling")
  func treeWalker_nextSibling(_ handle: Int32) -> Int32

  @_extern(wasm, module: "env", name: "node_nodeName")
  func node_nodeName(_ nodeID: Int32, _ buffer: UnsafeMutablePointer<UInt8>, _ capacity: Int32) -> Int32

  @_extern(wasm, module: "env", name: "node_isEqualNode")
  func node_isEqualNode(_ nodeID: Int32, _ otherID: Int32) -> Int32

  @_extern(wasm, module: "env", name: "node_replaceWith")
  func node_replaceWith(_ nodeID: Int32, _ replacementID: Int32)

  @_extern(wasm, module: "env", name: "node_isConnected")
  func node_isConnected(_ nodeID: Int32) -> Int32

  @_extern(wasm, module: "env", name: "node_forgetIfDetached")
  func node_forgetIfDetached(_ nodeID: Int32)

  @_extern(wasm, module: "env", name: "element_getAttributeNames")
  func element_getAttributeNames(_ elementID: Int32, _ buffer: UnsafeMutablePointer<UInt8>, _ capacity: Int32) -> Int32
#endif
