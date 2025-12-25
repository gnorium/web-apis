#if os(WASI)

import EmbeddedSwiftUtilities

public struct FormData: Sendable {
	let formId: Int32

	public init(_ form: Element) {
		self.formId = Int32(form.id)
	}

	public func toString() -> String {
		let bufferSize = 1024 * 16
		let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: bufferSize)
		defer { buffer.deallocate() }
		let len = formData_serialize(formId, buffer, Int32(bufferSize))
		if len > 0 {
			let bytes = UnsafeBufferPointer(start: buffer, count: Int(len)).map { UInt8(bitPattern: $0) }
			return String(decoding: bytes, as: UTF8.self)
		}
		return ""
	}
}

@_extern(wasm, module: "env", name: "formData_serialize")
func formData_serialize(_ formId: Int32, _ buffer: UnsafeMutablePointer<Int8>, _ bufferLen: Int32) -> Int32

#endif
