#if os(WASI)

import Utilities

@dynamicMemberLookup
public struct DOMStringMap: Sendable {
	let elementId: Int32

	public subscript(key: String) -> String? {
		get {
			let kebabCase = camelToKebab(key)
			let attributeName = stringConcat("data-", kebabCase)
			return Element(id: elementId).getAttribute(attributeName)
		}
		set {
			let kebabCase = camelToKebab(key)
			let attributeName = stringConcat("data-", kebabCase)
			if let value = newValue {
				Element(id: elementId).setAttribute(attributeName, value)
			}
		}
	}

	public subscript(dynamicMember key: String) -> String? {
		get {
			let kebabCase = camelToKebab(key)
			// Build "data-" + attributeName in a C string buffer
			let attrBuffer = Array(kebabCase.utf8)
			let attrLen = attrBuffer.count
			let totalLen = 5 + attrLen // "data-" is 5 chars

			let buffer = UnsafeMutablePointer<CChar>.allocate(capacity: Int(totalLen + 1))
			defer { buffer.deallocate() }

			// Copy "data-"
			buffer[0] = 100 // 'd'
			buffer[1] = 97  // 'a'
			buffer[2] = 116 // 't'
			buffer[3] = 97  // 'a'
			buffer[4] = 45  // '-'

			// Copy attribute name
			for i in 0..<attrLen {
				buffer[5 + i] = CChar(bitPattern: attrBuffer[i])
			}
			buffer[Int(totalLen)] = 0 // null terminator

			return Element(id: elementId).getAttribute(String(cString: buffer))
		}
		set {
			guard let value = newValue else { return }
			let kebabCase = camelToKebab(key)

			// Build "data-" + attributeName in a C string buffer
			let attrBuffer = Array(kebabCase.utf8)
			let attrLen = attrBuffer.count
			let totalLen = 5 + attrLen // "data-" is 5 chars

			let buffer = UnsafeMutablePointer<CChar>.allocate(capacity: Int(totalLen + 1))
			defer { buffer.deallocate() }

			// Copy "data-"
			buffer[0] = 100 // 'd'
			buffer[1] = 97  // 'a'
			buffer[2] = 116 // 't'
			buffer[3] = 97  // 'a'
			buffer[4] = 45  // '-'

			// Copy attribute name
			for i in 0..<attrLen {
				buffer[5 + i] = CChar(bitPattern: attrBuffer[i])
			}
			buffer[Int(totalLen)] = 0 // null terminator

			var valueBuffer = Array(value.utf8)
			valueBuffer.append(0)
			valueBuffer.withUnsafeBufferPointer { valPtr in
				valPtr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { valuePtr in
					element_setAttribute(elementId, buffer, Int32(totalLen), valuePtr, Int32(valueBuffer.count - 1))
				}
			}
		}
	}

	private func camelToKebab(_ str: String) -> String {
		var result: [UInt8] = []
		str.utf8.withContiguousStorageIfAvailable { ptr in
			for i in 0..<ptr.count {
				let char = ptr[i]
				if char >= 65 && char <= 90 { // A-Z
					if i > 0 {
						result.append(45) // '-'
					}
					result.append(char + 32) // to lowercase
				} else {
					result.append(char)
				}
			}
		} 
		
		// Fallback if contiguous storage not available (rare for String)
		if result.isEmpty {
			for char in str.utf8 {
				if char >= 65 && char <= 90 { // A-Z
					if !result.isEmpty {
						result.append(45) // '-'
					}
					result.append(char + 32)
				} else {
					result.append(char)
				}
			}
		}
		
		return String(decoding: result, as: UTF8.self)
	}
}

#endif
