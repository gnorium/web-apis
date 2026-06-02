#if CLIENT
  import EmbeddedSwiftUtilities
  import WebTypes

  @dynamicCallable
  public struct CSSListStyleSetter: Sendable {
    let elementID: Int32

    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.ListStyle]) {
      guard let value = args.first else { return }
      setProperty("list-style", value.staticRawValue)
    }

    public func dynamicallyCall(withArguments args: [CSS.Keyword.None]) {
      guard let value = args.first else { return }
      setProperty("list-style", value.staticRawValue)
    }

    public func dynamicallyCall(withArguments args: [CSS.Keyword.Global]) {
      guard let value = args.first else { return }
      setProperty("list-style", value.staticRawValue)
    }

    public func dynamicallyCall(withArguments args: [String]) {
      guard let value = args.first else { return }
      setProperty("list-style", value)
    }

    private func setProperty(_ property: StaticString, _ value: String) {
      property.withUTF8Buffer { propBuff in
        propBuff.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propBuff.count) {
          propPtr in
          var valBuff = Array(value.utf8)
          valBuff.append(0)
          valBuff.withUnsafeBufferPointer { valPtr in
            valPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valBuff.count) {
              valCCharPtr in
              element_setStyleProperty(
                elementID,
                propPtr,
                Int32(propBuff.count),
                valCCharPtr,
                Int32(valBuff.count - 1),
                nil,
                0
              )
            }
          }
        }
      }
    }

    private func setProperty(_ property: StaticString, _ value: StaticString) {
      property.withUTF8Buffer { propBuff in
        propBuff.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propBuff.count) {
          propPtr in
          value.withUTF8Buffer { valBuff in
            valBuff.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valBuff.count) {
              valPtr in
              element_setStyleProperty(
                elementID,
                propPtr,
                Int32(propBuff.count),
                valPtr,
                Int32(valBuff.count),
                nil,
                0
              )
            }
          }
        }
      }
    }
  }
#endif
