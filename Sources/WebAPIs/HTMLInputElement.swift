#if os(WASI)

import EmbeddedSwiftUtilities
import WebTypes

public class HTMLInputElement: HTMLElement, @unchecked Sendable {
    public var value: String {
        get {
            let bufferSize = 1024 * 4
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

    public var checked: Bool {
        get {
            return element_getChecked(id) != 0
        }
        set {
            element_setChecked(id, newValue ? 1 : 0)
        }
    }

    public var disabled: Bool {
        get {
            return element_getDisabled(id) != 0
        }
        set {
            element_setDisabled(id, newValue ? 1 : 0)
        }
    }
}

#endif
