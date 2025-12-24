#if os(WASI)

import Utilities
import WebTypes

@dynamicCallable
public struct CSSVisibilitySetter: Sendable {
	let elementId: Int32

	public func dynamicallyCall(withArguments args: [CSSVisibility]) {
		guard let value = args.first else { return }
		var propBuffer = Array("visibility".utf8)
		propBuffer.append(0)

		value.staticRawValue.withUTF8Buffer { valueBuffer in
			propBuffer.withUnsafeBufferPointer { propPtr in
				propPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propBuffer.count) { propPointer in
					valueBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { valuePtr in
						element_setStyleProperty(elementId, propPointer, Int32(propBuffer.count - 1), valuePtr, Int32(valueBuffer.count))
					}
				}
			}
		}
	}
}

#endif
