#if CLIENT
  import DOMBuilder
  import EmbeddedSwiftUtilities

  public struct DOMTokenList: Sendable {
    let elementID: Int32

    private var element: Element { Element(id: elementID) }

    @discardableResult
    public func add(_ className: String) -> Element {
      var buffer = Array(className.utf8)
      buffer.append(0)

      buffer.withUnsafeBufferPointer { ptr in
        ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
          element_addClass(elementID, pointer, Int32(buffer.count - 1))
        }
      }
      return element
    }

    @discardableResult
    public func remove(_ className: String) -> Element {
      var buffer = Array(className.utf8)
      buffer.append(0)

      buffer.withUnsafeBufferPointer { ptr in
        ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
          element_removeClass(elementID, pointer, Int32(buffer.count - 1))
        }
      }
      return element
    }

    @discardableResult
    public func toggle(_ className: String) -> Element {
      var buffer = Array(className.utf8)
      buffer.append(0)

      buffer.withUnsafeBufferPointer { ptr in
        ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
          element_toggleClass(elementID, pointer, Int32(buffer.count - 1))
        }
      }
      return element
    }

    public func contains(_ className: String) -> Bool {
      var buffer = Array(className.utf8)
      buffer.append(0)

      return buffer.withUnsafeBufferPointer { ptr in
        ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
          element_hasClass(elementID, pointer, Int32(buffer.count - 1)) != 0
        }
      }
    }
  }

  @_extern(wasm, module: "env", name: "element_hasClass")
  func element_hasClass(_ elementID: Int32, _ classPointer: UnsafePointer<CChar>, _ classLen: Int32)
    -> Int32
#endif
