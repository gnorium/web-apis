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
                Int32(valueBuffer.count - 1))
            }
          }
        }
      }
    }

    // Concrete overload for CSSColorScheme
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSSColorScheme]) {
      guard let value = args.first else { return }
      setPropertyStaticString(value.staticRawValue)
    }

    // Concrete overload for CSSVisibility
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSSVisibility]) {
      guard let value = args.first else { return }
      setPropertyStaticString(value.staticRawValue)
    }

    // Concrete overload for CSSSingleAnimationPlayState
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSSSingleAnimationPlayState]) {
      guard let value = args.first else { return }
      setPropertyValue(value.rawValue)
    }

    // Concrete overload for CSSKeyword.Global
    public func dynamicallyCall(withArguments args: [CSSKeyword.Global]) {
      guard let value = args.first else { return }
      setPropertyStaticString(value.staticRawValue)
    }

    // Concrete overload for CSSKeyword.None
    public func dynamicallyCall(withArguments args: [CSSKeyword.None]) {
      guard let value = args.first else { return }
      setPropertyStaticString(value.staticRawValue)
    }

    // Concrete overload for CSSKeyword.Auto
    public func dynamicallyCall(withArguments args: [CSSKeyword.Auto]) {
      guard let value = args.first else { return }
      setPropertyStaticString(value.staticRawValue)
    }

    // Concrete overload for CSSKeyword.All
    public func dynamicallyCall(withArguments args: [CSSKeyword.All]) {
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

    // Concrete overload for Length (single or multiple values)
    public func dynamicallyCall(withArguments args: [Length]) {
      let stringValue: String
      if args.count == 1 {
        stringValue = args[0].value
      } else {
        stringValue = stringJoin(args.map { $0.value }, separator: " ")
      }
      setPropertyValue(stringValue)
    }

    // Concrete overload for Percentage
    public func dynamicallyCall(withArguments args: [Percentage]) {
      guard let value = args.first else { return }
      setPropertyValue(value.value)
    }

    // Concrete overload for LengthPercentage (single or multiple values)
    public func dynamicallyCall(withArguments args: [LengthPercentage]) {
      let stringValue: String
      if args.count == 1 {
        stringValue = args[0].value
      } else {
        stringValue = stringJoin(args.map { $0.value }, separator: " ")
      }
      setPropertyValue(stringValue)
    }

    // Concrete overload for CSSNumber (single or multiple values)
    public func dynamicallyCall(withArguments args: [CSSNumber]) {
      let stringValue: String
      if args.count == 1 {
        stringValue = args[0].value
      } else {
        stringValue = stringJoin(args.map { $0.value }, separator: " ")
      }
      setPropertyValue(stringValue)
    }

    // Concrete overload for CSSPosition
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSSPosition]) {
      guard let value = args.first else { return }
      setPropertyValue(value.rawValue)
    }

    // Concrete overload for CSSTransformFunction (multiple values)
    public func dynamicallyCall(withArguments args: [CSSTransformFunction]) {
      if args.count == 1 {
        setPropertyValue(args[0].value)
      } else {
        setPropertyValue(stringJoin(args.map { $0.value }, separator: " "))
      }
    }

    // CSSDisplay and CSSOverflow removed - use CSSDisplaySetter and CSSOverflowSetter instead

    // CSSAlignItems removed - use CSSAlignItemsSetter instead

    // Concrete overload for CSSJustifyContent
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSSJustifyContent]) {
      guard let value = args.first else { return }
      setPropertyValue(value.rawValue)
    }

    // Concrete overload for CSSFlexDirection
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSSFlexDirection]) {
      guard let value = args.first else { return }
      setPropertyValue(value.rawValue)
    }

    // Concrete overload for CSSCursor
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSSCursor]) {
      guard let value = args.first else { return }
      setPropertyValue(value.value)
    }

    // Concrete overload for CSSFilterFunction (multiple values)
    public func dynamicallyCall(withArguments args: [CSSFilterFunction]) {
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

    // Concrete overload for CSSColor
    public func dynamicallyCall(withArguments args: [CSSColor]) {
      guard let value = args.first else { return }
      setPropertyValue(value.value)
    }

    // CSSColor removed - use CSSColorSetter for color property

    // Concrete overload for CSSFontFamily
    public func dynamicallyCall(withArguments args: [CSSFontFamily]) {
      guard let value = args.first else { return }
      setPropertyValue(value.value)
    }

    // Concrete overload for CSSFontWeight
    public func dynamicallyCall(withArguments args: [CSSFontWeight]) {
      guard let value = args.first else { return }
      setPropertyValue(value.value)
    }

    // Concrete overload for CSSWhiteSpace
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSSWhiteSpace]) {
      guard let value = args.first else { return }
      setPropertyStaticString(value.staticRawValue)
    }

    // Concrete overload for CSSFontStyle
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSSFontStyle]) {
      guard let value = args.first else { return }
      setPropertyValue(value.rawValue)
    }

    // Concrete overload for CSSSpreadShadow
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSSSpreadShadow]) {
      guard let value = args.first else { return }
      setPropertyValue(value.value)
    }

    // Concrete overload for CSSTextOverflow
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSSTextOverflow]) {
      guard let value = args.first else { return }
      if let staticStr = value.staticRawValue {
        setPropertyStaticString(staticStr)
      } else {
        setPropertyValue(value.value)
      }
    }

    // CSSPointerEvents removed - use CSSPointerEventsSetter instead

    // Concrete overload for CSSBoxSizing
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSSBoxSizing]) {
      guard let value = args.first else { return }
      setPropertyValue(value.value)
    }

    // Concrete overload for CSSUserSelect
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSSUserSelect]) {
      guard let value = args.first else { return }
      setPropertyStaticString(value.staticRawValue)
    }

    // Concrete overload for CSSBorder
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSSBorder]) {
      guard let value = args.first else { return }
      setPropertyValue(value.value)
    }

    // Concrete overload for CSSBorder.LineStyle
    @_disfavoredOverload
    public func dynamicallyCall(withArguments args: [CSSBorder.LineStyle]) {
      guard let value = args.first else { return }
      setPropertyValue(value.value)
    }

    // Overload for animation tuples
    public func dynamicallyCall(withArguments args: [(String, CSSTime, CSSEasingFunction)]) {
      guard let value = args.first else { return }
      let stringValue = "\(value.0) \(value.1.value) \(value.2.value)"
      setPropertyValue(stringValue)
    }

    // Overload for boxShadow tuples
    public func dynamicallyCall(withArguments args: [(Int, Length, Length, CSSColor)]) {
      guard let value = args.first else { return }
      let stringValue = "\(intToString(value.0)) \(value.1.value) \(value.2.value) \(value.3.value)"
      setPropertyValue(stringValue)
    }

    // Overload for transition tuples
    public func dynamicallyCall(
      withArguments args: [(CSSSingleTransitionProperty, CSSTime, CSSEasingFunction)]
    ) {
      let transitions = args.map { "\($0.0.value) \($0.1.value) \($0.2.value)" }
      let stringValue = stringJoin(transitions, separator: ", ")
      setPropertyValue(stringValue)
    }

    // Overload for border tuples (Length, LineStyle, Color)
    public func dynamicallyCall(withArguments args: [(Length, CSSBorder.LineStyle, CSSColor)]) {
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
                Int32(valueBuffer.count))
            }
          }
        }
      }
    }
  }
#endif
