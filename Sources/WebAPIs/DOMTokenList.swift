#if os(WASI)

import Utilities

public struct DOMTokenList: Sendable {
	let elementId: Int32

	private var element: Element { Element(id: elementId) }

	public func add(_ className: String) -> Element {
		var buffer = Array(className.utf8)
		buffer.append(0)

		buffer.withUnsafeBufferPointer { ptr in
			ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
				element_addClass(elementId, pointer, Int32(buffer.count - 1))
			}
		}
		return element
	}

	public func remove(_ className: String) -> Element {
		var buffer = Array(className.utf8)
		buffer.append(0)

		buffer.withUnsafeBufferPointer { ptr in
			ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
				element_removeClass(elementId, pointer, Int32(buffer.count - 1))
			}
		}
		return element
	}

	public func toggle(_ className: String) -> Element {
		var buffer = Array(className.utf8)
		buffer.append(0)

		buffer.withUnsafeBufferPointer { ptr in
			ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
				element_toggleClass(elementId, pointer, Int32(buffer.count - 1))
			}
		}
		return element
	}
}

#endif
