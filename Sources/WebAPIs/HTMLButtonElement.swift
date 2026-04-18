#if os(WASI)

import EmbeddedSwiftUtilities
import WebTypes

public class HTMLButtonElement: HTMLElement, @unchecked Sendable {
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
