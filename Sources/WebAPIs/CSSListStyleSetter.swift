#if os(WASI)

import EmbeddedSwiftUtilities
import WebTypes

@dynamicCallable
public struct CSSListStyleSetter: Sendable {
	let elementId: Int32

	public func dynamicallyCall(withArguments args: [CSSListStyle]) {
		guard let value = args.first else { return }
		var propBuffer = Array("list-style".utf8)
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
