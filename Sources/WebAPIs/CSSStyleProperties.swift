#if CLIENT
  import CSSBuilder
  import EmbeddedSwiftUtilities
  import WebTypes

  @dynamicMemberLookup
  public class CSSStyleProperties: CSSStyleDeclaration, @unchecked Sendable {
    public let elementID: Int32

    public init(elementID: Int32) {
      self.elementID = elementID
      super.init()
    }

    open override func setProperty(_ property: String, _ value: String, _ priority: String = "") {
      var propertyBuffer = Array(property.utf8)
      propertyBuffer.append(0)

      propertyBuffer.withUnsafeBufferPointer { propPtr in
        propPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propertyBuffer.count) {
          propertyPointer in
          var valueBuffer = Array(value.utf8)
          valueBuffer.append(0)

          valueBuffer.withUnsafeBufferPointer { bufferPtr in
            bufferPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) {
              valuePointer in
              element_setStyleProperty(
                elementID, propertyPointer, Int32(propertyBuffer.count - 1), valuePointer,
                Int32(valueBuffer.count - 1))
            }
          }
        }
      }
    }

    public final func setProperty<T: CSSPropertyValue>(_ property: String, _ value: T) {
      var propertyBuffer = Array(property.utf8)
      propertyBuffer.append(0)

      propertyBuffer.withUnsafeBufferPointer { propPtr in
        propPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propertyBuffer.count) {
          propertyPointer in
          value.rawValue.withUTF8Buffer { valueBuffer in
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

    public func setProperty(_ property: String, _ value: StaticString) {
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

    public func setProperty(_ property: StaticString, _ value: String) {
      property.withUTF8Buffer { propertyBuffer in
        propertyBuffer.baseAddress!.withMemoryRebound(
          to: CChar.self, capacity: propertyBuffer.count
        ) { propertyPointer in
          var valueBuffer = Array(value.utf8)
          valueBuffer.append(0)

          valueBuffer.withUnsafeBufferPointer { valPtr in
            valPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) {
              valuePtr in
              element_setStyleProperty(
                elementID, propertyPointer, Int32(propertyBuffer.count), valuePtr,
                Int32(valueBuffer.count - 1))
            }
          }
        }
      }
    }

    public final func setProperty<T: CSSPropertyValue>(_ property: StaticString, _ value: T) {
      property.withUTF8Buffer { propertyBuffer in
        propertyBuffer.baseAddress!.withMemoryRebound(
          to: CChar.self, capacity: propertyBuffer.count
        ) { propertyPointer in
          value.rawValue.withUTF8Buffer { valueBuffer in
            valueBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count)
            { valuePtr in
              element_setStyleProperty(
                elementID, propertyPointer, Int32(propertyBuffer.count), valuePtr,
                Int32(valueBuffer.count))
            }
          }
        }
      }
    }

    public func setProperty(_ property: StaticString, _ value: StaticString) {
      property.withUTF8Buffer { propertyBuffer in
        propertyBuffer.baseAddress!.withMemoryRebound(
          to: CChar.self, capacity: propertyBuffer.count
        ) { propertyPointer in
          value.withUTF8Buffer { valueBuffer in
            valueBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count)
            { valuePtr in
              element_setStyleProperty(
                elementID, propertyPointer, Int32(propertyBuffer.count), valuePtr,
                Int32(valueBuffer.count))
            }
          }
        }
      }
    }

    open override func removeProperty(_ property: String) -> String {
      var propertyBuffer = Array(property.utf8)
      propertyBuffer.append(0)

      propertyBuffer.withUnsafeBufferPointer { propPtr in
        propPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propertyBuffer.count) {
          propertyPointer in
          element_removeStyleProperty(elementID, propertyPointer, Int32(propertyBuffer.count - 1))
        }
      }
      return ""
    }

    public func removeProperty(_ property: StaticString) {
      property.withUTF8Buffer { propertyBuffer in
        propertyBuffer.baseAddress!.withMemoryRebound(
          to: CChar.self, capacity: propertyBuffer.count
        ) { propertyPointer in
          element_removeStyleProperty(elementID, propertyPointer, Int32(propertyBuffer.count))
        }
      }
    }

    open override func getPropertyValue(_ property: String) -> String {
      var propertyBuffer = Array(property.utf8)
      propertyBuffer.append(0)

      let bufferSize = 1024
      var resultBuffer = [UInt8](repeating: 0, count: bufferSize)
      let length = propertyBuffer.withUnsafeBufferPointer { propPtr in
        propPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propertyBuffer.count) {
          propertyPointer in
          element_getStyleProperty(
            elementID, propertyPointer, Int32(propertyBuffer.count - 1), &resultBuffer,
            Int32(bufferSize))
        }
      }
      guard length > 0 else { return "" }
      return String(decoding: resultBuffer[0..<Int(length)], as: UTF8.self)
    }

    // MARK: - CSSPropertyName Overloads

    public func setProperty(_ property: CSSPropertyName, _ value: String) {
      setProperty(property.rawValue, value)
    }

    public func setProperty(_ property: CSSPropertyName, _ value: StaticString) {
      setProperty(property.rawValue, value)
    }

    public func setProperty(_ property: CSSPropertyName, _ value: Double) {
      setProperty(property.rawValue, doubleToString(value))
    }

    public func setProperty(_ property: CSSPropertyName, _ value: Int) {
      setProperty(property.rawValue, intToString(value))
    }

    public func setProperty(_ property: CSSPropertyName, _ filters: CSSFilterFunction...) {
      let stringValue = stringJoin(filters.map { $0.value }, separator: " ")
      setProperty(property.rawValue, stringValue)
    }

    // MARK: - Type-Safe CSSProperty Overloads

    public func setProperty(_ property: CSSProperty<CSSColor>, _ value: CSSColor) {
      setProperty(property.name.rawValue, value.value)
    }

    public func setProperty(_ property: CSSProperty<Length>, _ value: Length) {
      setProperty(property.name.rawValue, value.value)
    }

    public func setProperty(_ property: CSSProperty<Percentage>, _ value: Percentage) {
      setProperty(property.name.rawValue, value.value)
    }

    public func setProperty(_ property: CSSProperty<LengthPercentage>, _ value: LengthPercentage) {
      setProperty(property.name.rawValue, value.value)
    }

    public func setProperty(_ property: CSSProperty<Double>, _ value: Double) {
      setProperty(property.name.rawValue, doubleToString(value))
    }

    public func setProperty(_ property: CSSProperty<Int>, _ value: Int) {
      setProperty(property.name.rawValue, intToString(value))
    }

    public func setProperty(_ property: CSSProperty<CSSDisplay>, _ value: CSSDisplay) {
      setProperty(property.name.rawValue, value.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSSVisibility>, _ value: CSSVisibility) {
      setProperty(property.name.rawValue, value.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSSPosition>, _ value: CSSPosition) {
      setProperty(property.name.rawValue, value.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSSCursor>, _ value: CSSCursor) {
      setProperty(property.name.rawValue, value.value)
    }

    public func setProperty(_ property: CSSProperty<CSSPointerEvents>, _ value: CSSPointerEvents) {
      setProperty(property.name.rawValue, value.rawValue)
    }

    public func setProperty(_ property: CSSProperty<String>, _ value: String) {
      setProperty(property.name.rawValue, value)
    }

    public func filter(_ value: String) {
      setProperty("filter", value)
    }

    public func background(_ value: CSSColor) {
      setProperty("background", value.value)
    }

    public func background(_ value: CSSKeyword.None) {
      setProperty("background", value.staticRawValue)
    }

    public func background(_ value: CSSKeyword.Global) {
      setProperty("background", value.staticRawValue)
    }

    public func background(_ value: String) {
      setProperty("background", value)
    }

    public func backgroundImage(_ value: String) {
      setProperty("background-image", value)
    }

    public func backgroundRepeat(_ value: CSSBackgroundRepeat) {
      setProperty("background-repeat", value.rawValue)
    }

    public func backgroundPosition(_ value: CSSBackgroundPosition) {
      if let staticRaw = value.staticRawValue {
        setProperty("background-position", staticRaw)
      } else {
        setProperty("background-position", value.value)
      }
    }

    public func backgroundPosition(
      _ x: CSSBackgroundPosition, _ xOffset: Length, _ y: CSSBackgroundPosition
    ) {
      let xVal = x.value
      let yVal = y.value
      let stringValue = "\(xVal) \(xOffset.value) \(yVal)"
      setProperty("background-position", stringValue)
    }

    public func backgroundPosition(
      _ x: CSSBackgroundPosition, _ xOffset: Length, _ y: CSSBackgroundPosition, _ yOffset: Length
    ) {
      let xVal = x.value
      let yVal = y.value
      let stringValue = "\(xVal) \(xOffset.value) \(yVal) \(yOffset.value)"
      setProperty("background-position", stringValue)
    }

    public func borderBottom(_ width: Length, _ style: CSSBorder.LineStyle, _ color: CSSColor) {
      let stringValue = "\(width.value) \(style.value) \(color.value)"
      setProperty("border-bottom", stringValue)
    }

    public func margin(_ value: Length) {
      setProperty("margin", value.value)
    }

    public func margin(_ v: Length, _ h: Length) {
      let stringValue = "\(v.value) \(h.value)"
      setProperty("margin", stringValue)
    }

    public func margin(_ t: Length, _ r: Length, _ b: Length, _ l: Length) {
      let stringValue = "\(t.value) \(r.value) \(b.value) \(l.value)"
      setProperty("margin", stringValue)
    }

    public func padding(_ all: LengthPercentage) {
      setProperty("padding", all.value)
    }

    public func padding(_ vertical: LengthPercentage, _ horizontal: LengthPercentage) {
      let value = "\(vertical.value) \(horizontal.value)"
      setProperty("padding", value)
    }

    public func padding(_ all: Length) {
      setProperty("padding", all.value)
    }

    public func padding(_ vertical: Length, _ horizontal: Length) {
      let value = "\(vertical.value) \(horizontal.value)"
      setProperty("padding", value)
    }

    public func padding(_ t: Length, _ r: Length, _ b: Length, _ l: Length) {
      let value = "\(t.value) \(r.value) \(b.value) \(l.value)"
      setProperty("padding", value)
    }

    public func padding(
      _ t: LengthPercentage, _ r: LengthPercentage, _ b: LengthPercentage, _ l: LengthPercentage
    ) {
      let value = "\(t.value) \(r.value) \(b.value) \(l.value)"
      setProperty("padding", value)
    }

    // MARK: - Dimension Properties

    public func height(_ value: Length) {
      setProperty("height", value.value)
    }

    public func height(_ value: LengthPercentage) {
      setProperty("height", value.value)
    }

    public func height(_ value: CSSKeyword.Auto) {
      setProperty("height", value.staticRawValue)
    }

    public func height(_ value: CSSKeyword.Global) {
      setProperty("height", value.staticRawValue)
    }

    // MARK: - User Interaction

    @_disfavoredOverload
    public func userSelect(_ value: CSSUserSelect) {
      setProperty("user-select", value.staticRawValue)
    }

    @_disfavoredOverload
    public func userSelect(_ value: String) {
      setProperty("user-select", value)
    }

    public func userSelect(_ value: CSSKeyword.Auto) {
      setProperty("user-select", value.staticRawValue)
    }

    public func userSelect(_ value: CSSKeyword.None) {
      setProperty("user-select", value.staticRawValue)
    }

    public func userSelect(_ value: CSSKeyword.Global) {
      setProperty("user-select", value.staticRawValue)
    }

    @_disfavoredOverload
    public func cursor(_ value: CSSCursor) {
      if let staticRawValue = value.staticRawValue {
        setProperty("cursor", staticRawValue)
      } else {
        setProperty("cursor", value.value)
      }
    }

    @_disfavoredOverload
    public func cursor(_ value: String) {
      setProperty("cursor", value)
    }

    public func cursor(_ value: CSSKeyword.Auto) {
      setProperty("cursor", value.staticRawValue)
    }

    public func cursor(_ value: CSSKeyword.None) {
      setProperty("cursor", value.staticRawValue)
    }

    public func cursor(_ value: CSSKeyword.Global) {
      setProperty("cursor", value.staticRawValue)
    }

    // MARK: - Box Model

    @_disfavoredOverload
    public func boxSizing(_ value: CSSBoxSizing) {
      if let staticRawValue = value.staticRawValue {
        setProperty("box-sizing", staticRawValue)
      } else {
        setProperty("box-sizing", value.value)
      }
    }

    @_disfavoredOverload
    public func boxSizing(_ value: String) {
      setProperty("box-sizing", value)
    }

    // MARK: - Text Decoration

    @_disfavoredOverload
    public func textDecoration(_ value: CSSTextDecoration) {
      if let staticRawValue = value.staticRawValue {
        setProperty("text-decoration", staticRawValue)
      } else {
        setProperty("text-decoration", value.value)
      }
    }

    @_disfavoredOverload
    public func textDecoration(_ value: String) {
      setProperty("text-decoration", value)
    }

    public func textDecoration(_ value: CSSKeyword.None) {
      setProperty("text-decoration", value.staticRawValue)
    }

    public func textDecoration(_ value: CSSKeyword.Global) {
      setProperty("text-decoration", value.staticRawValue)
    }

    // MARK: - Outline

    public func outline(_ width: Length, _ style: CSSBorder.LineStyle, _ color: CSSColor) {
      let stringValue = "\(width.value) \(style.value) \(color.value)"
      setProperty("outline", stringValue)
    }

    public func outline(_ value: Length) {
      setProperty("outline", value.value)
    }

    public func outline(_ value: CSSKeyword.None) {
      setProperty("outline", value.staticRawValue)
    }

    public func outline(_ value: CSSKeyword.Global) {
      setProperty("outline", value.staticRawValue)
    }

    public func borderRadius(_ value: Length) {
      setProperty("border-radius", value.value)
    }

    public func borderRadius(_ value: Percentage) {
      setProperty("border-radius", value.value)
    }

    public func borderRadius(_ value: LengthPercentage) {
      setProperty("border-radius", value.value)
    }

    public func borderLeft(_ width: Length, _ style: CSSBorder.LineStyle, _ color: CSSColor) {
      let stringValue = "\(width.value) \(style.value) \(color.value)"
      setProperty("border-left", stringValue)
    }

    @_disfavoredOverload
    public func whiteSpace(_ value: CSSWhiteSpace) {
      setProperty("white-space", value.staticRawValue)
    }

    @_disfavoredOverload
    public func whiteSpace(_ value: String) {
      setProperty("white-space", value)
    }

    @_disfavoredOverload
    public func boxShadow(_ value: CSSSpreadShadow) {
      setProperty("box-shadow", value.value)
    }

    @_disfavoredOverload
    public func boxShadow(_ value: String) {
      setProperty("box-shadow", value)
    }

    public func boxShadow(_ value: CSSKeyword.None) {
      setProperty("box-shadow", value.staticRawValue)
    }

    public func boxShadow(_ value: CSSKeyword.Global) {
      setProperty("box-shadow", value.staticRawValue)
    }

    public func boxShadow(_ value: (Length, Length, Length, CSSColor)) {
      let stringValue = "\(value.0.value) \(value.1.value) \(value.2.value) \(value.3.value)"
      setProperty("box-shadow", stringValue)
    }

    public func boxShadow(_ value: (Int, Length, Length, CSSColor)) {
      let offsetX = value.0 == 0 ? "0" : intToString(value.0)
      let stringValue = "\(offsetX) \(value.1.value) \(value.2.value) \(value.3.value)"
      setProperty("box-shadow", stringValue)
    }

    public func boxShadow(_ value: (Length, Length, Length, Length, CSSColor)) {
      let stringValue =
        "\(value.0.value) \(value.1.value) \(value.2.value) \(value.3.value) \(value.4.value)"
      setProperty("box-shadow", stringValue)
    }

    @_disfavoredOverload
    public func fontStyle(_ value: CSSFontStyle) {
      setProperty("font-style", value.rawValue)
    }

    @_disfavoredOverload
    public func fontStyle(_ value: String) {
      setProperty("font-style", value)
    }

    public func color(_ value: CSSColor) {
      setProperty("color", value.value)
    }

    public func backgroundColor(_ value: CSSColor) {
      setProperty("background-color", value.value)
    }

    public func borderColor(_ value: CSSColor) {
      setProperty("border-color", value.value)
    }

    public func outlineOffset(_ value: Length) {
      setProperty("outline-offset", value.value)
    }

    // MARK: - Explicit Property Methods for Discovery

    public func minHeight(_ value: Length) {
      setProperty("min-height", value.value)
    }

    public func minHeight(_ value: LengthPercentage) {
      setProperty("min-height", value.value)
    }

    public func maxHeight(_ value: Length) {
      setProperty("max-height", value.value)
    }

    public func maxHeight(_ value: LengthPercentage) {
      setProperty("max-height", value.value)
    }

    public func minWidth(_ value: Length) {
      setProperty("min-width", value.value)
    }

    public func minWidth(_ value: LengthPercentage) {
      setProperty("min-width", value.value)
    }

    public func maxWidth(_ value: Length) {
      setProperty("max-width", value.value)
    }

    public func maxWidth(_ value: LengthPercentage) {
      setProperty("max-width", value.value)
    }

    public func borderRight(_ width: Length, _ style: CSSBorder.LineStyle, _ color: CSSColor) {
      let stringValue = "\(width.value) \(style.value) \(color.value)"
      setProperty("border-right", stringValue)
    }

    public func borderTop(_ width: Length, _ style: CSSBorder.LineStyle, _ color: CSSColor) {
      let stringValue = "\(width.value) \(style.value) \(color.value)"
      setProperty("border-top", stringValue)
    }

    public func gap(_ value: Length) {
      setProperty("gap", value.value)
    }

    @_disfavoredOverload
    public func flexDirection(_ value: CSSFlexDirection) {
      setProperty("flex-direction", value.rawValue)
    }

    @_disfavoredOverload
    public func flexDirection(_ value: String) {
      setProperty("flex-direction", value)
    }

    @_disfavoredOverload
    public func justifyContent(_ value: CSSJustifyContent) {
      setProperty("justify-content", value.rawValue)
    }

    @_disfavoredOverload
    public func justifyContent(_ value: String) {
      setProperty("justify-content", value)
    }

    @_disfavoredOverload
    public func alignItems(_ value: CSSAlignItems) {
      setProperty("align-items", value.rawValue)
    }

    @_disfavoredOverload
    public func alignItems(_ value: String) {
      setProperty("align-items", value)
    }

    public func fontFamily(_ value: CSSFontFamily) {
      setProperty("font-family", value.value)
    }

    public func fontFamily(_ value: String) {
      setProperty("font-family", value)
    }

    public func fontFamily(_ value: CSSKeyword.Global) {
      setProperty("font-family", value.staticRawValue)
    }

    public func fontFamily(_ value: CSSKeyword.None) {
      setProperty("font-family", value.staticRawValue)
    }

    public func fontSize(_ value: Length) {
      setProperty("font-size", value.value)
    }

    public func fontWeight(_ value: CSSFontWeight) {
      setProperty("font-weight", value.value)
    }

    public func lineHeight(_ value: Double) {
      setProperty("line-height", doubleToString(value))
    }

    public func lineHeight(_ value: Length) {
      setProperty("line-height", value.value)
    }

    public func lineHeight(_ value: LengthPercentage) {
      setProperty("line-height", value.value)
    }

    public func overflowWrap(_ value: String) {
      setProperty("overflow-wrap", value)
    }

    public func overflowWrap(_ value: CSSWordWrap) {
      setProperty("overflow-wrap", value.rawValue)
    }

    public func paddingLeft(_ value: Length) {
      setProperty("padding-left", value.value)
    }

    public func paddingRight(_ value: Length) {
      setProperty("padding-right", value.value)
    }

    public func paddingTop(_ value: Length) {
      setProperty("padding-top", value.value)
    }

    public func paddingBottom(_ value: Length) {
      setProperty("padding-bottom", value.value)
    }

    public func marginLeft(_ value: Length) {
      setProperty("margin-left", value.value)
    }

    public func marginRight(_ value: Length) {
      setProperty("margin-right", value.value)
    }

    public func marginTop(_ value: Length) {
      setProperty("margin-top", value.value)
    }

    public func marginBottom(_ value: Length) {
      setProperty("margin-bottom", value.value)
    }

    public func margin(_ value: CSSKeyword.Auto) {
      setProperty("margin", value.staticRawValue)
    }

    public func margin(_ value: CSSKeyword.Global) {
      setProperty("margin", value.staticRawValue)
    }

    // MARK: - Specific Property Accessors

    public var display: CSSDisplaySetter {
      return CSSDisplaySetter(elementID: elementID)
    }

    public var textAlign: CSSTextAlignSetter {
      return CSSTextAlignSetter(elementID: elementID)
    }

    public var overflow: CSSOverflowSetter {
      return CSSOverflowSetter(elementID: elementID)
    }

    public var alignItems: CSSAlignItemsSetter {
      return CSSAlignItemsSetter(elementID: elementID)
    }

    public var pointerEvents: CSSPointerEventsSetter {
      return CSSPointerEventsSetter(elementID: elementID)
    }

    public var color: CSSColorSetter {
      return CSSColorSetter(elementID: elementID, property: "color")
    }

    public var backgroundColor: CSSColorSetter {
      return CSSColorSetter(elementID: elementID, property: "background-color")
    }

    public var borderColor: CSSColorSetter {
      return CSSColorSetter(elementID: elementID, property: "border-color")
    }

    public var textDecoration: CSSTextDecorationSetter {
      return CSSTextDecorationSetter(elementID: elementID)
    }

    public var listStyle: CSSListStyleSetter {
      return CSSListStyleSetter(elementID: elementID)
    }

    public var visibility: CSSVisibilitySetter {
      return CSSVisibilitySetter(elementID: elementID)
    }

    public var animationPlayState: CSSPropertySetter {
      return CSSPropertySetter(elementID: elementID, property: "animation-play-state")
    }

    public var transform: CSSTransformSetter {
      return CSSTransformSetter(elementID: elementID)
    }

    // Helper for border with 3 parameters
    public func border(_ width: Length, _ style: CSSBorder.LineStyle, _ color: CSSColor) {
      let stringValue = "\(width.value) \(style.value) \(color.value)"
      setProperty("border", stringValue)
    }

    // Helper for border with CSSBorder
    @_disfavoredOverload
    public func border(_ value: CSSBorder) {
      setProperty("border", value.value)
    }

    @_disfavoredOverload
    public func border(_ value: String) {
      setProperty("border", value)
    }

    public func border(_ value: CSSKeyword.None) {
      setProperty("border", value.staticRawValue)
    }

    public func border(_ value: CSSKeyword.Global) {
      setProperty("border", value.staticRawValue)
    }

    public func mask(_ value: CSSKeyword.None) {
      setProperty("mask", value.staticRawValue)
    }

    public func mask(_ value: CSSKeyword.Global) {
      setProperty("mask", value.staticRawValue)
    }

    @_disfavoredOverload
    public func mask(_ value: CSSMaskLayer) {
      setProperty("mask", value.value)
    }

    @_disfavoredOverload
    public func mask(_ value: String) {
      setProperty("mask", value)
    }

    // Helper for transition with 3 parameters
    public func transition(
      _ property: CSSSingleTransitionProperty, _ duration: CSSTime,
      _ timingFunction: CSSEasingFunction
    ) {
      if let p = property.staticRawValue, let d = duration.staticRawValue,
        let t = timingFunction.staticRawValue
      {
        let transitionProp: StaticString = "transition"
        transitionProp.withUTF8Buffer { propBuffer in
          if let propPtr = propBuffer.baseAddress {
            propPtr.withMemoryRebound(to: CChar.self, capacity: propBuffer.count) { propCCharPtr in
              var buffer: [UInt8] = []
              p.withUTF8Buffer { buffer.append(contentsOf: $0) }
              buffer.append(32)  // space
              d.withUTF8Buffer { buffer.append(contentsOf: $0) }
              buffer.append(32)  // space
              t.withUTF8Buffer { buffer.append(contentsOf: $0) }

              buffer.withUnsafeBufferPointer { valueBuffer in
                if let valuePtr = valueBuffer.baseAddress {
                  valuePtr.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) {
                    valueCCharPtr in
                    element_setStyleProperty(
                      elementID, propCCharPtr, Int32(propBuffer.count), valueCCharPtr,
                      Int32(valueBuffer.count))
                  }
                }
              }
            }
          }
        }
        return
      }

      let stringValue = "\(property.value) \(duration.value) \(timingFunction.value)"
      setProperty("transition", stringValue)
    }

    public func transition(
      _ keyword: CSSKeyword.All, _ duration: CSSTime, _ timingFunction: CSSEasingFunction
    ) {
      setProperty("transition", "all \(duration.value) \(timingFunction.value)")
    }

    public subscript(dynamicMember property: String) -> CSSPropertySetter {
      return CSSPropertySetter(elementID: elementID, property: camelToKebab(property))
    }

    private func camelToKebab(_ camel: String) -> String {
      var result: [UInt8] = []
      result.reserveCapacity(camel.utf8.count + 5)

      for (index, byte) in camel.utf8.enumerated() {
        // A-Z are 65-90
        if byte >= 65 && byte <= 90 {
          if index > 0 {
            result.append(45)  // '-'
          }
          result.append(byte + 32)  // convert to lowercase
        } else {
          result.append(byte)
        }
      }

      return String(decoding: result, as: UTF8.self)
    }
  }
#endif
