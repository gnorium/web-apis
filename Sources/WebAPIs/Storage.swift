#if os(WASI)

import EmbeddedSwiftUtilities

public struct Storage: Sendable {
	public func getItem(_ key: String) -> String? {
		let bufferSize = 1024
		let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: bufferSize)
		defer { buffer.deallocate() }
		var keyBuffer = Array(key.utf8)
		keyBuffer.append(0)
		return keyBuffer.withUnsafeBufferPointer { keyPtr in
			keyPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: keyBuffer.count) { keyPointer in
				let len = localStorage_getItem(keyPointer, Int32(keyBuffer.count - 1), buffer, Int32(bufferSize))
				if len > 0 {
					let bytes = UnsafeBufferPointer(start: buffer, count: Int(len)).map { UInt8(bitPattern: $0) }
					return String(decoding: bytes, as: UTF8.self)
				}
				return nil
			}
		}
	}

	public func getItem(_ key: StaticString) -> String? {
		let bufferSize = 1024
		let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: bufferSize)
		defer { buffer.deallocate() }
		return key.withUTF8Buffer { keyBuffer in
			keyBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: keyBuffer.count) { keyPointer in
				let len = localStorage_getItem(keyPointer, Int32(keyBuffer.count), buffer, Int32(bufferSize))
				if len > 0 {
					let bytes = UnsafeBufferPointer(start: buffer, count: Int(len)).map { UInt8(bitPattern: $0) }
					return String(decoding: bytes, as: UTF8.self)
				}
				return nil
			}
		}
	}

	public func setItem(_ key: String, _ value: String) {
		var keyBuffer = Array(key.utf8)
		keyBuffer.append(0)
		var valueBuffer = Array(value.utf8)
		valueBuffer.append(0)

		keyBuffer.withUnsafeBufferPointer { keyPtr in
			keyPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: keyBuffer.count) { keyPointer in
				valueBuffer.withUnsafeBufferPointer { valPtr in
					valPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { valuePointer in
						localStorage_setItem(keyPointer, Int32(keyBuffer.count - 1), valuePointer, Int32(valueBuffer.count - 1))
					}
				}
			}
		}
	}

	public func setItem(_ key: StaticString, _ value: String) {
		var valueBuffer = Array(value.utf8)
		valueBuffer.append(0)

		key.withUTF8Buffer { keyBuf in
			keyBuf.baseAddress!.withMemoryRebound(to: CChar.self, capacity: keyBuf.count) { keyPointer in
				valueBuffer.withUnsafeBufferPointer { valPtr in
					valPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { valuePointer in
						localStorage_setItem(keyPointer, Int32(keyBuf.count), valuePointer, Int32(valueBuffer.count - 1))
					}
				}
			}
		}
	}

	public func setItem(_ key: StaticString, _ value: StaticString) {
		key.withUTF8Buffer { keyBuffer in
			value.withUTF8Buffer { valueBuffer in
				keyBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: keyBuffer.count) { keyPointer in
					valueBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { valuePointer in
						localStorage_setItem(keyPointer, Int32(keyBuffer.count), valuePointer, Int32(valueBuffer.count))
					}
				}
			}
		}
	}

	public func removeItem(_ key: String) {
		var keyBuffer = Array(key.utf8)
		keyBuffer.append(0)

		keyBuffer.withUnsafeBufferPointer { keyPtr in
			keyPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: keyBuffer.count) { keyPointer in
				localStorage_removeItem(keyPointer, Int32(keyBuffer.count - 1))
			}
		}
	}

	public func removeItem(_ key: StaticString) {
		key.withUTF8Buffer { keyBuffer in
			keyBuffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: keyBuffer.count) { keyPointer in
				localStorage_removeItem(keyPointer, Int32(keyBuffer.count))
			}
		}
	}
}

public let localStorage = Storage()

@_extern(wasm, module: "env", name: "localStorage_getItem")
func localStorage_getItem(_ keyPointer: UnsafePointer<CChar>, _ keyLen: Int32, _ buffer: UnsafeMutablePointer<Int8>, _ bufferLen: Int32) -> Int32

@_extern(wasm, module: "env", name: "localStorage_setItem")
func localStorage_setItem(_ keyPointer: UnsafePointer<CChar>, _ keyLen: Int32, _ valuePointer: UnsafePointer<CChar>, _ valueLen: Int32)

@_extern(wasm, module: "env", name: "localStorage_removeItem")
func localStorage_removeItem(_ keyPointer: UnsafePointer<CChar>, _ keyLen: Int32)

#endif
