#if os(WASI)

import EmbeddedSwiftUtilities
import WebTypes

public class HTMLElement: Element, @unchecked Sendable {
    public var offsetWidth: Int32 {
        element_getOffsetWidth(id)
    }
}

#endif
