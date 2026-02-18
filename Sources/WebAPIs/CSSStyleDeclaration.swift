#if os(WASI)

import EmbeddedSwiftUtilities
import WebTypes

@dynamicMemberLookup
public struct CSSStyleDeclaration: Sendable {
	let elementId: Int32

	public func setProperty(_ property: String, _ value: String) {
        var propertyBuffer = Array(property.utf8)
        propertyBuffer.append(0)

        propertyBuffer.withUnsafeBufferPointer { propPtr in
            propPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propertyBuffer.count) { propertyPointer in
                var valueBuffer = Array(value.utf8)
                valueBuffer.append(0)

                valueBuffer.withUnsafeBufferPointer { bufferPtr in
                    bufferPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { valuePointer in
                        element_setStyleProperty(elementId, propertyPointer, Int32(propertyBuffer.count - 1), valuePointer, Int32(valueBuffer.count - 1))
                    }
                }
            }
        }
	}

	public func setProperty<T: CSSPropertyValueProtocol>(_ property: String, _ value: T) {
		var propertyBuffer = Array(property.utf8)
		propertyBuffer.append(0)

		propertyBuffer.withUnsafeBufferPointer { propPtr in
			propPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propertyBuffer.count) { propertyPointer in
				value.rawValue.withUTF8Buffer { valueBuffer in
					valueBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { valuePtr in
						element_setStyleProperty(elementId, propertyPointer, Int32(propertyBuffer.count - 1), valuePtr, Int32(valueBuffer.count))
					}
				}
			}
		}
	}

	public func setProperty(_ property: String, _ value: StaticString) {
		var propertyBuffer = Array(property.utf8)
		propertyBuffer.append(0)

		propertyBuffer.withUnsafeBufferPointer { propPtr in
			propPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propertyBuffer.count) { propertyPointer in
				value.withUTF8Buffer { valueBuffer in
					valueBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { valuePtr in
						element_setStyleProperty(elementId, propertyPointer, Int32(propertyBuffer.count - 1), valuePtr, Int32(valueBuffer.count))
					}
				}
			}
		}
	}

	public func setProperty(_ property: StaticString, _ value: String) {
		property.withUTF8Buffer { propertyBuffer in
			propertyBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propertyBuffer.count) { propertyPointer in
				var valueBuffer = Array(value.utf8)
				valueBuffer.append(0)

				valueBuffer.withUnsafeBufferPointer { valPtr in
					valPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { valuePtr in
						element_setStyleProperty(elementId, propertyPointer, Int32(propertyBuffer.count), valuePtr, Int32(valueBuffer.count - 1))
					}
				}
			}
		}
	}

    public func setProperty<T: CSSPropertyValueProtocol>(_ property: StaticString, _ value: T) {
        property.withUTF8Buffer { propertyBuffer in
            propertyBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propertyBuffer.count) { propertyPointer in
                value.rawValue.withUTF8Buffer { valueBuffer in
                    valueBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { valuePtr in
                        element_setStyleProperty(elementId, propertyPointer, Int32(propertyBuffer.count), valuePtr, Int32(valueBuffer.count))
                    }
                }
            }
        }
    }

    public func setProperty(_ property: StaticString, _ value: StaticString) {
        property.withUTF8Buffer { propertyBuffer in
            propertyBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propertyBuffer.count) { propertyPointer in
                value.withUTF8Buffer { valueBuffer in
                    valueBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { valuePtr in
                        element_setStyleProperty(elementId, propertyPointer, Int32(propertyBuffer.count), valuePtr, Int32(valueBuffer.count))
                    }
                }
            }
        }
    }

	public func removeProperty(_ property: String) {
		var propertyBuffer = Array(property.utf8)
		propertyBuffer.append(0)

		propertyBuffer.withUnsafeBufferPointer { propPtr in
			propPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propertyBuffer.count) { propertyPointer in
				element_removeStyleProperty(elementId, propertyPointer, Int32(propertyBuffer.count - 1))
			}
		}
	}

	public func removeProperty(_ property: StaticString) {
		property.withUTF8Buffer { propertyBuffer in
			propertyBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propertyBuffer.count) { propertyPointer in
				element_removeStyleProperty(elementId, propertyPointer, Int32(propertyBuffer.count))
			}
		}
	}

	public func getPropertyValue(_ property: String) -> String {
		var propertyBuffer = Array(property.utf8)
		propertyBuffer.append(0)

		let bufferSize = 1024
		var resultBuffer = [Int8](repeating: 0, count: bufferSize)
		let length = resultBuffer.withUnsafeMutableBufferPointer { bufPtr in
			propertyBuffer.withUnsafeBufferPointer { propPtr in
				propPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propertyBuffer.count) { propertyPointer in
					element_getStyleProperty(elementId, propertyPointer, Int32(propertyBuffer.count - 1), bufPtr.baseAddress!, Int32(bufferSize))
				}
			}
		}
		guard length > 0 else { return "" }
		let bytes = resultBuffer[0..<Int(length)].map { UInt8(bitPattern: $0) }
		return String(decoding: bytes, as: UTF8.self)
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
	
	public func background(_ value: CSSColor) {
		setProperty("background", value.value)
	}

	public func borderBottom(_ width: Length, _ style: CSSBorder.LineStyle, _ color: CSSColor) {
		let stringValue = stringConcat(width.value, " ", style.value, " ", color.value)
		setProperty("border-bottom", stringValue)
	}

	public func margin(_ value: Length) {
		setProperty("margin", value.value)
	}

	public func padding(_ all: LengthPercentage) {
		setProperty("padding", all.value)
	}

	public func padding(_ vertical: LengthPercentage, _ horizontal: LengthPercentage) {
		let value = stringConcat(vertical.value, " ", horizontal.value)
		setProperty("padding", value)
	}

	public func padding(_ all: Length) {
		setProperty("padding", all.value)
	}

	public func padding(_ vertical: Length, _ horizontal: Length) {
		let value = stringConcat(vertical.value, " ", horizontal.value)
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

	// MARK: - User Interaction

	public func userSelect(_ value: CSSUserSelect) {
		setProperty("user-select", value.staticRawValue)
	}

	public func cursor(_ value: CSSCursor) {
        if let staticValue = value.staticValue {
            setProperty("cursor", staticValue)
        } else {
            setProperty("cursor", value.value)
        }
	}

	// MARK: - Box Model

	public func boxSizing(_ value: CSSBoxSizing) {
		setProperty("box-sizing", value.staticRawValue)
	}

	// MARK: - Text Decoration

	public func textDecoration(_ value: CSSTextDecoration) {
        if let staticValue = value.staticValue {
            setProperty("text-decoration", staticValue)
        } else {
            setProperty("text-decoration", value.value)
        }
	}

	// MARK: - Outline

	public func outline(_ width: Length, _ style: CSSBorder.LineStyle, _ color: CSSColor) {
		let stringValue = stringConcat(width.value, " ", style.value, " ", color.value)
		setProperty("outline", stringValue)
	}

	public func outline(_ value: Length) {
		setProperty("outline", value.value)
	}

	public func outline(_ value: CSSKeyword.None) {
		setProperty("outline", value.staticRawValue)
	}

	public func outlineOffset(_ value: Length) {
		setProperty("outline-offset", value.value)
	}

	// MARK: - Specific Property Accessors

	public var display: CSSDisplaySetter {
		return CSSDisplaySetter(elementId: elementId)
	}

	public var textAlign: CSSTextAlignSetter {
		return CSSTextAlignSetter(elementId: elementId)
	}

	public var overflow: CSSOverflowSetter {
		return CSSOverflowSetter(elementId: elementId)
	}

	public var alignItems: CSSAlignItemsSetter {
		return CSSAlignItemsSetter(elementId: elementId)
	}

	public var pointerEvents: CSSPointerEventsSetter {
		return CSSPointerEventsSetter(elementId: elementId)
	}

	public var color: CSSColorSetter {
		return CSSColorSetter(elementId: elementId, property: "color")
	}

	public var backgroundColor: CSSColorSetter {
		return CSSColorSetter(elementId: elementId, property: "background-color")
	}

	public var borderColor: CSSColorSetter {
		return CSSColorSetter(elementId: elementId, property: "border-color")
	}

	public var textDecoration: CSSTextDecorationSetter {
		return CSSTextDecorationSetter(elementId: elementId)
	}

	public var listStyle: CSSListStyleSetter {
		return CSSListStyleSetter(elementId: elementId)
	}

	public var visibility: CSSVisibilitySetter {
		return CSSVisibilitySetter(elementId: elementId)
	}

	public var animationPlayState: CSSPropertySetter {
		return CSSPropertySetter(elementId: elementId, property: "animation-play-state")
	}

	public var transform: CSSTransformSetter {
		return CSSTransformSetter(elementId: elementId)
	}

	// Helper for border with 3 parameters
	public func border(_ width: Length, _ style: CSSBorder.LineStyle, _ color: CSSColor) {
		let stringValue = stringConcat(width.value, " ", style.value, " ", color.value)
		setProperty("border", stringValue)
	}

	// Helper for border with CSSBorder
	public func border(_ value: CSSBorder) {
		setProperty("border", value.value)
	}

	// Helper for transition with 3 parameters
	public func transition(_ property: CSSSingleTransitionProperty, _ duration: CSSTime, _ timingFunction: CSSEasingFunction) {
        if let p = property.staticValue, let d = duration.staticValue, let t = timingFunction.staticValue {
            let transitionProp: StaticString = "transition"
            transitionProp.withUTF8Buffer { propBuffer in
                 if let propPtr = propBuffer.baseAddress {
                     propPtr.withMemoryRebound(to: CChar.self, capacity: propBuffer.count) { propCCharPtr in
                         var buffer: [UInt8] = []
                         p.withUTF8Buffer { buffer.append(contentsOf: $0) }
                         buffer.append(32) // space
                         d.withUTF8Buffer { buffer.append(contentsOf: $0) }
                         buffer.append(32) // space
                         t.withUTF8Buffer { buffer.append(contentsOf: $0) }
                         
                         buffer.withUnsafeBufferPointer { valueBuffer in
                             if let valuePtr = valueBuffer.baseAddress {
                                 valuePtr.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { valueCCharPtr in
                                     element_setStyleProperty(elementId, propCCharPtr, Int32(propBuffer.count), valueCCharPtr, Int32(valueBuffer.count))
                                 }
                             }
                         }
                     }
                 }
            }
            return
        }

		let stringValue = stringConcat(property.value, " ", duration.value, " ", timingFunction.value)
		setProperty("transition", stringValue)
	}

	public subscript(dynamicMember property: String) -> CSSPropertySetter {
		return CSSPropertySetter(elementId: elementId, property: camelToKebab(property))
	}

	private func camelToKebab(_ camel: String) -> String {
		var result: [UInt8] = []
		let bytes = Array(camel.utf8)

		for i in 0..<bytes.count {
			let byte = bytes[i]
			// Check if uppercase letter (A-Z: 65-90)
			if byte >= 65 && byte <= 90 {
				// Add hyphen before uppercase if not first character
				if i > 0 {
					result.append(45) // '-'
				}
				// Convert to lowercase (add 32)
				result.append(byte + 32)
			} else {
				result.append(byte)
			}
		}

		return String(decoding: result, as: UTF8.self)
	}
}

#endif
