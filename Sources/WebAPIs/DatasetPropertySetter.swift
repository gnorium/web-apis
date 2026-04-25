#if CLIENT
  import DOMBuilder
  import EmbeddedSwiftUtilities

  @dynamicCallable
  public struct DatasetPropertySetter: Sendable {
    let elementID: Int32
    let attribute: String

    /// Read the data attribute value
    public var value: String? {
      Element(id: elementID).getAttribute(attribute)
    }

    /// Set the data attribute value via call syntax: dataset.contrast("more")
    public func dynamicallyCall(withArguments args: [String]) {
      guard let value = args.first else { return }
      var nameBuffer = Array(attribute.utf8)
      nameBuffer.append(0)
      var valueBuffer = Array(value.utf8)
      valueBuffer.append(0)

      nameBuffer.withUnsafeBufferPointer { namePtr in
        namePtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: nameBuffer.count) {
          namePointer in
          valueBuffer.withUnsafeBufferPointer { valPtr in
            valPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) {
              valuePointer in
              element_setAttribute(
                elementID, namePointer, Int32(nameBuffer.count - 1), valuePointer,
                Int32(valueBuffer.count - 1))
            }
          }
        }
      }
    }
  }
#endif
