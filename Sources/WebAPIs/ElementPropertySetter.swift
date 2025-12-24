#if os(WASI)

import Utilities

@dynamicCallable
public struct ElementPropertySetter: Sendable {
	let elementId: Int32
	let propertyName: String

	public func dynamicallyCall(withArguments args: [String]) {
		guard let value = args.first else { return }
		var nameBuffer = Array(propertyName.utf8)
		nameBuffer.append(0)
		var valueBuffer = Array(value.utf8)
		valueBuffer.append(0)

		nameBuffer.withUnsafeBufferPointer { namePtr in
			namePtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: nameBuffer.count) { namePointer in
				valueBuffer.withUnsafeBufferPointer { valPtr in
					valPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { valuePointer in
						element_setAttribute(elementId, namePointer, Int32(nameBuffer.count - 1), valuePointer, Int32(valueBuffer.count - 1))
					}
				}
			}
		}
	}
}

@dynamicCallable
public struct ElementInnerHTMLSetter: Sendable {
	let elementId: Int32

	public func dynamicallyCall(withArguments args: [String]) {
		guard let value = args.first else { return }
		var valueBuffer = Array(value.utf8)
		valueBuffer.append(0)

		valueBuffer.withUnsafeBufferPointer { ptr in
			ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { pointer in
				element_setInnerHTML(elementId, pointer, Int32(valueBuffer.count - 1))
			}
		}
	}
}

#endif
