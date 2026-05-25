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

          valueBuffer.withUnsafeBufferPointer { valPtr in
            valPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) {
              valuePointer in
              var priorityBuffer = Array(priority.utf8)
              priorityBuffer.append(0)

              priorityBuffer.withUnsafeBufferPointer { prioPtr in
                prioPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: priorityBuffer.count)
                { priorityPointer in
                  element_setStyleProperty(
                    elementID, propertyPointer, Int32(propertyBuffer.count - 1), valuePointer,
                    Int32(valueBuffer.count - 1), priorityPointer, Int32(priorityBuffer.count - 1))
                }
              }
            }
          }
        }
      }
    }

    public final func setProperty<T: CSSPropertyValue>(
      _ property: String, _ value: T, _ priority: String = ""
    ) {
      var propertyBuffer = Array(property.utf8)
      propertyBuffer.append(0)

      propertyBuffer.withUnsafeBufferPointer { propPtr in
        propPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propertyBuffer.count) {
          propertyPointer in
          value.rawValue.withUTF8Buffer { valueBuffer in
            valueBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count)
            { valuePtr in
              var priorityBuffer = Array(priority.utf8)
              priorityBuffer.append(0)

              priorityBuffer.withUnsafeBufferPointer { prioPtr in
                prioPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: priorityBuffer.count)
                { priorityPointer in
                  element_setStyleProperty(
                    elementID, propertyPointer, Int32(propertyBuffer.count - 1), valuePtr,
                    Int32(valueBuffer.count), priorityPointer, Int32(priorityBuffer.count - 1))
                }
              }
            }
          }
        }
      }
    }

    public func setProperty(_ property: String, _ value: StaticString, _ priority: String = "") {
      var propertyBuffer = Array(property.utf8)
      propertyBuffer.append(0)

      propertyBuffer.withUnsafeBufferPointer { propPtr in
        propPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propertyBuffer.count) {
          propertyPointer in
          value.withUTF8Buffer { valueBuffer in
            valueBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count)
            { valuePtr in
              var priorityBuffer = Array(priority.utf8)
              priorityBuffer.append(0)

              priorityBuffer.withUnsafeBufferPointer { prioPtr in
                prioPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: priorityBuffer.count)
                { priorityPointer in
                  element_setStyleProperty(
                    elementID, propertyPointer, Int32(propertyBuffer.count - 1), valuePtr,
                    Int32(valueBuffer.count), priorityPointer, Int32(priorityBuffer.count - 1))
                }
              }
            }
          }
        }
      }
    }

    public func setProperty(_ property: StaticString, _ value: String, _ priority: String = "") {
      property.withUTF8Buffer { propertyBuffer in
        propertyBuffer.baseAddress!.withMemoryRebound(
          to: CChar.self, capacity: propertyBuffer.count
        ) { propertyPointer in
          var valueBuffer = Array(value.utf8)
          valueBuffer.append(0)

          valueBuffer.withUnsafeBufferPointer { valPtr in
            valPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) {
              valuePtr in
              var priorityBuffer = Array(priority.utf8)
              priorityBuffer.append(0)

              priorityBuffer.withUnsafeBufferPointer { prioPtr in
                prioPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: priorityBuffer.count)
                { priorityPointer in
                  element_setStyleProperty(
                    elementID, propertyPointer, Int32(propertyBuffer.count), valuePtr,
                    Int32(valueBuffer.count - 1), priorityPointer, Int32(priorityBuffer.count - 1))
                }
              }
            }
          }
        }
      }
    }

    public final func setProperty<T: CSSPropertyValue>(
      _ property: StaticString, _ value: T, _ priority: String = ""
    ) {
      property.withUTF8Buffer { propertyBuffer in
        propertyBuffer.baseAddress!.withMemoryRebound(
          to: CChar.self, capacity: propertyBuffer.count
        ) { propertyPointer in
          value.rawValue.withUTF8Buffer { valueBuffer in
            valueBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count)
            { valuePtr in
              var priorityBuffer = Array(priority.utf8)
              priorityBuffer.append(0)

              priorityBuffer.withUnsafeBufferPointer { prioPtr in
                prioPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: priorityBuffer.count)
                { priorityPointer in
                  element_setStyleProperty(
                    elementID, propertyPointer, Int32(propertyBuffer.count), valuePtr,
                    Int32(valueBuffer.count), priorityPointer, Int32(priorityBuffer.count - 1))
                }
              }
            }
          }
        }
      }
    }

    public func setProperty(
      _ property: StaticString, _ value: StaticString, _ priority: String = ""
    ) {
      property.withUTF8Buffer { propertyBuffer in
        propertyBuffer.baseAddress!.withMemoryRebound(
          to: CChar.self, capacity: propertyBuffer.count
        ) { propertyPointer in
          value.withUTF8Buffer { valueBuffer in
            valueBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count)
            { valuePtr in
              var priorityBuffer = Array(priority.utf8)
              priorityBuffer.append(0)

              priorityBuffer.withUnsafeBufferPointer { prioPtr in
                prioPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: priorityBuffer.count)
                { priorityPointer in
                  element_setStyleProperty(
                    elementID, propertyPointer, Int32(propertyBuffer.count), valuePtr,
                    Int32(valueBuffer.count), priorityPointer, Int32(priorityBuffer.count - 1))
                }
              }
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

    @_disfavoredOverload
    public final func removeProperty(_ property: CSSPropertyName) {
      removeProperty(property.rawValue)
    }

    public final func removeProperty<T>(_ property: CSSProperty<T>) {
      removeProperty(property.name)
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

    public func getPropertyValue(_ property: CSSPropertyName) -> String {
      let bufferSize = 1024
      var resultBuffer = [UInt8](repeating: 0, count: bufferSize)
      let length = property.rawValue.withUTF8Buffer { propertyBuffer in
        propertyBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propertyBuffer.count)
        { propertyPointer in
          element_getStyleProperty(
            elementID, propertyPointer, Int32(propertyBuffer.count), &resultBuffer, Int32(bufferSize)
          )
        }
      }
      guard length > 0 else { return "" }
      return String(decoding: resultBuffer[0..<Int(length)], as: UTF8.self)
    }

    // MARK: - CSSPropertyName Overloads

    @_disfavoredOverload
    public func setProperty(_ property: CSSPropertyName, _ value: String) {
      setProperty(property.rawValue, value)
    }

    @_disfavoredOverload
    public func setProperty(_ property: CSSPropertyName, _ value: StaticString) {
      setProperty(property.rawValue, value)
    }

    public func setProperty(_ property: CSSPropertyName, _ value: Int, _ priority: CSSPriority = .normal) {
      setProperty(property.rawValue, intToString(value), priority.rawValue)
    }

    @_disfavoredOverload
    public func setProperty(_ property: CSSPropertyName, _ value: String, _ priority: CSSPriority = .normal) {
      setProperty(property.rawValue, value, priority.rawValue)
    }

    public func setProperty(_ property: CSSPropertyName, _ value: CSSKeyword.Length, _ priority: CSSPriority = .normal) {
      setProperty(property.rawValue, value.rawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSPropertyName, _ filters: CSSFilterFunction...) {
      let stringValue = stringJoin(filters.map { $0.value }, separator: " ")
      setProperty(property.rawValue, stringValue)
    }

    // MARK: - Type-Safe CSSProperty Overloads

    public func setProperty(_ property: CSSProperty<CSSColor>, _ value: CSSColor) {
      setProperty(property.name.rawValue, value.value)
    }

    public final func setProperty<T>(_ property: CSSProperty<T>, _ value: Length, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, value.value, priority.rawValue)
    }

    public final func setProperty<T>(_ property: CSSProperty<T>, _ value: Percentage, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, value.value, priority.rawValue)
    }

    public final func setProperty<T>(_ property: CSSProperty<T>, _ value: LengthPercentage, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, value.value, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<Double>, _ value: Double, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, doubleToString(value), priority.rawValue)
    }

    public final func setProperty<T>(_ property: CSSProperty<T>, _ value: Int, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, intToString(value), priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSSDisplay>, _ value: CSSDisplay, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, value.rawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSSDisplay>, _ value: CSSDisplay.Outside, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, value.rawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSSDisplay>, _ value: CSSDisplay.Inside, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, value.rawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSSDisplay>, _ value: CSSDisplay.Internal, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, value.rawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSSVisibility>, _ value: CSSVisibility, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, value.rawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSSPosition>, _ value: CSSPosition, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, value.rawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSSCursor>, _ value: CSSCursor, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, value.value, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSSPointerEvents>, _ value: CSSPointerEvents, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, value.rawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<String>, _ value: String) {
      setProperty(property.name.rawValue, value)
    }

    public func setProperty(_ property: CSSProperty<String>, _ value: CSSTransformFunction) {
      setProperty(property.name.rawValue, value.value)
    }

    public func setProperty(
      _ property: CSSProperty<String>, _ value: (CSSPropertyName, CSSTime, CSSEasingFunction)
    ) {
      let stringValue = "\(value.0.rawValue) \(value.1.value) \(value.2.value)"
      setProperty(property.name.rawValue, stringValue)
    }

    public func setProperty(_ property: CSSProperty<String>, _ value: CSSKeyword.None) {
      setProperty(property.name.rawValue, value.staticRawValue)
    }

    public func setProperty(_ property: CSSProperty<String>, _ value: CSSKeyword.None, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, value.staticRawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<String>, _ value: CSSKeyword.Auto) {
      setProperty(property.name.rawValue, value.staticRawValue)
    }

    public func setProperty(_ property: CSSProperty<String>, _ value: CSSKeyword.Auto, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, value.staticRawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<String>, _ value: CSSKeyword.Global) {
      setProperty(property.name.rawValue, value.staticRawValue)
    }

    public func setProperty(_ property: CSSProperty<String>, _ value: CSSKeyword.Global, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, value.staticRawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSSOverflow>, _ value: CSSOverflow, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, toString(value.staticRawValue), priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSSTextOverflow>, _ value: CSSTextOverflow, _ priority: CSSPriority = .normal) {
      if let staticRaw = value.staticRawValue {
        setProperty(property.name.rawValue, toString(staticRaw), priority.rawValue)
      } else {
        setProperty(property.name.rawValue, value.value, priority.rawValue)
      }
    }

    public func setProperty(_ property: CSSProperty<CSSDisplay>, _ value: CSSDisplay.Legacy, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, toString(value.staticRawValue), priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSSWhiteSpace>, _ value: CSSWhiteSpace, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, toString(value.staticRawValue), priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSSVerticalAlign>, _ value: CSSVerticalAlign, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, value.rawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSSAlignItems>, _ value: CSSAlignItems, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, toString(value.staticRawValue), priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSSJustifyContent>, _ value: CSSJustifyContent, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, toString(value.staticRawValue), priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSSBorderCollapse>, _ value: CSSBorderCollapse, _ priority: CSSPriority = .normal) {
      setProperty(property.name.rawValue, value.rawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSPropertyName, _ value: CSSKeyword.Auto, _ priority: CSSPriority = .normal) {
      setProperty(property.rawValue, toString(value.rawValue), priority.rawValue)
    }

    public func filter(_ value: String) {
      setProperty(.filter, value)
    }

    public func background(_ value: CSSColor) {
      setProperty(.background, value.value)
    }

    public func background(_ value: CSSKeyword.None) {
      setProperty(.background, value.staticRawValue)
    }

    public func background(_ value: CSSKeyword.Global) {
      setProperty(.background, value.staticRawValue)
    }

    public func background(_ value: String) {
      setProperty(.background, value)
    }

    public func backgroundImage(_ value: String) {
      setProperty(.backgroundImage, value)
    }

    public func backgroundRepeat(_ value: CSSBackgroundRepeat) {
      setProperty(.backgroundRepeat, value.rawValue)
    }

    public func backgroundPosition(_ value: CSSBackgroundPosition) {
      if let staticRaw = value.staticRawValue {
        setProperty(.backgroundPosition, staticRaw)
      } else {
        setProperty(.backgroundPosition, value.value)
      }
    }

    public func backgroundPosition(
      _ x: CSSBackgroundPosition, _ xOffset: Length, _ y: CSSBackgroundPosition
    ) {
      let xVal = x.value
      let yVal = y.value
      let stringValue = "\(xVal) \(xOffset.value) \(yVal)"
      setProperty(.backgroundPosition, stringValue)
    }

    public func backgroundPosition(
      _ x: CSSBackgroundPosition, _ xOffset: Length, _ y: CSSBackgroundPosition, _ yOffset: Length
    ) {
      let xVal = x.value
      let yVal = y.value
      let stringValue = "\(xVal) \(xOffset.value) \(yVal) \(yOffset.value)"
      setProperty(.backgroundPosition, stringValue)
    }

    public func borderBottom(_ width: Length, _ style: CSSBorder.LineStyle, _ color: CSSColor) {
      let stringValue = "\(width.value) \(style.value) \(color.value)"
      setProperty(.borderBottom, stringValue)
    }

    @_disfavoredOverload
    public func margin(_ value: Length) {
      setProperty(.margin, value.value)
    }

    @_disfavoredOverload
    public func margin(_ value: LengthPercentage) {
      setProperty(.margin, value.value)
    }

    @_disfavoredOverload
    public func margin(_ value: Percentage) {
      setProperty(.margin, value.value)
    }

    public func margin(_ v: Length, _ h: Length) {
      let stringValue = "\(v.value) \(h.value)"
      setProperty(.margin, stringValue)
    }

    public func margin(_ t: Length, _ r: Length, _ b: Length, _ l: Length) {
      let stringValue = "\(t.value) \(r.value) \(b.value) \(l.value)"
      setProperty(.margin, stringValue)
    }

    @_disfavoredOverload
    public func padding(_ value: Length) {
      setProperty(.padding, value.value)
    }

    @_disfavoredOverload
    public func padding(_ value: LengthPercentage) {
      setProperty(.padding, value.value)
    }

    @_disfavoredOverload
    public func padding(_ value: Percentage) {
      setProperty(.padding, value.value)
    }

    public func padding(_ vertical: LengthPercentage, _ horizontal: LengthPercentage) {
      let value = "\(vertical.value) \(horizontal.value)"
      setProperty(.padding, value)
    }

    public func padding(_ vertical: Length, _ horizontal: Length) {
      let value = "\(vertical.value) \(horizontal.value)"
      setProperty(.padding, value)
    }

    public func padding(_ t: Length, _ r: Length, _ b: Length, _ l: Length) {
      let value = "\(t.value) \(r.value) \(b.value) \(l.value)"
      setProperty(.padding, value)
    }

    public func padding(
      _ t: LengthPercentage, _ r: LengthPercentage, _ b: LengthPercentage, _ l: LengthPercentage
    ) {
      let value = "\(t.value) \(r.value) \(b.value) \(l.value)"
      setProperty(.padding, value)
    }

    // MARK: - Dimension Properties

    @_disfavoredOverload
    public func height(_ value: Length) {
      setProperty(.height, value.value)
    }

    @_disfavoredOverload
    public func height(_ value: LengthPercentage) {
      setProperty(.height, value.value)
    }

    @_disfavoredOverload
    public func height(_ value: Percentage) {
      setProperty(.height, value.value)
    }

    public func height(_ value: CSSKeyword.Auto) {
      setProperty(.height, value.staticRawValue)
    }

    public func height(_ value: CSSKeyword.Global) {
      setProperty(.height, value.staticRawValue)
    }

    // MARK: - User Interaction

    @_disfavoredOverload
    public func userSelect(_ value: CSSUserSelect) {
      setProperty(.userSelect, value.staticRawValue)
    }

    @_disfavoredOverload
    public func userSelect(_ value: String) {
      setProperty(.userSelect, value)
    }

    public func userSelect(_ value: CSSKeyword.Auto) {
      setProperty(.userSelect, value.staticRawValue)
    }

    public func userSelect(_ value: CSSKeyword.None) {
      setProperty(.userSelect, value.staticRawValue)
    }

    public func userSelect(_ value: CSSKeyword.Global) {
      setProperty(.userSelect, value.staticRawValue)
    }

    @_disfavoredOverload
    public func cursor(_ value: CSSCursor) {
      if let staticRawValue = value.staticRawValue {
        setProperty(.cursor, staticRawValue)
      } else {
        setProperty(.cursor, value.value)
      }
    }

    @_disfavoredOverload
    public func cursor(_ value: String) {
      setProperty(.cursor, value)
    }

    public func cursor(_ value: CSSKeyword.Auto) {
      setProperty(.cursor, value.staticRawValue)
    }

    public func cursor(_ value: CSSKeyword.None) {
      setProperty(.cursor, value.staticRawValue)
    }

    public func cursor(_ value: CSSKeyword.Global) {
      setProperty(.cursor, value.staticRawValue)
    }

    // MARK: - Box Model

    public func boxSizing(_ value: CSSBoxSizing) {
      if let staticRawValue = value.staticRawValue {
        setProperty(.boxSizing, staticRawValue)
      } else {
        setProperty(.boxSizing, value.value)
      }
    }

    @_disfavoredOverload
    public func boxSizing(_ value: String) {
      setProperty(.boxSizing, value)
    }

    public func backgroundClip(_ value: CSSBackgroundClip) {
      if let staticRawValue = value.staticRawValue {
        setProperty(.backgroundClip, staticRawValue)
      } else {
        setProperty(.backgroundClip, value.value)
      }
    }

    public func backgroundClip(_ value: CSSKeyword.Global) {
      setProperty(.backgroundClip, value.staticRawValue)
    }

    // MARK: - Text Decoration

    @_disfavoredOverload
    public func textDecoration(_ value: CSSTextDecoration) {
      if let staticRawValue = value.staticRawValue {
        setProperty(.textDecoration, staticRawValue)
      } else {
        setProperty(.textDecoration, value.value)
      }
    }

    @_disfavoredOverload
    public func textDecoration(_ value: String) {
      setProperty(.textDecoration, value)
    }

    public func textDecoration(_ value: CSSKeyword.None) {
      setProperty(.textDecoration, value.staticRawValue)
    }

    public func textDecoration(_ value: CSSKeyword.Global) {
      setProperty(.textDecoration, value.staticRawValue)
    }

    // MARK: - Outline

    public func outline(_ width: Length, _ style: CSSBorder.LineStyle, _ color: CSSColor) {
      let stringValue = "\(width.value) \(style.value) \(color.value)"
      setProperty(.outline, stringValue)
    }

    public func outline(_ value: Length) {
      setProperty(.outline, value.value)
    }

    public func outline(_ value: CSSKeyword.None) {
      setProperty(.outline, value.staticRawValue)
    }

    public func outline(_ value: CSSKeyword.Global) {
      setProperty(.outline, value.staticRawValue)
    }

    public func borderRadius(_ value: Length) {
      setProperty(.borderRadius, value.value)
    }

    public func borderRadius(_ value: Percentage) {
      setProperty(.borderRadius, value.value)
    }

    public func borderRadius(_ value: LengthPercentage) {
      setProperty(.borderRadius, value.value)
    }

    public func borderLeft(_ width: Length, _ style: CSSBorder.LineStyle, _ color: CSSColor) {
      let stringValue = "\(width.value) \(style.value) \(color.value)"
      setProperty(.borderLeft, stringValue)
    }

    @_disfavoredOverload
    public func whiteSpace(_ value: CSSWhiteSpace) {
      setProperty(.whiteSpace, value.staticRawValue)
    }

    @_disfavoredOverload
    public func whiteSpace(_ value: String) {
      setProperty(.whiteSpace, value)
    }

    @_disfavoredOverload
    public func boxShadow(_ value: CSSSpreadShadow) {
      setProperty(.boxShadow, value.value)
    }

    @_disfavoredOverload
    public func boxShadow(_ value: String) {
      setProperty(.boxShadow, value)
    }

    public func boxShadow(_ value: CSSKeyword.None) {
      setProperty(.boxShadow, value.staticRawValue)
    }

    public func boxShadow(_ value: CSSKeyword.Global) {
      setProperty(.boxShadow, value.staticRawValue)
    }

    public func boxShadow(_ value: (Length, Length, Length, CSSColor)) {
      let stringValue = "\(value.0.value) \(value.1.value) \(value.2.value) \(value.3.value)"
      setProperty(.boxShadow, stringValue)
    }

    public func boxShadow(_ value: (Int, Length, Length, CSSColor)) {
      let offsetX = value.0 == 0 ? "0" : intToString(value.0)
      let stringValue = "\(offsetX) \(value.1.value) \(value.2.value) \(value.3.value)"
      setProperty(.boxShadow, stringValue)
    }

    public func boxShadow(_ value: (Length, Length, Length, Length, CSSColor)) {
      let stringValue =
        "\(value.0.value) \(value.1.value) \(value.2.value) \(value.3.value) \(value.4.value)"
      setProperty(.boxShadow, stringValue)
    }

    @_disfavoredOverload
    public func fontStyle(_ value: CSSFontStyle) {
      setProperty(.fontStyle, value.rawValue)
    }

    @_disfavoredOverload
    public func fontStyle(_ value: String) {
      setProperty(.fontStyle, value)
    }

    public func color(_ value: CSSColor) {
      setProperty(.color, value.value)
    }

    public func backgroundColor(_ value: CSSColor) {
      setProperty(.backgroundColor, value)
    }

    public func backgroundColor(_ value: CSSKeyword.Transparent) {
      setProperty(.backgroundColor, value.rawValue)
    }

    public func borderColor(_ value: CSSColor) {
      setProperty(.borderColor, value.value)
    }

    public func outlineOffset(_ value: Length) {
      setProperty(.outlineOffset, value.value)
    }

    // MARK: - Explicit Property Methods for Discovery

    @_disfavoredOverload
    public func minHeight(_ value: Length) {
      setProperty(.minHeight, value.value)
    }

    @_disfavoredOverload
    public func minHeight(_ value: LengthPercentage) {
      setProperty(.minHeight, value.value)
    }

    @_disfavoredOverload
    public func minHeight(_ value: Percentage) {
      setProperty(.minHeight, value.value)
    }

    public func minHeight(_ value: CSSKeyword.Auto) {
      setProperty(.minHeight, value.staticRawValue)
    }

    public func minHeight(_ value: CSSKeyword.Length) {
      setProperty(.minHeight, value.rawValue)
    }

    @_disfavoredOverload
    public func maxHeight(_ value: Length) {
      setProperty(.maxHeight, value.value)
    }

    @_disfavoredOverload
    public func maxHeight(_ value: LengthPercentage) {
      setProperty(.maxHeight, value.value)
    }

    @_disfavoredOverload
    public func maxHeight(_ value: Percentage) {
      setProperty(.maxHeight, value.value)
    }

    public func maxHeight(_ value: CSSKeyword.Auto) {
      setProperty(.maxHeight, value.staticRawValue)
    }

    public func maxHeight(_ value: CSSKeyword.None) {
      setProperty(.maxHeight, value.staticRawValue)
    }

    public func maxHeight(_ value: CSSKeyword.Length) {
      setProperty(.maxHeight, value.rawValue)
    }

    @_disfavoredOverload
    public func minWidth(_ value: Length) {
      setProperty(.minWidth, value.value)
    }

    @_disfavoredOverload
    public func minWidth(_ value: LengthPercentage) {
      setProperty(.minWidth, value.value)
    }

    @_disfavoredOverload
    public func minWidth(_ value: Percentage) {
      setProperty(.minWidth, value.value)
    }

    public func minWidth(_ value: CSSKeyword.Auto) {
      setProperty(.minWidth, value.staticRawValue)
    }

    public func minWidth(_ value: CSSKeyword.Length) {
      setProperty(.minWidth, value.rawValue)
    }

    @_disfavoredOverload
    public func maxWidth(_ value: Length) {
      setProperty(.maxWidth, value.value)
    }

    @_disfavoredOverload
    public func maxWidth(_ value: LengthPercentage) {
      setProperty(.maxWidth, value.value)
    }

    @_disfavoredOverload
    public func maxWidth(_ value: Percentage) {
      setProperty(.maxWidth, value.value)
    }

    public func maxWidth(_ value: CSSKeyword.Auto) {
      setProperty(.maxWidth, value.staticRawValue)
    }

    public func maxWidth(_ value: CSSKeyword.None) {
      setProperty(.maxWidth, value.staticRawValue)
    }

    public func maxWidth(_ value: CSSKeyword.Length) {
      setProperty(.maxWidth, value.rawValue)
    }

    @_disfavoredOverload
    public func width(_ value: Length) {
      setProperty(.width, value.value)
    }

    @_disfavoredOverload
    public func width(_ value: LengthPercentage) {
      setProperty(.width, value.value)
    }

    @_disfavoredOverload
    public func width(_ value: Percentage) {
      setProperty(.width, value.value)
    }

    public func width(_ value: CSSKeyword.Auto) {
      setProperty(.width, value.staticRawValue)
    }

    public func width(_ value: CSSKeyword.Length) {
      setProperty(.width, value.rawValue)
    }

    public func borderRight(_ width: Length, _ style: CSSBorder.LineStyle, _ color: CSSColor) {
      let stringValue = "\(width.value) \(style.value) \(color.value)"
      setProperty(.borderRight, stringValue)
    }

    public func borderInlineEnd(_ width: Length, _ style: CSSBorder.LineStyle, _ color: CSSColor) {
      let stringValue = "\(width.value) \(style.value) \(color.value)"
      setProperty(.borderInlineEnd, stringValue)
    }

    public func borderTop(_ width: Length, _ style: CSSBorder.LineStyle, _ color: CSSColor) {
      let stringValue = "\(width.value) \(style.value) \(color.value)"
      setProperty(.borderTop, stringValue)
    }

    public func borderWidth(_ value: Length) {
      setProperty(.borderWidth, value.value)
    }

    public func borderTopWidth(_ value: Length) {
      setProperty(.borderTopWidth, value.value)
    }

    public func borderBottomWidth(_ value: Length) {
      setProperty(.borderBottomWidth, value.value)
    }

    public func borderLeftWidth(_ value: Length) {
      setProperty(.borderLeftWidth, value.value)
    }

    public func borderRightWidth(_ value: Length) {
      setProperty(.borderRightWidth, value.value)
    }

    public func gap(_ value: Length) {
      setProperty(.gap, value.value)
    }

    @_disfavoredOverload
    public func flexDirection(_ value: CSSFlexDirection) {
      setProperty(.flexDirection, value.rawValue)
    }

    @_disfavoredOverload
    public func flexDirection(_ value: String) {
      setProperty(.flexDirection, value)
    }

    public func flex(_ value: Int) {
      setProperty(.flex, intToString(value))
    }

    @_disfavoredOverload
    public func justifyContent(_ value: CSSJustifyContent) {
      setProperty(.justifyContent, value.rawValue)
    }

    @_disfavoredOverload
    public func justifyContent(_ value: String) {
      setProperty(.justifyContent, value)
    }

    @_disfavoredOverload
    public func alignItems(_ value: CSSAlignItems) {
      setProperty(.alignItems, value.rawValue)
    }

    @_disfavoredOverload
    public func alignItems(_ value: String) {
      setProperty(.alignItems, value)
    }

    public func fontFamily(_ value: CSSFontFamily) {
      setProperty(.fontFamily, value.value)
    }

    public func fontFamily(_ value: String) {
      setProperty(.fontFamily, value)
    }

    public func fontFamily(_ value: CSSKeyword.Global) {
      setProperty(.fontFamily, value.staticRawValue)
    }

    public func fontFamily(_ value: CSSKeyword.None) {
      setProperty(.fontFamily, value.staticRawValue)
    }

    public func fontSize(_ value: Length) {
      setProperty(.fontSize, value.value)
    }

    public func fontWeight(_ value: CSSFontWeight) {
      setProperty(.fontWeight, value.value)
    }

    public func lineHeight(_ value: Double) {
      setProperty(.lineHeight, doubleToString(value))
    }

    public func lineHeight(_ value: Length) {
      setProperty(.lineHeight, value.value)
    }

    public func lineHeight(_ value: LengthPercentage) {
      setProperty(.lineHeight, value.value)
    }

    public func overflowWrap(_ value: String) {
      setProperty(.overflowWrap, value)
    }

    public func overflowWrap(_ value: CSSWordWrap) {
      setProperty(.overflowWrap, value.rawValue)
    }

    public func paddingLeft(_ value: Length) {
      setProperty(.paddingLeft, value.value)
    }

    public func paddingLeft(_ value: LengthPercentage) {
      setProperty(.paddingLeft, value.value)
    }

    public func paddingLeft(_ value: Percentage) {
      setProperty(.paddingLeft, value.value)
    }

    public func paddingRight(_ value: Length) {
      setProperty(.paddingRight, value.value)
    }

    public func paddingRight(_ value: LengthPercentage) {
      setProperty(.paddingRight, value.value)
    }

    public func paddingRight(_ value: Percentage) {
      setProperty(.paddingRight, value.value)
    }

    public func paddingTop(_ value: Length) {
      setProperty(.paddingTop, value.value)
    }

    public func paddingTop(_ value: LengthPercentage) {
      setProperty(.paddingTop, value.value)
    }

    public func paddingTop(_ value: Percentage) {
      setProperty(.paddingTop, value.value)
    }

    public func paddingBottom(_ value: Length) {
      setProperty(.paddingBottom, value.value)
    }

    public func paddingBottom(_ value: LengthPercentage) {
      setProperty(.paddingBottom, value.value)
    }

    public func paddingBottom(_ value: Percentage) {
      setProperty(.paddingBottom, value.value)
    }

    public func marginLeft(_ value: Length) {
      setProperty(.marginLeft, value.value)
    }

    public func marginLeft(_ value: LengthPercentage) {
      setProperty(.marginLeft, value.value)
    }

    public func marginLeft(_ value: Percentage) {
      setProperty(.marginLeft, value.value)
    }

    public func marginRight(_ value: Length) {
      setProperty(.marginRight, value.value)
    }

    public func marginRight(_ value: LengthPercentage) {
      setProperty(.marginRight, value.value)
    }

    public func marginRight(_ value: Percentage) {
      setProperty(.marginRight, value.value)
    }

    public func marginTop(_ value: Length) {
      setProperty(.marginTop, value.value)
    }

    public func marginTop(_ value: LengthPercentage) {
      setProperty(.marginTop, value.value)
    }

    public func marginTop(_ value: Percentage) {
      setProperty(.marginTop, value.value)
    }

    public func marginBottom(_ value: Length) {
      setProperty(.marginBottom, value.value)
    }

    public func marginBottom(_ value: LengthPercentage) {
      setProperty(.marginBottom, value.value)
    }

    public func marginBottom(_ value: Percentage) {
      setProperty(.marginBottom, value.value)
    }

    public func margin(_ value: CSSKeyword.Auto) {
      setProperty(.margin, value.staticRawValue)
    }

    public func margin(_ value: CSSKeyword.Global) {
      setProperty(.margin, value.staticRawValue)
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
      setProperty(.border, stringValue)
    }

    // Helper for border with CSSBorder
    @_disfavoredOverload
    public func border(_ value: CSSBorder) {
      setProperty(.border, value.value)
    }

    @_disfavoredOverload
    public func border(_ value: String) {
      setProperty(.border, value)
    }

    public func border(_ value: CSSKeyword.None) {
      setProperty(.border, value.staticRawValue)
    }

    public func border(_ value: CSSKeyword.Global) {
      setProperty(.border, value.staticRawValue)
    }

    public func mask(_ value: CSSKeyword.None) {
      setProperty(.mask, value.staticRawValue)
    }

    public func mask(_ value: CSSKeyword.Global) {
      setProperty(.mask, value.staticRawValue)
    }

    @_disfavoredOverload
    public func mask(_ value: CSSMaskLayer) {
      setProperty(.mask, value.value)
    }

    @_disfavoredOverload
    public func mask(_ value: String) {
      setProperty(.mask, value)
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
                      Int32(valueBuffer.count), nil, 0)
                  }
                }
              }
            }
          }
        }
        return
      }

      let stringValue = "\(property.value) \(duration.value) \(timingFunction.value)"
      setProperty(.transition, stringValue)
    }

    public func transition(
      _ keyword: CSSKeyword.All, _ duration: CSSTime, _ timingFunction: CSSEasingFunction
    ) {
      setProperty(.transition, "all \(duration.value) \(timingFunction.value)")
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
