#if os(WASI)

import EmbeddedSwiftUtilities
import WebTypes

public struct Window: Sendable {
	public final class Location: @unchecked Sendable {
		public var href: String {
			get {
				let bufferSize = 1024 * 4
				let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: bufferSize)
				defer { buffer.deallocate() }
				let len = window_getLocationHref(buffer, Int32(bufferSize))
				if len > 0 {
					let bytes = UnsafeBufferPointer(start: buffer, count: Int(len)).map { UInt8(bitPattern: $0) }
					return String(decoding: bytes, as: UTF8.self)
				}
				return ""
			}
			set {
				var buffer = Array(newValue.utf8)
				buffer.append(0)

				buffer.withUnsafeBufferPointer { ptr in
					ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
						window_setLocationHref(pointer, Int32(buffer.count - 1))
					}
				}
			}
		}

		public init() {}
	}

	public func matchMedia(_ query: MediaQueryList) -> Bool {
		return query.withCString { pointer, len in
			let result = window_matchMedia(pointer, len)
			return result != 0
		}
	}

	public func matchMedia(_ query: StaticString) -> Bool {
		return matchMedia(MediaQueryList(query))
	}

	public func onMediaQueryChange(_ query: MediaQueryList, _ handler: @escaping @Sendable (Bool) -> Void) {
		let callbackId = CallbackRegistry.register { matches in
			handler(matches.equals("true"))
		}
		query.withCString { pointer, len in
			window_matchMediaAddListener(pointer, len, Int32(callbackId))
		}
	}

	public func onMediaQueryChange(_ query: StaticString, _ handler: @escaping @Sendable (Bool) -> Void) {
		onMediaQueryChange(MediaQueryList(query), handler)
	}

	public func dispatchEvent(_ event: Element) {
		window_dispatchEvent(Int32(event.id))
	}

	public func on(_ eventName: String, _ handler: @escaping @Sendable (CallbackString) -> Void) {
		let callbackId = CallbackRegistry.register(handler)
		var buffer = Array(eventName.utf8)
		buffer.append(0)

		buffer.withUnsafeBufferPointer { ptr in
			ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
				window_addEventListener(pointer, Int32(buffer.count - 1), Int32(callbackId))
			}
		}
	}

	public func on(_ event: Event.`Type`, _ handler: @escaping @Sendable (CallbackString) -> Void) {
		on(event.rawValue, handler)
	}

	public func requestAnimationFrame(_ callback: @escaping @Sendable () -> Void) {
		let callbackId = CallbackRegistry.register { _ in
			callback()
		}
		window_requestAnimationFrame(Int32(callbackId))
	}

	@discardableResult
	public func setTimeout(_ ms: Double, _ callback: @escaping @Sendable () -> Void) -> Int32 {
		let callbackId = CallbackRegistry.register { _ in
			callback()
		}
		return window_setTimeout(ms, Int32(callbackId))
	}

	public func clearTimeout(_ timerId: Int32) {
		window_clearTimeout(timerId)
	}

	/// Standard scrollTo API - scrolls to specified coordinates
	/// - Parameters:
	///   - x: X coordinate to scroll to
	///   - y: Y coordinate to scroll to
	///   - behavior: 0 for auto (default), 1 for smooth
	public func scrollTo(_ x: Double, _ y: Double, behavior: ScrollBehavior = .auto) {
		window_scrollTo(x, y, Int32(behavior.rawValue))
	}

	public var location: Location {
		Location()
	}

	public struct URL {
		public static func createObjectURL(_ blobId: Int32) -> String {
			let bufferSize = 1024
			let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: bufferSize)
			defer { buffer.deallocate() }
			let len = window_createObjectURL(blobId, buffer, Int32(bufferSize))
			if len > 0 {
				let bytes = UnsafeBufferPointer(start: buffer, count: Int(len)).map { UInt8(bitPattern: $0) }
				return String(decoding: bytes, as: UTF8.self)
			}
			return ""
		}

		public static func revokeObjectURL(_ url: String) {
			var buffer = Array(url.utf8)
			buffer.append(0)

			buffer.withUnsafeBufferPointer { ptr in
				ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
					window_revokeObjectURL(pointer, Int32(buffer.count - 1))
				}
			}
		}
	}

	public struct Performance: Sendable {
		public func now() -> Double {
			window_performanceNow()
		}
	}

	public let performance = Performance()

	public func alert(_ message: String) {
		var buffer = Array(message.utf8)
		buffer.append(0)

		buffer.withUnsafeBufferPointer { ptr in
			ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { pointer in
				window_alert(pointer, Int32(buffer.count - 1))
			}
		}
	}

	public func fetch(_ url: String, method: String = "GET", body: String? = nil, _ callback: @escaping @Sendable (FetchResponse) -> Void) {
		let callbackId = CallbackRegistry.register { result in
			callback(FetchResponse(jsonString: result.toString()))
		}

		var urlBuffer = Array(url.utf8)
		urlBuffer.append(0)
		var methodBuffer = Array(method.utf8)
		methodBuffer.append(0)

		urlBuffer.withUnsafeBufferPointer { urlPtr in
			urlPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: urlBuffer.count) { urlPointer in
				methodBuffer.withUnsafeBufferPointer { methodPtr in
					methodPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: methodBuffer.count) { methodPointer in
						if let body = body {
							var bodyBuffer = Array(body.utf8)
							bodyBuffer.append(0)
							bodyBuffer.withUnsafeBufferPointer { bodyPtr in
								bodyPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: bodyBuffer.count) { bodyPointer in
									window_fetch(urlPointer, Int32(urlBuffer.count - 1), methodPointer, Int32(methodBuffer.count - 1), bodyPointer, Int32(bodyBuffer.count - 1), Int32(callbackId))
								}
							}
						} else {
							window_fetch(urlPointer, Int32(urlBuffer.count - 1), methodPointer, Int32(methodBuffer.count - 1), nil, 0, Int32(callbackId))
						}
					}
				}
			}
		}
	}
}

