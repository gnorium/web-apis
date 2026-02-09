#if os(WASI)

import EmbeddedSwiftUtilities
import WebTypes

public struct Document: Sendable {
	public func fontsReady(_ callback: @escaping @Sendable () -> Void) {
		let callbackId = CallbackRegistry.register { _ in
			callback()
		}
		document_fontsReady(Int32(callbackId))
	}

	public func querySelector(_ selector: StaticString) -> Element? {
		return selector.withUTF8Buffer { buffer in
			buffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
				let id = document_querySelector(pointer, Int32(buffer.count))
				return id >= 0 ? Element(id: id) : nil
			}
		}
	}

	public func querySelector(_ selector: String) -> Element? {
        var buffer = Array(selector.utf8)
        buffer.append(0)
        return buffer.withUnsafeBufferPointer { bufferPtr in
            bufferPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
                let id = document_querySelector(pointer, Int32(buffer.count - 1))
                return id >= 0 ? Element(id: id) : nil
            }
        }
	}

	public func querySelectorAll(_ selector: String) -> [Element] {
        var buffer = Array(selector.utf8)
        buffer.append(0)
        return buffer.withUnsafeBufferPointer { bufferPtr in
            bufferPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
                let maxElements: Int32 = 256
                let resultBuffer = UnsafeMutablePointer<Int32>.allocate(capacity: Int(maxElements))
                defer { resultBuffer.deallocate() }
                let count = document_querySelectorAll(pointer, Int32(buffer.count - 1), resultBuffer, maxElements)
                return (0..<count).map { Element(id: resultBuffer[Int($0)]) }
            }
        }
	}

	public func getElementById(_ id: String) -> Element? {
		var buffer = Array(id.utf8)
		buffer.append(0)
		return buffer.withUnsafeBufferPointer { bufferPtr in
			bufferPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
				let elementId = document_getElementById(pointer, Int32(buffer.count - 1))
				return elementId >= 0 ? Element(id: elementId) : nil
			}
		}
	}

	public func createElement(_ tagName: String) -> Element {
        var buffer = Array(tagName.utf8)
        buffer.append(0)
        return buffer.withUnsafeBufferPointer { bufferPtr in
            bufferPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
                let id = document_createElement(pointer, Int32(buffer.count - 1))
                return Element(id: id)
            }
        }
	}

	public func createElement(_ tagName: StaticString) -> Element {
		return tagName.withUTF8Buffer { buffer in
			buffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
				let id = document_createElement(pointer, Int32(buffer.count))
				return Element(id: id)
			}
		}
	}

	public func createElementNS(_ namespace: String, _ tagName: String) -> Element {
		var nsBuffer = Array(namespace.utf8)
		nsBuffer.append(0)
		var tagBuffer = Array(tagName.utf8)
		tagBuffer.append(0)
		
		return nsBuffer.withUnsafeBufferPointer { nsBufPtr in
			nsBufPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: nsBuffer.count) { nsPointer in
				tagBuffer.withUnsafeBufferPointer { tagBufPtr in
					tagBufPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: tagBuffer.count) { tagPointer in
						let id = document_createElementNS(nsPointer, Int32(nsBuffer.count - 1), tagPointer, Int32(tagBuffer.count - 1))
						return Element(id: id)
					}
				}
			}
		}
	}

	public func createElement(_ tag: TagName) -> Element {
		return createElement(tag.value)
	}

	public var body: Element {
		querySelector("body")!
	}

	public var activeElement: Element? {
		let elementId = document_getActiveElement()
		return elementId >= 0 ? Element(id: elementId) : nil
	}

	public func createCustomEvent(_ type: String, detail: String) -> CustomEvent {
		return CustomEvent(type: type, detail: detail)
	}

}

extension Document: EventTargetProtocol {
	@discardableResult
	public func addEventListener(_ event: StaticString, _ handler: @escaping @Sendable (CallbackString) -> Void) -> Document {
		let callbackId = CallbackRegistry.register(handler)
		event.withUTF8Buffer { buffer in
			buffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
				document_addEventListener(pointer, Int32(buffer.count), Int32(callbackId))
			}
		}
		return self
	}

	@discardableResult
	public func addEventListener(_ event: Event.`Type`, _ handler: @escaping @Sendable (CallbackString) -> Void) -> Document {
		return addEventListener(event.staticString, handler)
	}

	public func removeEventListener(_ event: StaticString) {
		event.withUTF8Buffer { buffer in
			buffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
				document_removeEventListener(pointer, Int32(buffer.count))
			}
		}
	}

	public func dispatchEvent(_ event: StaticString) {
		event.withUTF8Buffer { buffer in
			buffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
				document_dispatchEvent(pointer, Int32(buffer.count))
			}
		}
	}

	public func dispatchEvent(_ event: CustomEvent) {
		document_dispatchCustomEvent(event.pointer)
	}

	public func on(_ event: StaticString, _ handler: @escaping @Sendable (CallbackString) -> Void) -> Document {
		addEventListener(event, handler)
		return self
	}

	public func on(_ event: Event.`Type`, _ handler: @escaping @Sendable (CallbackString) -> Void) -> Document {
		addEventListener(event.staticString, handler)
		return self
	}
}

public let document = Document()

@_extern(wasm, module: "env", name: "document_addEventListener")
func document_addEventListener(_ eventPointer: UnsafePointer<CChar>, _ eventLen: Int32, _ callbackId: Int32)

@_extern(wasm, module: "env", name: "document_removeEventListener")
func document_removeEventListener(_ eventPointer: UnsafePointer<CChar>, _ eventLen: Int32)

@_extern(wasm, module: "env", name: "document_dispatchEvent")
func document_dispatchEvent(_ eventPointer: UnsafePointer<CChar>, _ eventLen: Int32)

@_extern(wasm, module: "env", name: "document_dispatchCustomEvent")
func document_dispatchCustomEvent(_ eventPointer: Int32)

@_extern(wasm, module: "env", name: "document_createElement")
func document_createElement(_ tagNamePointer: UnsafePointer<CChar>, _ tagNameLen: Int32) -> Int32

@_extern(wasm, module: "env", name: "document_createElementNS")
func document_createElementNS(_ nsPointer: UnsafePointer<CChar>, _ nsLen: Int32, _ tagPointer: UnsafePointer<CChar>, _ tagLen: Int32) -> Int32

@_extern(wasm, module: "env", name: "document_querySelector")
func document_querySelector(_ selectorPointer: UnsafePointer<CChar>, _ selectorLen: Int32) -> Int32

@_extern(wasm, module: "env", name: "document_querySelectorAll")
func document_querySelectorAll(_ selectorPointer: UnsafePointer<CChar>, _ selectorLen: Int32, _ buffer: UnsafeMutablePointer<Int32>, _ maxElements: Int32) -> Int32

@_extern(wasm, module: "env", name: "document_fontsReady")
func document_fontsReady(_ callbackId: Int32)

@_extern(wasm, module: "env", name: "document_getActiveElement")
func document_getActiveElement() -> Int32

@_extern(wasm, module: "env", name: "document_getElementById")
func document_getElementById(_ idPointer: UnsafePointer<CChar>, _ idLen: Int32) -> Int32

#endif
