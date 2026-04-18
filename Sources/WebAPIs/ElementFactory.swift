#if os(WASI)

import EmbeddedSwiftUtilities

internal struct ElementFactory {
    /// Creates the appropriate Element subclass based on the DOM tag name
    internal static func create(id: Int32) -> Element {
        let bufferSize = 64
        let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: bufferSize)
        defer { buffer.deallocate() }
        
        let len = element_getTagName(id, buffer, Int32(bufferSize))
        if len > 0 {
            let bytes = UnsafeBufferPointer(start: buffer, count: Int(len)).map { UInt8(bitPattern: $0) }
            let tagName = String(decoding: bytes, as: UTF8.self)
            
            if stringEquals(tagName, "INPUT") {
                return HTMLInputElement(id: id)
            } else if stringEquals(tagName, "TEXTAREA") {
                return HTMLTextAreaElement(id: id)
            } else if stringEquals(tagName, "SELECT") {
                return HTMLSelectElement(id: id)
            } else if stringEquals(tagName, "BUTTON") {
                return HTMLButtonElement(id: id)
            } else if stringEquals(tagName, "OPTION") {
                return HTMLOptionElement(id: id)
            } else {
                return HTMLElement(id: id)
            }
        }
        
        // Fallback if tag name query fails
        return HTMLElement(id: id)
    }
}

#endif
