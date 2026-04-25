#if CLIENT
  @_extern(wasm, module: "env", name: "hljs_highlightAll")
  private func js_hljs_highlightAll()

  public enum HighlightJS {
    public static func highlightAll() {
      js_hljs_highlightAll()
    }
  }
#endif
