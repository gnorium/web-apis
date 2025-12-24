#if os(WASI)

import Utilities
import WebTypes

@dynamicCallable
public struct CSSDisplaySetter: Sendable {
	let elementId: Int32

	// Main overload for unified CSSDisplay
	public func dynamicallyCall(withArguments args: [CSSDisplay]) {
		guard let value = args.first else { return }
		let stringValue = value.rawValue
		var propBuffer = Array("display".utf8)
		propBuffer.append(0)
		var valueBuffer = Array(stringValue.utf8)
		valueBuffer.append(0)

		propBuffer.withUnsafeBufferPointer { propPtr in
			propPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propBuffer.count) { propPointer in
				valueBuffer.withUnsafeBufferPointer { valPtr in
					valPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { valuePointer in
						element_setStyleProperty(elementId, propPointer, Int32(propBuffer.count - 1), valuePointer, Int32(valueBuffer.count - 1))
					}
				}
			}
		}
	}
}

#endif