public struct FetchResponse: Sendable {
	let jsonString: String

	public func text() -> String {
		jsonString
	}
}

public let window = Window()

@_extern(wasm, module: "env", name: "window_alert")
func window_alert(_ messagePointer: UnsafePointer<CChar>, _ messageLen: Int32)

@_extern(wasm, module: "env", name: "window_fetch")
func window_fetch(_ urlPointer: UnsafePointer<CChar>, _ urlLen: Int32, _ methodPointer: UnsafePointer<CChar>, _ methodLen: Int32, _ bodyPointer: UnsafePointer<CChar>?, _ bodyLen: Int32, _ callbackId: Int32)

@_extern(wasm, module: "env", name: "window_matchMedia")
func window_matchMedia(_ queryPointer: UnsafePointer<CChar>, _ queryLen: Int32) -> Int32

@_extern(wasm, module: "env", name: "window_matchMediaAddListener")
func window_matchMediaAddListener(_ queryPointer: UnsafePointer<CChar>, _ queryLen: Int32, _ callbackId: Int32)

@_extern(wasm, module: "env", name: "window_dispatchEvent")
func window_dispatchEvent(_ elementId: Int32)

@_extern(wasm, module: "env", name: "window_addEventListener")
func window_addEventListener(_ eventPointer: UnsafePointer<CChar>, _ eventLen: Int32, _ callbackId: Int32)

@_extern(wasm, module: "env", name: "window_requestAnimationFrame")
func window_requestAnimationFrame(_ callbackId: Int32)

@_extern(wasm, module: "env", name: "window_setTimeout")
func window_setTimeout(_ ms: Double, _ callbackId: Int32) -> Int32

@_extern(wasm, module: "env", name: "window_clearTimeout")
func window_clearTimeout(_ timerId: Int32)

@_extern(wasm, module: "env", name: "window_scrollTo")
func window_scrollTo(_ x: Double, _ y: Double, _ behavior: Int32)

@_extern(wasm, module: "env", name: "window_getLocationHref")
func window_getLocationHref(_ buffer: UnsafeMutablePointer<Int8>, _ bufferLen: Int32) -> Int32

@_extern(wasm, module: "env", name: "window_setLocationHref")
func window_setLocationHref(_ hrefPointer: UnsafePointer<CChar>, _ hrefLen: Int32)

@_extern(wasm, module: "env", name: "window_performanceNow")
func window_performanceNow() -> Double

public func getPerformanceNow() -> Double {
	window_performanceNow()
}

@_extern(wasm, module: "env", name: "window_createObjectURL")
func window_createObjectURL(_ blobId: Int32, _ buffer: UnsafeMutablePointer<Int8>, _ bufferLen: Int32) -> Int32

@_extern(wasm, module: "env", name: "window_revokeObjectURL")
func window_revokeObjectURL(_ urlPointer: UnsafePointer<CChar>, _ urlLen: Int32)

@_extern(wasm, module: "env", name: "canvas_toBlob")
public func canvas_toBlob(_ canvasId: Int32, _ callbackId: Int32)

#endif
