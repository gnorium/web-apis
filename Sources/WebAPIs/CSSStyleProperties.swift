#if CLIENT
  import CSSBuilder
  import CSSOMBuilder
  import EmbeddedSwiftUtilities
  import WebTypes

  @dynamicMemberLookup
  public class CSSStyleProperties: CSSOM.CSSStyleDeclaration, @unchecked Sendable {
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

    public func setProperty(_ property: CSSPropertyName, _ value: Int, _ priority: CSS.Priority = .normal) {
      setProperty(property.rawValue, intToString(value), priority.rawValue)
    }

    @_disfavoredOverload
    public func setProperty(_ property: CSSPropertyName, _ value: String, _ priority: CSS.Priority = .normal) {
      setProperty(property.rawValue, value, priority.rawValue)
    }

    public func setProperty(_ property: CSSPropertyName, _ value: CSS.Keyword.Length, _ priority: CSS.Priority = .normal) {
      setProperty(property.rawValue, value.rawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSPropertyName, _ value: CSS.Length, _ priority: CSS.Priority = .normal) {
      setProperty(property.rawValue, value.value, priority.rawValue)
    }

    public func setProperty(_ property: CSSPropertyName, _ value: CSS.Percentage, _ priority: CSS.Priority = .normal) {
      setProperty(property.rawValue, value.value, priority.rawValue)
    }

    public func setProperty(_ property: CSSPropertyName, _ value: CSS.LengthPercentage, _ priority: CSS.Priority = .normal) {
      setProperty(property.rawValue, value.value, priority.rawValue)
    }

    public func setProperty(_ property: CSSPropertyName, _ filters: CSS.FilterFunction...) {
      let stringValue = stringJoin(filters.map { $0.value }, separator: " ")
      setProperty(property.rawValue, stringValue)
    }

    // MARK: - Type-Safe CSSProperty Overloads

    public func setProperty(_ property: CSSProperty<CSS.Color>, _ value: CSS.Color) {
      setProperty(property.name.rawValue, value.value)
    }

    public final func setProperty<T>(_ property: CSSProperty<T>, _ value: CSS.Length, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, value.value, priority.rawValue)
    }

    public final func setProperty<T>(_ property: CSSProperty<T>, _ value: CSS.Percentage, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, value.value, priority.rawValue)
    }

    public final func setProperty<T>(_ property: CSSProperty<T>, _ value: CSS.LengthPercentage, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, value.value, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<Double>, _ value: Double, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, doubleToString(value), priority.rawValue)
    }

    public final func setProperty<T>(_ property: CSSProperty<T>, _ value: Int, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, intToString(value), priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSS.Display>, _ value: CSS.Display, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, value.rawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSS.Display>, _ value: CSS.Display.Outside, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, value.rawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSS.Display>, _ value: CSS.Display.Inside, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, value.rawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSS.Display>, _ value: CSS.Display.Internal, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, value.rawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSS.Visibility>, _ value: CSS.Visibility, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, value.rawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSS.Position>, _ value: CSS.Position, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, value.rawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSS.Cursor>, _ value: CSS.Cursor, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, value.value, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSS.PointerEvents>, _ value: CSS.PointerEvents, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, value.rawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<String>, _ value: String) {
      setProperty(property.name.rawValue, value)
    }

    public func setProperty(_ property: CSSProperty<String>, _ value: CSS.TransformFunction) {
      setProperty(property.name.rawValue, value.value)
    }

    public func setProperty(
      _ property: CSSProperty<String>, _ value: (CSSPropertyName, CSS.Time, CSS.EasingFunction)
    ) {
      let stringValue = "\(value.0.rawValue) \(value.1.value) \(value.2.value)"
      setProperty(property.name.rawValue, stringValue)
    }

    public func setProperty(_ property: CSSProperty<String>, _ value: CSS.Keyword.None) {
      setProperty(property.name.rawValue, value.staticRawValue)
    }

    public func setProperty(_ property: CSSProperty<String>, _ value: CSS.Keyword.None, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, value.staticRawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<String>, _ value: CSS.Keyword.Auto) {
      setProperty(property.name.rawValue, value.staticRawValue)
    }

    public func setProperty(_ property: CSSProperty<String>, _ value: CSS.Keyword.Auto, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, value.staticRawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<String>, _ value: CSS.Keyword.Global) {
      setProperty(property.name.rawValue, value.staticRawValue)
    }

    public func setProperty(_ property: CSSProperty<String>, _ value: CSS.Keyword.Global, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, value.staticRawValue, priority.rawValue)
    }

    public final func setProperty<T>(_ property: CSSProperty<T>, _ value: CSS.Keyword.Global) {
      setProperty(property.name.rawValue, value.staticRawValue)
    }

    public final func setProperty<T>(_ property: CSSProperty<T>, _ value: CSS.Keyword.Global, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, value.staticRawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSS.Overflow>, _ value: CSS.Overflow, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, toString(value.staticRawValue), priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSS.TextOverflow>, _ value: CSS.TextOverflow, _ priority: CSS.Priority = .normal) {
      if let staticRaw = value.staticRawValue {
        setProperty(property.name.rawValue, toString(staticRaw), priority.rawValue)
      } else {
        setProperty(property.name.rawValue, value.value, priority.rawValue)
      }
    }

    public func setProperty(_ property: CSSProperty<CSS.Display>, _ value: CSS.Display.Legacy, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, toString(value.staticRawValue), priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSS.WhiteSpace>, _ value: CSS.WhiteSpace, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, toString(value.staticRawValue), priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSS.VerticalAlign>, _ value: CSS.VerticalAlign, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, value.rawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSS.AlignItems>, _ value: CSS.AlignItems, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, toString(value.staticRawValue), priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSS.JustifyContent>, _ value: CSS.JustifyContent, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, toString(value.staticRawValue), priority.rawValue)
    }

    public func setProperty(_ property: CSSProperty<CSS.BorderCollapse>, _ value: CSS.BorderCollapse, _ priority: CSS.Priority = .normal) {
      setProperty(property.name.rawValue, value.rawValue, priority.rawValue)
    }

    public func setProperty(_ property: CSSPropertyName, _ value: CSS.Keyword.Auto, _ priority: CSS.Priority = .normal) {
      setProperty(property.rawValue, toString(value.rawValue), priority.rawValue)
    }

    public func filter(_ value: String) {
      setProperty(.filter, value)
    }

    public func background(_ value: CSS.Color) {
      setProperty(.background, value.value)
    }

    public func background(_ value: CSS.Keyword.None) {
      setProperty(.background, value.staticRawValue)
    }

    public func background(_ value: CSS.Keyword.Global) {
      setProperty(.background, value.staticRawValue)
    }

    public func background(_ value: String) {
      setProperty(.background, value)
    }

    public func backgroundImage(_ value: String) {
      setProperty(.backgroundImage, value)
    }

    public func backgroundRepeat(_ value: CSS.BackgroundRepeat) {
      setProperty(.backgroundRepeat, value.rawValue)
    }

    public func backgroundPosition(_ value: CSS.BackgroundPosition) {
      if let staticRaw = value.staticRawValue {
        setProperty(.backgroundPosition, staticRaw)
      } else {
        setProperty(.backgroundPosition, value.value)
      }
    }

    public func backgroundPosition(
      _ x: CSS.BackgroundPosition, _ xOffset: CSS.Length, _ y: CSS.BackgroundPosition
    ) {
      let xVal = x.value
      let yVal = y.value
      let stringValue = "\(xVal) \(xOffset.value) \(yVal)"
      setProperty(.backgroundPosition, stringValue)
    }

    public func backgroundPosition(
      _ x: CSS.BackgroundPosition, _ xOffset: CSS.Length, _ y: CSS.BackgroundPosition, _ yOffset: CSS.Length
    ) {
      let xVal = x.value
      let yVal = y.value
      let stringValue = "\(xVal) \(xOffset.value) \(yVal) \(yOffset.value)"
      setProperty(.backgroundPosition, stringValue)
    }

    public func borderBottom(_ width: CSS.Length, _ style: CSS.Border.LineStyle, _ color: CSS.Color) {
      let stringValue = "\(width.value) \(style.value) \(color.value)"
      setProperty(.borderBottom, stringValue)
    }

    @_disfavoredOverload
    public func margin(_ value: CSS.Length) {
      setProperty(.margin, value.value)
    }

    @_disfavoredOverload
    public func margin(_ value: CSS.LengthPercentage) {
      setProperty(.margin, value.value)
    }

    @_disfavoredOverload
    public func margin(_ value: CSS.Percentage) {
      setProperty(.margin, value.value)
    }

    public func margin(_ v: CSS.Length, _ h: CSS.Length) {
      let stringValue = "\(v.value) \(h.value)"
      setProperty(.margin, stringValue)
    }

    public func margin(_ t: CSS.Length, _ r: CSS.Length, _ b: CSS.Length, _ l: CSS.Length) {
      let stringValue = "\(t.value) \(r.value) \(b.value) \(l.value)"
      setProperty(.margin, stringValue)
    }

    @_disfavoredOverload
    public func padding(_ value: CSS.Length) {
      setProperty(.padding, value.value)
    }

    @_disfavoredOverload
    public func padding(_ value: CSS.LengthPercentage) {
      setProperty(.padding, value.value)
    }

    @_disfavoredOverload
    public func padding(_ value: CSS.Percentage) {
      setProperty(.padding, value.value)
    }

    public func padding(_ vertical: CSS.LengthPercentage, _ horizontal: CSS.LengthPercentage) {
      let value = "\(vertical.value) \(horizontal.value)"
      setProperty(.padding, value)
    }

    public func padding(_ vertical: CSS.Length, _ horizontal: CSS.Length) {
      let value = "\(vertical.value) \(horizontal.value)"
      setProperty(.padding, value)
    }

    public func padding(_ t: CSS.Length, _ r: CSS.Length, _ b: CSS.Length, _ l: CSS.Length) {
      let value = "\(t.value) \(r.value) \(b.value) \(l.value)"
      setProperty(.padding, value)
    }

    public func padding(
      _ t: CSS.LengthPercentage, _ r: CSS.LengthPercentage, _ b: CSS.LengthPercentage, _ l: CSS.LengthPercentage
    ) {
      let value = "\(t.value) \(r.value) \(b.value) \(l.value)"
      setProperty(.padding, value)
    }

    // MARK: - Dimension Properties

    @_disfavoredOverload
    public func height(_ value: CSS.Length) {
      setProperty(.height, value.value)
    }

    @_disfavoredOverload
    public func height(_ value: CSS.LengthPercentage) {
      setProperty(.height, value.value)
    }

    @_disfavoredOverload
    public func height(_ value: CSS.Percentage) {
      setProperty(.height, value.value)
    }

    public func height(_ value: CSS.Keyword.Auto) {
      setProperty(.height, value.staticRawValue)
    }

    public func height(_ value: CSS.Keyword.Global) {
      setProperty(.height, value.staticRawValue)
    }

    // MARK: - User Interaction

    @_disfavoredOverload
    public func userSelect(_ value: CSS.UserSelect) {
      setProperty(.userSelect, value.staticRawValue)
    }

    @_disfavoredOverload
    public func userSelect(_ value: String) {
      setProperty(.userSelect, value)
    }

    public func userSelect(_ value: CSS.Keyword.Auto) {
      setProperty(.userSelect, value.staticRawValue)
    }

    public func userSelect(_ value: CSS.Keyword.None) {
      setProperty(.userSelect, value.staticRawValue)
    }

    public func userSelect(_ value: CSS.Keyword.Global) {
      setProperty(.userSelect, value.staticRawValue)
    }

    public func webkitUserSelect(_ value: CSS.Keyword.None) {
      setProperty(.webkitUserSelect, value.staticRawValue)
    }

    public func webkitTouchCallout(_ value: CSS.Keyword.None) {
      setProperty(.webkitTouchCallout, value.staticRawValue)
    }

    @_disfavoredOverload
    public func cursor(_ value: CSS.Cursor) {
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

    public func cursor(_ value: CSS.Keyword.Auto) {
      setProperty(.cursor, value.staticRawValue)
    }

    public func cursor(_ value: CSS.Keyword.None) {
      setProperty(.cursor, value.staticRawValue)
    }

    public func cursor(_ value: CSS.Keyword.Global) {
      setProperty(.cursor, value.staticRawValue)
    }

    // MARK: - Box Model

    public func boxSizing(_ value: CSS.BoxSizing) {
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

    public func backgroundClip(_ value: CSS.BackgroundClip) {
      if let staticRawValue = value.staticRawValue {
        setProperty(.backgroundClip, staticRawValue)
      } else {
        setProperty(.backgroundClip, value.value)
      }
    }

    public func backgroundClip(_ value: CSS.Keyword.Global) {
      setProperty(.backgroundClip, value.staticRawValue)
    }

    // MARK: - DOM.Text Decoration

    @_disfavoredOverload
    public func textDecoration(_ value: CSS.TextDecoration) {
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

    public func textDecoration(_ value: CSS.Keyword.None) {
      setProperty(.textDecoration, value.staticRawValue)
    }

    public func textDecoration(_ value: CSS.Keyword.Global) {
      setProperty(.textDecoration, value.staticRawValue)
    }

    // MARK: - Outline

    public func outline(_ width: CSS.Length, _ style: CSS.Border.LineStyle, _ color: CSS.Color) {
      let stringValue = "\(width.value) \(style.value) \(color.value)"
      setProperty(.outline, stringValue)
    }

    public func outline(_ value: CSS.Length) {
      setProperty(.outline, value.value)
    }

    public func outline(_ value: CSS.Keyword.None) {
      setProperty(.outline, value.staticRawValue)
    }

    public func outline(_ value: CSS.Keyword.Global) {
      setProperty(.outline, value.staticRawValue)
    }

    public func borderRadius(_ value: CSS.Length) {
      setProperty(.borderRadius, value.value)
    }

    public func borderRadius(_ value: CSS.Percentage) {
      setProperty(.borderRadius, value.value)
    }

    public func borderRadius(_ value: CSS.LengthPercentage) {
      setProperty(.borderRadius, value.value)
    }

    public func borderLeft(_ width: CSS.Length, _ style: CSS.Border.LineStyle, _ color: CSS.Color) {
      let stringValue = "\(width.value) \(style.value) \(color.value)"
      setProperty(.borderLeft, stringValue)
    }

    @_disfavoredOverload
    public func whiteSpace(_ value: CSS.WhiteSpace) {
      setProperty(.whiteSpace, value.staticRawValue)
    }

    @_disfavoredOverload
    public func whiteSpace(_ value: String) {
      setProperty(.whiteSpace, value)
    }

    @_disfavoredOverload
    public func boxShadow(_ value: CSS.SpreadShadow) {
      setProperty(.boxShadow, value.value)
    }

    @_disfavoredOverload
    public func boxShadow(_ value: String) {
      setProperty(.boxShadow, value)
    }

    public func boxShadow(_ value: CSS.Keyword.None) {
      setProperty(.boxShadow, value.staticRawValue)
    }

    public func boxShadow(_ value: CSS.Keyword.Global) {
      setProperty(.boxShadow, value.staticRawValue)
    }

    public func boxShadow(_ value: (CSS.Length, CSS.Length, CSS.Length, CSS.Color)) {
      let stringValue = "\(value.0.value) \(value.1.value) \(value.2.value) \(value.3.value)"
      setProperty(.boxShadow, stringValue)
    }

    public func boxShadow(_ value: (Int, CSS.Length, CSS.Length, CSS.Color)) {
      let offsetX = value.0 == 0 ? "0" : intToString(value.0)
      let stringValue = "\(offsetX) \(value.1.value) \(value.2.value) \(value.3.value)"
      setProperty(.boxShadow, stringValue)
    }

    public func boxShadow(_ value: (CSS.Length, CSS.Length, CSS.Length, CSS.Length, CSS.Color)) {
      let stringValue =
        "\(value.0.value) \(value.1.value) \(value.2.value) \(value.3.value) \(value.4.value)"
      setProperty(.boxShadow, stringValue)
    }

    public func boxShadow(_ offsetX: CSS.Length, _ offsetY: CSS.Length, _ blur: CSS.Length, _ spread: CSS.Length, _ color: CSS.Color) {
      let stringValue = "\(offsetX.value) \(offsetY.value) \(blur.value) \(spread.value) \(color.value)"
      setProperty(.boxShadow, stringValue)
    }

    @_disfavoredOverload
    public func fontStyle(_ value: CSS.FontStyle) {
      setProperty(.fontStyle, value.rawValue)
    }

    @_disfavoredOverload
    public func fontStyle(_ value: String) {
      setProperty(.fontStyle, value)
    }

    public func color(_ value: CSS.Color) {
      setProperty(.color, value.value)
    }

    public func backgroundColor(_ value: CSS.Color) {
      setProperty(.backgroundColor, value)
    }

    public func backgroundColor(_ value: CSS.Keyword.Transparent) {
      setProperty(.backgroundColor, value.rawValue)
    }

    public func borderColor(_ value: CSS.Color) {
      setProperty(.borderColor, value.value)
    }

    public func outlineOffset(_ value: CSS.Length) {
      setProperty(.outlineOffset, value.value)
    }

    // MARK: - Explicit Property Methods for Discovery

    @_disfavoredOverload
    public func minHeight(_ value: CSS.Length) {
      setProperty(.minHeight, value.value)
    }

    @_disfavoredOverload
    public func minHeight(_ value: CSS.LengthPercentage) {
      setProperty(.minHeight, value.value)
    }

    @_disfavoredOverload
    public func minHeight(_ value: CSS.Percentage) {
      setProperty(.minHeight, value.value)
    }

    public func minHeight(_ value: CSS.Keyword.Auto) {
      setProperty(.minHeight, value.staticRawValue)
    }

    public func minHeight(_ value: CSS.Keyword.Length) {
      setProperty(.minHeight, value.rawValue)
    }

    @_disfavoredOverload
    public func maxHeight(_ value: CSS.Length) {
      setProperty(.maxHeight, value.value)
    }

    @_disfavoredOverload
    public func maxHeight(_ value: CSS.LengthPercentage) {
      setProperty(.maxHeight, value.value)
    }

    @_disfavoredOverload
    public func maxHeight(_ value: CSS.Percentage) {
      setProperty(.maxHeight, value.value)
    }

    public func maxHeight(_ value: CSS.Keyword.Auto) {
      setProperty(.maxHeight, value.staticRawValue)
    }

    public func maxHeight(_ value: CSS.Keyword.None) {
      setProperty(.maxHeight, value.staticRawValue)
    }

    public func maxHeight(_ value: CSS.Keyword.Length) {
      setProperty(.maxHeight, value.rawValue)
    }

    @_disfavoredOverload
    public func minWidth(_ value: CSS.Length) {
      setProperty(.minWidth, value.value)
    }

    @_disfavoredOverload
    public func minWidth(_ value: CSS.LengthPercentage) {
      setProperty(.minWidth, value.value)
    }

    @_disfavoredOverload
    public func minWidth(_ value: CSS.Percentage) {
      setProperty(.minWidth, value.value)
    }

    public func minWidth(_ value: CSS.Keyword.Auto) {
      setProperty(.minWidth, value.staticRawValue)
    }

    public func minWidth(_ value: CSS.Keyword.Length) {
      setProperty(.minWidth, value.rawValue)
    }

    @_disfavoredOverload
    public func maxWidth(_ value: CSS.Length) {
      setProperty(.maxWidth, value.value)
    }

    @_disfavoredOverload
    public func maxWidth(_ value: CSS.LengthPercentage) {
      setProperty(.maxWidth, value.value)
    }

    @_disfavoredOverload
    public func maxWidth(_ value: CSS.Percentage) {
      setProperty(.maxWidth, value.value)
    }

    public func maxWidth(_ value: CSS.Keyword.Auto) {
      setProperty(.maxWidth, value.staticRawValue)
    }

    public func maxWidth(_ value: CSS.Keyword.None) {
      setProperty(.maxWidth, value.staticRawValue)
    }

    public func willChange(_ properties: CSS.SingleTransitionProperty...) {
      var result = ""
      for (i, p) in properties.enumerated() {
        result = i == 0 ? p.value : "\(result), \(p.value)"
      }
      setProperty("will-change", result)
    }

    public func maxWidth(_ value: CSS.Keyword.Length) {
      setProperty(.maxWidth, value.rawValue)
    }

    @_disfavoredOverload
    public func width(_ value: CSS.Length) {
      setProperty(.width, value.value)
    }

    @_disfavoredOverload
    public func width(_ value: CSS.LengthPercentage) {
      setProperty(.width, value.value)
    }

    @_disfavoredOverload
    public func width(_ value: CSS.Percentage) {
      setProperty(.width, value.value)
    }

    public func width(_ value: CSS.Keyword.Auto) {
      setProperty(.width, value.staticRawValue)
    }

    public func width(_ value: CSS.Keyword.Length) {
      setProperty(.width, value.rawValue)
    }

    public func borderRight(_ width: CSS.Length, _ style: CSS.Border.LineStyle, _ color: CSS.Color) {
      let stringValue = "\(width.value) \(style.value) \(color.value)"
      setProperty(.borderRight, stringValue)
    }

    public func borderInlineEnd(_ width: CSS.Length, _ style: CSS.Border.LineStyle, _ color: CSS.Color) {
      let stringValue = "\(width.value) \(style.value) \(color.value)"
      setProperty(.borderInlineEnd, stringValue)
    }

    public func borderTop(_ width: CSS.Length, _ style: CSS.Border.LineStyle, _ color: CSS.Color) {
      let stringValue = "\(width.value) \(style.value) \(color.value)"
      setProperty(.borderTop, stringValue)
    }

    public func borderWidth(_ value: CSS.Length) {
      setProperty(.borderWidth, value.value)
    }

    public func borderTopWidth(_ value: CSS.Length) {
      setProperty(.borderTopWidth, value.value)
    }

    public func borderBottomWidth(_ value: CSS.Length) {
      setProperty(.borderBottomWidth, value.value)
    }

    public func borderLeftWidth(_ value: CSS.Length) {
      setProperty(.borderLeftWidth, value.value)
    }

    public func borderRightWidth(_ value: CSS.Length) {
      setProperty(.borderRightWidth, value.value)
    }

    public func gap(_ value: CSS.Length) {
      setProperty(.gap, value.value)
    }

    @_disfavoredOverload
    public func flexDirection(_ value: CSS.FlexDirection) {
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
    public func justifyContent(_ value: CSS.JustifyContent) {
      setProperty(.justifyContent, value.rawValue)
    }

    @_disfavoredOverload
    public func justifyContent(_ value: String) {
      setProperty(.justifyContent, value)
    }

    @_disfavoredOverload
    public func alignItems(_ value: CSS.AlignItems) {
      setProperty(.alignItems, value.rawValue)
    }

    @_disfavoredOverload
    public func alignItems(_ value: String) {
      setProperty(.alignItems, value)
    }

    public func fontFamily(_ value: CSS.FontFamily) {
      setProperty(.fontFamily, value.value)
    }

    public func fontFamily(_ value: String) {
      setProperty(.fontFamily, value)
    }

    public func fontFamily(_ value: CSS.Keyword.Global) {
      setProperty(.fontFamily, value.staticRawValue)
    }

    public func fontFamily(_ value: CSS.Keyword.None) {
      setProperty(.fontFamily, value.staticRawValue)
    }

    public func fontSize(_ value: CSS.Length) {
      setProperty(.fontSize, value.value)
    }

    public func fontWeight(_ value: CSS.FontWeight) {
      setProperty(.fontWeight, value.value)
    }

    public func lineHeight(_ value: Double) {
      setProperty(.lineHeight, doubleToString(value))
    }

    public func lineHeight(_ value: CSS.Length) {
      setProperty(.lineHeight, value.value)
    }

    public func lineHeight(_ value: CSS.LengthPercentage) {
      setProperty(.lineHeight, value.value)
    }

    public func overflowWrap(_ value: String) {
      setProperty(.overflowWrap, value)
    }

    public func overflowWrap(_ value: CSS.WordWrap) {
      setProperty(.overflowWrap, value.rawValue)
    }

    public func paddingLeft(_ value: CSS.Length) {
      setProperty(.paddingLeft, value.value)
    }

    public func paddingLeft(_ value: CSS.LengthPercentage) {
      setProperty(.paddingLeft, value.value)
    }

    public func paddingLeft(_ value: CSS.Percentage) {
      setProperty(.paddingLeft, value.value)
    }

    public func paddingRight(_ value: CSS.Length) {
      setProperty(.paddingRight, value.value)
    }

    public func paddingRight(_ value: CSS.LengthPercentage) {
      setProperty(.paddingRight, value.value)
    }

    public func paddingRight(_ value: CSS.Percentage) {
      setProperty(.paddingRight, value.value)
    }

    public func paddingTop(_ value: CSS.Length) {
      setProperty(.paddingTop, value.value)
    }

    public func paddingTop(_ value: CSS.LengthPercentage) {
      setProperty(.paddingTop, value.value)
    }

    public func paddingTop(_ value: CSS.Percentage) {
      setProperty(.paddingTop, value.value)
    }

    public func paddingBottom(_ value: CSS.Length) {
      setProperty(.paddingBottom, value.value)
    }

    public func paddingBottom(_ value: CSS.LengthPercentage) {
      setProperty(.paddingBottom, value.value)
    }

    public func paddingBottom(_ value: CSS.Percentage) {
      setProperty(.paddingBottom, value.value)
    }

    public func marginLeft(_ value: CSS.Length) {
      setProperty(.marginLeft, value.value)
    }

    public func marginLeft(_ value: CSS.LengthPercentage) {
      setProperty(.marginLeft, value.value)
    }

    public func marginLeft(_ value: CSS.Percentage) {
      setProperty(.marginLeft, value.value)
    }

    public func marginRight(_ value: CSS.Length) {
      setProperty(.marginRight, value.value)
    }

    public func marginRight(_ value: CSS.LengthPercentage) {
      setProperty(.marginRight, value.value)
    }

    public func marginRight(_ value: CSS.Percentage) {
      setProperty(.marginRight, value.value)
    }

    public func marginTop(_ value: CSS.Length) {
      setProperty(.marginTop, value.value)
    }

    public func marginTop(_ value: CSS.LengthPercentage) {
      setProperty(.marginTop, value.value)
    }

    public func marginTop(_ value: CSS.Percentage) {
      setProperty(.marginTop, value.value)
    }

    public func marginBottom(_ value: CSS.Length) {
      setProperty(.marginBottom, value.value)
    }

    public func marginBottom(_ value: CSS.LengthPercentage) {
      setProperty(.marginBottom, value.value)
    }

    public func marginBottom(_ value: CSS.Percentage) {
      setProperty(.marginBottom, value.value)
    }

    public func margin(_ value: CSS.Keyword.Auto) {
      setProperty(.margin, value.staticRawValue)
    }

    public func margin(_ value: CSS.Keyword.Global) {
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

    public var listStyleType: CSSListStyleTypeSetter {
      return CSSListStyleTypeSetter(elementID: elementID)
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
    public func border(_ width: CSS.Length, _ style: CSS.Border.LineStyle, _ color: CSS.Color) {
      let stringValue = "\(width.value) \(style.value) \(color.value)"
      setProperty(.border, stringValue)
    }

    // Helper for border with CSS.Border
    @_disfavoredOverload
    public func border(_ value: CSS.Border) {
      setProperty(.border, value.value)
    }

    @_disfavoredOverload
    public func border(_ value: String) {
      setProperty(.border, value)
    }

    public func border(_ value: CSS.Keyword.None) {
      setProperty(.border, value.staticRawValue)
    }

    public func border(_ value: CSS.Keyword.Global) {
      setProperty(.border, value.staticRawValue)
    }

    public func mask(_ value: CSS.Keyword.None) {
      setProperty(.mask, value.staticRawValue)
    }

    public func mask(_ value: CSS.Keyword.Global) {
      setProperty(.mask, value.staticRawValue)
    }

    @_disfavoredOverload
    public func mask(_ value: CSS.MaskLayer) {
      setProperty(.mask, value.value)
    }

    @_disfavoredOverload
    public func mask(_ value: String) {
      setProperty(.mask, value)
    }

    public func maskImage(_ gradient: CSS.Image.Gradient) {
      setProperty(.maskImage, gradient.value)
      setProperty(.webkitMaskImage, gradient.value)
    }

    public func removeMaskImage() {
      removeProperty(.maskImage)
      removeProperty(.webkitMaskImage)
    }

    // Helper for transition with 3 parameters
    public func transition(
      _ property: CSS.SingleTransitionProperty, _ duration: CSS.Time,
      _ timingFunction: CSS.EasingFunction
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
      _ keyword: CSS.Keyword.All, _ duration: CSS.Time, _ timingFunction: CSS.EasingFunction
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

    public func gridColumn(_ value: String) {
      setProperty("grid-column", value)
    }
  }
#endif
