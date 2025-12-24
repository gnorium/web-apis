#if os(WASI)

public struct CallbackString: @unchecked Sendable {
	let ptr: UnsafePointer<CChar>
	public let len: Int

	public var isEmpty: Bool {
		return len == 0
	}

	public func equals(_ literal: StaticString) -> Bool {
		guard len == literal.utf8CodeUnitCount else { return false }
		return literal.withUTF8Buffer { litBuffer in
			for i in 0..<len {
				if ptr[i] != CChar(bitPattern: litBuffer[i]) {
					return false
				}
			}
			return true
		}
	}

	public func withCString<R>(_ body: (UnsafePointer<CChar>) -> R) -> R {
		return body(ptr)
	}

	public func toString() -> String {
		let buffer = UnsafeBufferPointer(start: ptr, count: len)
		let bytes = Array(buffer).map { UInt8(bitPattern: $0) }
		return String(decoding: bytes, as: UTF8.self)
	}

	// Event properties (matching JavaScript event API)
	public var key: String {
		var buffer = [CChar](repeating: 0, count: 256)
		let written = event_key(ptr, Int32(len), &buffer, 256)
		if written > 0 {
			let bytes = buffer.prefix(Int(written)).map { UInt8(bitPattern: $0) }
			return String(decoding: bytes, as: UTF8.self)
		}
		return ""
	}

	public func preventDefault() {
		event_preventDefault(ptr, Int32(len))
	}

	public func stopPropagation() {
		event_stopPropagation(ptr, Int32(len))
	}

	public var target: Element? {
		let targetId = event_target(ptr, Int32(len))
		return targetId >= 0 ? Element(id: targetId) : nil
	}

	public var detail: String {
		var buffer = [CChar](repeating: 0, count: 4096)
		let written = event_detail(ptr, Int32(len), &buffer, 4096)
		if written > 0 {
			let bytes = buffer.prefix(Int(written)).map { UInt8(bitPattern: $0) }
			return String(decoding: bytes, as: UTF8.self)
		}
		return ""
	}
}

@_extern(wasm, module: "env", name: "event_key")
fileprivate func event_key(_ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32, _ buffer: UnsafeMutablePointer<CChar>, _ bufferLen: Int32) -> Int32

@_extern(wasm, module: "env", name: "event_preventDefault")
fileprivate func event_preventDefault(_ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32)

@_extern(wasm, module: "env", name: "event_stopPropagation")
fileprivate func event_stopPropagation(_ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32)

@_extern(wasm, module: "env", name: "event_target")
fileprivate func event_target(_ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32) -> Int32

@_extern(wasm, module: "env", name: "event_detail")
fileprivate func event_detail(_ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32, _ buffer: UnsafeMutablePointer<CChar>, _ bufferLen: Int32) -> Int32

#endif
