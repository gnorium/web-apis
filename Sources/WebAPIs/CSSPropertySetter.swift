#if CLIENT
  import EmbeddedSwiftUtilities
  import WebTypes

  // Generic property setter for all other CSSContent properties
  @dynamicCallable
  public struct CSSPropertySetter: Sendable {
    let elementID: Int32
    let property: String

    // Helper to set property without triggering normalization
    private func setPropertyValue(_ value: String) {
      var propertyBuffer = Array(property.utf8)
      propertyBuffer.append(0)
      var valueBuffer = Array(value.utf8)
      valueBuffer.append(0)

      propertyBuffer.withUnsafeBufferPointer { propPtr in
        propPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propertyBuffer.count) {
          propertyPointer in
          valueBuffer.withUnsafeBufferPointer { valPtr in
            valPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) {
              valuePointer in
              element_setStyleProperty(
                elementID, propertyPointer, Int32(propertyBuffer.count - 1), valuePointer,
                Int32(valueBuffer.count - 1), nil, 0)
            }
          }
        }
      }
    }

    // Concrete overload for CSS.ColorScheme
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.ColorScheme]) {
      guard let value = args.first else { return }
      setPropertyStaticString(value.staticRawValue)
    }

    // Concrete overload for CSS.Visibility
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.Visibility]) {
      guard let value = args.first else { return }
      setPropertyStaticString(value.staticRawValue)
    }

    // Concrete overload for CSS.SingleAnimationPlayState
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.SingleAnimationPlayState]) {
      guard let value = args.first else { return }
      setPropertyValue(value.rawValue)
    }

    // Concrete overload for CSS.Keyword.Global
    public func dynamicallyCall(withArguments args: [CSS.Keyword.Global]) {
      guard let value = args.first else { return }
      setPropertyStaticString(value.staticRawValue)
    }

    // Concrete overload for CSS.Keyword.None
    public func dynamicallyCall(withArguments args: [CSS.Keyword.None]) {
      guard let value = args.first else { return }
      setPropertyStaticString(value.staticRawValue)
    }

    // Concrete overload for CSS.Keyword.Auto
    public func dynamicallyCall(withArguments args: [CSS.Keyword.Auto]) {
      guard let value = args.first else { return }
      setPropertyStaticString(value.staticRawValue)
    }

    // Concrete overload for CSS.Keyword.All
    public func dynamicallyCall(withArguments args: [CSS.Keyword.All]) {
      guard let value = args.first else { return }
      setPropertyStaticString(value.staticRawValue)
    }

    // Concrete overload for String
    public func dynamicallyCall(withArguments args: [String]) {
      guard let value = args.first else { return }
      setPropertyValue(value)
    }

    // Concrete overload for Int (single or multiple values)
    public func dynamicallyCall(withArguments args: [Int]) {
      let stringValue: String
      if args.count == 1 {
        stringValue = intToString(args[0])
      } else {
        stringValue = stringJoin(args.map { intToString($0) }, separator: " ")
      }
      setPropertyValue(stringValue)
    }

    // Concrete overload for Int32 (single or multiple values)
    public func dynamicallyCall(withArguments args: [Int32]) {
      let stringValue: String
      if args.count == 1 {
        stringValue = intToString(Int(args[0]))
      } else {
        stringValue = stringJoin(args.map { intToString(Int($0)) }, separator: " ")
      }
      setPropertyValue(stringValue)
    }

    // Concrete overload for CSS.Length (single or multiple values)
    public func dynamicallyCall(withArguments args: [CSS.Length]) {
      let stringValue: String
      if args.count == 1 {
        stringValue = args[0].value
      } else {
        stringValue = stringJoin(args.map { $0.value }, separator: " ")
      }
      setPropertyValue(stringValue)
    }

    // Concrete overload for CSS.Percentage
    public func dynamicallyCall(withArguments args: [CSS.Percentage]) {
      guard let value = args.first else { return }
      setPropertyValue(value.value)
    }

    // Concrete overload for CSS.LengthPercentage (single or multiple values)
    public func dynamicallyCall(withArguments args: [CSS.LengthPercentage]) {
      let stringValue: String
      if args.count == 1 {
        stringValue = args[0].value
      } else {
        stringValue = stringJoin(args.map { $0.value }, separator: " ")
      }
      setPropertyValue(stringValue)
    }

    // Concrete overload for CSS.Number (single or multiple values)
    public func dynamicallyCall(withArguments args: [CSS.Number]) {
      let stringValue: String
      if args.count == 1 {
        stringValue = args[0].value
      } else {
        stringValue = stringJoin(args.map { $0.value }, separator: " ")
      }
      setPropertyValue(stringValue)
    }

    // Concrete overload for CSS.Position
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.Position]) {
      guard let value = args.first else { return }
      setPropertyValue(value.rawValue)
    }

    // Concrete overload for CSS.TransformFunction (multiple values)
    public func dynamicallyCall(withArguments args: [CSS.TransformFunction]) {
      if args.count == 1 {
        setPropertyValue(args[0].value)
      } else {
        setPropertyValue(stringJoin(args.map { $0.value }, separator: " "))
      }
    }

    // CSS.Display and CSS.Overflow removed - use CSSDisplaySetter and CSSOverflowSetter instead

    // CSS.AlignItems removed - use CSSAlignItemsSetter instead

    // Concrete overload for CSS.JustifyContent
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.JustifyContent]) {
      guard let value = args.first else { return }
      setPropertyValue(value.rawValue)
    }

    // Concrete overload for CSS.FlexDirection
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.FlexDirection]) {
      guard let value = args.first else { return }
      setPropertyValue(value.rawValue)
    }

    // Concrete overload for CSS.Cursor
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.Cursor]) {
      guard let value = args.first else { return }
      setPropertyValue(value.value)
    }

    // Concrete overload for CSS.FilterFunction (multiple values)
    public func dynamicallyCall(withArguments args: [CSS.FilterFunction]) {
      if args.count == 1 {
        setPropertyValue(args[0].value)
      } else {
        setPropertyValue(stringJoin(args.map { $0.value }, separator: " "))
      }
    }

    // Concrete overload for Double (single or multiple values)
    public func dynamicallyCall(withArguments args: [Double]) {
      let stringValue: String
      if args.count == 1 {
        stringValue = doubleToString(args[0])
      } else {
        stringValue = stringJoin(args.map { doubleToString($0) }, separator: " ")
      }
      setPropertyValue(stringValue)
    }

    // Concrete overload for CSS.Color
    public func dynamicallyCall(withArguments args: [CSS.Color]) {
      guard let value = args.first else { return }
      setPropertyValue(value.value)
    }

    // CSS.Color removed - use CSSColorSetter for color property

    // Concrete overload for CSS.FontFamily
    public func dynamicallyCall(withArguments args: [CSS.FontFamily]) {
      guard let value = args.first else { return }
      setPropertyValue(value.value)
    }

    // Concrete overload for CSS.FontWeight
    public func dynamicallyCall(withArguments args: [CSS.FontWeight]) {
      guard let value = args.first else { return }
      setPropertyValue(value.value)
    }

    // Concrete overload for CSS.WhiteSpace
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.WhiteSpace]) {
      guard let value = args.first else { return }
      setPropertyStaticString(value.staticRawValue)
    }

    // Concrete overload for CSS.FontStyle
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.FontStyle]) {
      guard let value = args.first else { return }
      setPropertyValue(value.rawValue)
    }

    // Concrete overload for CSS.SpreadShadow
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.SpreadShadow]) {
      guard let value = args.first else { return }
      setPropertyValue(value.value)
    }

    // Concrete overload for CSS.TextOverflow
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.TextOverflow]) {
      guard let value = args.first else { return }
      if let staticStr = value.staticRawValue {
        setPropertyStaticString(staticStr)
      } else {
        setPropertyValue(value.value)
      }
    }

    // Concrete overload for CSS.TextTransform (Needed for dot-syntax resolution like .uppercase)
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.TextTransform]) {
      guard let value = args.first else { return }
      setPropertyStaticString(value.staticRawValue)
    }

    // CSS.PointerEvents removed - use CSSPointerEventsSetter instead

    // Concrete overload for CSS.BoxSizing
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.BoxSizing]) {
      guard let value = args.first else { return }
      setPropertyValue(value.value)
    }

    // Concrete overload for CSS.UserSelect
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.UserSelect]) {
      guard let value = args.first else { return }
      setPropertyStaticString(value.staticRawValue)
    }

    // Concrete overload for CSS.Border
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.Border]) {
      guard let value = args.first else { return }
      setPropertyValue(value.value)
    }

    // Concrete overload for CSS.Border.LineStyle
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSS.Border.LineStyle]) {
      guard let value = args.first else { return }
      setPropertyValue(value.value)
    }

    // Overload for animation tuples
    public func dynamicallyCall(withArguments args: [(String, CSS.Time, CSS.EasingFunction)]) {
      guard let value = args.first else { return }
      let stringValue = "\(value.0) \(value.1.value) \(value.2.value)"
      setPropertyValue(stringValue)
    }

    // Overload for boxShadow tuples
    public func dynamicallyCall(withArguments args: [(Int, CSS.Length, CSS.Length, CSS.Color)]) {
      guard let value = args.first else { return }
      let stringValue = "\(intToString(value.0)) \(value.1.value) \(value.2.value) \(value.3.value)"
      setPropertyValue(stringValue)
    }

    // Overload for transition tuples
    public func dynamicallyCall(
      withArguments args: [(CSS.SingleTransitionProperty, CSS.Time, CSS.EasingFunction)]
    ) {
      let transitions = args.map { "\($0.0.value) \($0.1.value) \($0.2.value)" }
      let stringValue = stringJoin(transitions, separator: ", ")
      setPropertyValue(stringValue)
    }

    // Overload for border tuples (CSS.Length, LineStyle, Color)
    public func dynamicallyCall(withArguments args: [(CSS.Length, CSS.Border.LineStyle, CSS.Color)]) {
      guard let value = args.first else { return }
      let stringValue = "\(value.0.value) \(value.1.value) \(value.2.value)"
      setPropertyValue(stringValue)
    }

    // Overload for border/transition with keyword arguments
    public func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Any>) {
      // Not used - exists for potential future keyword arg support
    }

    // Generic fallback for other CSSPropertyValue types
    @_disfavoredOverload
    public func dynamicallyCall<T: CSSPropertyValue>(withArguments args: [T]) {
      guard let value = args.first else { return }
      setPropertyStaticString(value.rawValue)
    }

    private func setPropertyStaticString(_ value: StaticString) {
      var propertyBuffer = Array(property.utf8)
      propertyBuffer.append(0)

      propertyBuffer.withUnsafeBufferPointer { propPtr in
        propPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propertyBuffer.count) {
          propertyPointer in
          value.withUTF8Buffer { valueBuffer in
            valueBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count)
            { valuePtr in
              element_setStyleProperty(
                elementID, propertyPointer, Int32(propertyBuffer.count - 1), valuePtr,
                Int32(valueBuffer.count), nil, 0)
            }
          }
        }
      }
    }
  }
#endif
