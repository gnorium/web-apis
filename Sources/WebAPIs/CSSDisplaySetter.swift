#if CLIENT
  import EmbeddedSwiftUtilities
  import WebTypes

  @dynamicCallable
  public struct CSSDisplaySetter: Sendable {
    let elementID: Int32

    // Overloads for sub-enums
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSSDisplay.Outside]) {
      guard let value = args.first else { return }
      setProperty("display", value.staticRawValue)
    }

    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSSDisplay.Inside]) {
      guard let value = args.first else { return }
      setProperty("display", value.staticRawValue)
    }

    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSSDisplay.ListItem]) {
      guard let value = args.first else { return }
      setProperty("display", value.staticRawValue)
    }

    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSSDisplay.Internal]) {
      guard let value = args.first else { return }
      setProperty("display", value.staticRawValue)
    }

    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSSDisplay.Box]) {
      guard let value = args.first else { return }
      setProperty("display", value.staticRawValue)
    }

    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSSDisplay.Legacy]) {
      guard let value = args.first else { return }
      setProperty("display", value.staticRawValue)
    }

    // Overload for none keyword
    public func dynamicallyCall(withArguments args: [CSSKeyword.None]) {
      guard let value = args.first else { return }
      setProperty("display", value.staticRawValue)
    }

    // Overload for auto keyword
    public func dynamicallyCall(withArguments args: [CSSKeyword.Auto]) {
      guard let value = args.first else { return }
      setProperty("display", value.staticRawValue)
    }

    // Overload for global keywords
    public func dynamicallyCall(withArguments args: [CSSKeyword.Global]) {
      guard let value = args.first else { return }
      setProperty("display", value.staticRawValue)
    }

    // Overload for arbitrary strings
    public func dynamicallyCall(withArguments args: [String]) {
      guard let value = args.first else { return }
      setProperty("display", value)
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
