#if CLIENT
  import EmbeddedSwiftUtilities
  import WebTypes

  /// Write-only handle for `element.style.display`.
  ///
  /// ```swift
  /// el.style.display(.none)                          // set
  /// el.style.getPropertyValue(.display)              // get (CSSOM)
  /// stringEquals(el.style.getPropertyValue(.display), "none")
  /// ```
  ///
  /// Prefer `callAsFunction` overloads (not only `@dynamicCallable`) so
  /// `.none` resolves as `CSS.Keyword.None` — Embedded's dynamicCallable
  /// path often loses that context and collides with `Optional.none`.
  @dynamicCallable
  public struct CSSDisplaySetter: Sendable {
    let elementID: Int32

    // MARK: - callAsFunction (type-safe; preferred for `.none` / keywords)

    public func callAsFunction(_ value: CSS.Keyword.None) {
      setProperty("display", value.staticRawValue)
    }

    public func callAsFunction(_ value: CSS.Keyword.Auto) {
      setProperty("display", value.staticRawValue)
    }

    public func callAsFunction(_ value: CSS.Keyword.Global) {
      setProperty("display", value.staticRawValue)
    }

    public func callAsFunction(_ value: CSS.Display.Outside) {
      setProperty("display", value.staticRawValue)
    }

    public func callAsFunction(_ value: CSS.Display.Inside) {
      setProperty("display", value.staticRawValue)
    }

    public func callAsFunction(_ value: CSS.Display.ListItem) {
      setProperty("display", value.staticRawValue)
    }

    public func callAsFunction(_ value: CSS.Display.Internal) {
      setProperty("display", value.staticRawValue)
    }

    public func callAsFunction(_ value: CSS.Display.Box) {
      setProperty("display", value.staticRawValue)
    }

    public func callAsFunction(_ value: CSS.Display.Legacy) {
      setProperty("display", value.staticRawValue)
    }

    // MARK: - @dynamicCallable (kept for multi-arg / string escape hatches)

    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.Display.Outside]) {
      guard let value = args.first else { return }
      setProperty("display", value.staticRawValue)
    }

    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.Display.Inside]) {
      guard let value = args.first else { return }
      setProperty("display", value.staticRawValue)
    }

    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.Display.ListItem]) {
      guard let value = args.first else { return }
      setProperty("display", value.staticRawValue)
    }

    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.Display.Internal]) {
      guard let value = args.first else { return }
      setProperty("display", value.staticRawValue)
    }

    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.Display.Box]) {
      guard let value = args.first else { return }
      setProperty("display", value.staticRawValue)
    }

    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.Display.Legacy]) {
      guard let value = args.first else { return }
      setProperty("display", value.staticRawValue)
    }

    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.Keyword.None]) {
      guard let value = args.first else { return }
      setProperty("display", value.staticRawValue)
    }

    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.Keyword.Auto]) {
      guard let value = args.first else { return }
      setProperty("display", value.staticRawValue)
    }

    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.Keyword.Global]) {
      guard let value = args.first else { return }
      setProperty("display", value.staticRawValue)
    }

    @_disfavoredOverload
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
