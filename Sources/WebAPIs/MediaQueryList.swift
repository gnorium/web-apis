#if os(WASI)

import EmbeddedSwiftUtilities

public struct MediaQueryList: @unchecked Sendable {
	let ptr: UnsafeRawPointer?
	let count: Int

	public init(_ rawValue: String) {
		self.ptr = nil
		self.count = 0
		// String-based queries not yet supported
	}

	public init(_ rawValue: StaticString) {
		self.ptr = UnsafeRawPointer(rawValue.utf8Start)
		self.count = rawValue.utf8CodeUnitCount
	}

	public func withCString<R>(_ body: (UnsafePointer<CChar>, Int32) -> R) -> R {
		guard let ptr = ptr else {
			fatalError("String-based MediaQueryList not yet supported")
		}
		return ptr.assumingMemoryBound(to: CChar.self).withMemoryRebound(to: CChar.self, capacity: count) { cPtr in
			body(cPtr, Int32(count))
		}
	}
}

#endif
