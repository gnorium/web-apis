#if os(WASI)

@_extern(wasm, module: "env", name: "mermaid_initialize")
fileprivate func js_mermaid_initialize()

public enum Mermaid {
    public static func initialize() {
        js_mermaid_initialize()
    }
}

#endif
