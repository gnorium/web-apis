#if CLIENT
  import EmbeddedSwiftUtilities
  import WebTypes

  @dynamicCallable
  public struct CSSVisibilitySetter: Sendable {
    let elementID: Int32

    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSSVisibility]) {
      guard let value = args.first else { return }
      setProperty("visibility", value.staticRawValue)
    }

    public func dynamicallyCall(withArguments args: [CSSKeyword.None]) {
      guard let value = args.first else { return }
      setProperty("visibility", value.staticRawValue)
    }

    public func dynamicallyCall(withArguments args: [CSSKeyword.Global]) {
      guard let value = args.first else { return }
      setProperty("visibility", value.staticRawValue)
    }

    public func dynamicallyCall(withArguments args: [String]) {
      guard let value = args.first else { return }
      setProperty("visibility", value)
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
                Int32(valBuff.count - 1)
              )
            }
          }
        }
      }
    }

    private func setProperty(_ property: StaticString, _ value: StaticString) {
      property.withUTF8Buffer { propBuffer in
        propBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propBuffer.count) {
          propPointer in
          value.withUTF8Buffer { valueBuffer in
            valueBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count)
            { valuePtr in
              element_setStyleProperty(
                elementID, propPointer, Int32(propBuffer.count), valuePtr, Int32(valueBuffer.count))
            }
          }
        }
      }
    }
  }
#endif
