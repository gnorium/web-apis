#if os(WASI)

import EmbeddedSwiftUtilities
import WebTypes

@dynamicCallable
public struct CSSTransformSetter: Sendable {
	let elementId: Int32

	private func setPropertyValue(_ value: String) {
		var propBuffer = Array("transform".utf8)
		propBuffer.append(0)
		var valueBuffer = Array(value.utf8)
		valueBuffer.append(0)

		propBuffer.withUnsafeBufferPointer { propPtr in
			propPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propBuffer.count) { propertyPointer in
				valueBuffer.withUnsafeBufferPointer { valPtr in
					valPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { valuePointer in
						element_setStyleProperty(elementId, propertyPointer, Int32(propBuffer.count - 1), valuePointer, Int32(valueBuffer.count - 1))
					}
				}
			}
		}
	}

	private func setPropertyStaticString(_ value: StaticString) {
		var propBuffer = Array("transform".utf8)
		propBuffer.append(0)

		propBuffer.withUnsafeBufferPointer { propPtr in
			propPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: propBuffer.count) { propertyPointer in
				value.withUTF8Buffer { valueBuffer in
					valueBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { valuePtr in
						element_setStyleProperty(elementId, propertyPointer, Int32(propBuffer.count - 1), valuePtr, Int32(valueBuffer.count))
					}
				}
			}
		}
	}

	public func dynamicallyCall(withArguments args: [CSSTransformFunction]) {
		if args.count == 1 {
			setPropertyValue(args[0].value)
		} else if args.count > 1 {
			setPropertyValue(stringJoin(args.map { $0.value }, separator: " "))
		}
	}

	public func dynamicallyCall(withArguments args: [CSSKeyword.None]) {
		guard let value = args.first else { return }
		setPropertyStaticString(value.rawValue)
	}

    public func dynamicallyCall(withArguments args: [CSSKeyword.Global]) {
        guard let value = args.first else { return }
        setPropertyStaticString(value.rawValue)
    }
}

#endif
