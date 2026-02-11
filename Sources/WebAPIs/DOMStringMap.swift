#if os(WASI)

import EmbeddedSwiftUtilities

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
			guard let value = newValue else { return }
			let kebabCase = camelToKebab(key)
			let attributeName = stringConcat("data-", kebabCase)
			var nameBuffer = Array(attributeName.utf8)
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

	public subscript(dynamicMember key: String) -> DatasetPropertySetter {
		return DatasetPropertySetter(elementId: elementId, attribute: stringConcat("data-", camelToKebab(key)))
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
