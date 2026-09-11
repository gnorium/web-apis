#if CLIENT
  @_extern(wasm, module: "env", name: "hljs_highlightAll")
  private func js_hljs_highlightAll()

  @_extern(wasm, module: "env", name: "hljs_highlightElement")
  private func js_hljs_highlightElement(_ elementID: Int32)

  public enum HighlightJS {
    public static func highlightAll() {
      js_hljs_highlightAll()
    }

    public static func highlightElement(elementID: Int32) {
      js_hljs_highlightElement(elementID)
    }
  }
#endif
