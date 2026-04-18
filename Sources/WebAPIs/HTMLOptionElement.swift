#if os(WASI)

import EmbeddedSwiftUtilities
import WebTypes

public class HTMLOptionElement: HTMLElement, @unchecked Sendable {
    public var value: String {
        get {
            let bufferSize = 1024
            let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: bufferSize)
            defer { buffer.deallocate() }
            let len = element_getValue(id, buffer, Int32(bufferSize))
            if len > 0 {
                let bytes = UnsafeBufferPointer(start: buffer, count: Int(len)).map { UInt8(bitPattern: $0) }
                return String(decoding: bytes, as: UTF8.self)
            }
            return ""
        }
        set {
            var valueBuffer = Array(newValue.utf8)
            valueBuffer.append(0)

            valueBuffer.withUnsafeBufferPointer { ptr in
                ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: valueBuffer.count) { cCharPtr in
                    element_setValue(id, cCharPtr, Int32(valueBuffer.count - 1))
                }
            }
        }
    }
    
    public var selected: Bool {
        get {
            // Internal getAttribute check for now, or add specific extern
            return hasAttribute(.selected)
        }
        set {
            if newValue {
                setAttribute(.selected, true)
            } else {
                removeAttribute(.selected)
            }
        }
    }
}

#endif
