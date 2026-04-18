#if os(WASI)

import EmbeddedSwiftUtilities
import WebTypes

@dynamicCallable
public struct CSSColorSetter: Sendable {
	let elementID: Int32
	let property: String

	public func dynamicallyCall(withArguments args: [CSSColor]) {
		guard let value = args.first else { return }
		let stringValue = value.value
		var propBuffer = Array(property.utf8)
		propBuffer.append(0)
		var valueBuffer = Array(stringValue.utf8)
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

	// Support for global keywords like .inherit
	public func dynamicallyCall(withArguments args: [CSSKeyword.Global]) {
		guard let value = args.first else { return }
		var propBuffer = Array(property.utf8)
		propBuffer.append(0)

		value.rawValue.withUTF8Buffer { valueBuffer in
			propBuffer.withUnsafeBufferPointer { propPtr in
				propPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propBuffer.count) { propPointer in
					valueBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { valuePtr in
						element_setStyleProperty(elementID, propPointer, Int32(propBuffer.count - 1), valuePtr, Int32(valueBuffer.count))
					}
				}
			}
		}
	}
}

#endif
