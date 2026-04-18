#if os(WASI)

import EmbeddedSwiftUtilities
import WebTypes

@dynamicCallable
public struct CSSDisplaySetter: Sendable {
	let elementID: Int32

	// Helper to set display value from StaticString
	private func setDisplay(_ staticRawValue: StaticString) {
		var propBuffer = Array("display".utf8)
		propBuffer.append(0)

		staticRawValue.withUTF8Buffer { utf8Buffer in
			var valueBuffer = Array(utf8Buffer)
			valueBuffer.append(0)

			propBuffer.withUnsafeBufferPointer { propPtr in
				propPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propBuffer.count) { propPointer in
					valueBuffer.withUnsafeBufferPointer { valPtr in
						valPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { valuePointer in
							element_setStyleProperty(elementID, propPointer, Int32(propBuffer.count - 1), valuePointer, Int32(valueBuffer.count - 1))
						}
					}
				}
			}
		}
	}

	// Overloads for sub-enums
	public func dynamicallyCall(withArguments args: [CSSDisplay.Outside]) {
		guard let value = args.first else { return }
		setDisplay(value.staticRawValue)
	}

	public func dynamicallyCall(withArguments args: [CSSDisplay.Inside]) {
		guard let value = args.first else { return }
		setDisplay(value.staticRawValue)
	}

	public func dynamicallyCall(withArguments args: [CSSDisplay.ListItem]) {
		guard let value = args.first else { return }
		setDisplay(value.staticRawValue)
	}

	public func dynamicallyCall(withArguments args: [CSSDisplay.Internal]) {
		guard let value = args.first else { return }
		setDisplay(value.staticRawValue)
	}

	public func dynamicallyCall(withArguments args: [CSSDisplay.Box]) {
		guard let value = args.first else { return }
		setDisplay(value.staticRawValue)
	}

	public func dynamicallyCall(withArguments args: [CSSDisplay.Legacy]) {
		guard let value = args.first else { return }
		setDisplay(value.staticRawValue)
	}

	// Overload for none keyword
	public func dynamicallyCall(withArguments args: [CSSKeyword.None]) {
		guard let value = args.first else { return }
		setDisplay(value.staticRawValue)
	}
}

#endif
