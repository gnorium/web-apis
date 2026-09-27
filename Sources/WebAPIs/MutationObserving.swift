#if CLIENT
  import DOMBuilder
  import EmbeddedSwiftUtilities
  import WebTypes

  extension DOM.Element {
    /// `MutationObserver` on this element, as the DOM's own `observe(target,
    /// options)`: `callback` runs once for each batch of changes the browser
    /// delivers (after the task that made them, never mid-change). The batch's
    /// records are not passed on; a caller reads the DOM it cares about.
    ///
    /// `attributeFilter`, when not empty, observes those attributes only
    /// (and implies `attributes`).
    public func observeMutations(
      childList: Bool = false,
      subtree: Bool = false,
      characterData: Bool = false,
      attributes: Bool = false,
      attributeFilter: [String] = [],
      _ callback: @escaping @Sendable () -> Void
    ) {
      let callbackID = CallbackRegistry.register { _ in callback() }
      var filter: [String] = []
      for name in attributeFilter { filter.append("\"\(name)\"") }
      let watchesAttributes = attributes || !attributeFilter.isEmpty
      var options =
        "{\"childList\":\(childList ? "true" : "false"),\"subtree\":\(subtree ? "true" : "false")"
        + ",\"characterData\":\(characterData ? "true" : "false")"
        + ",\"attributes\":\(watchesAttributes ? "true" : "false")"
      if !attributeFilter.isEmpty {
        options += ",\"attributeFilter\":[\(stringJoin(filter, separator: ","))]"
      }
      options += "}"
      var buffer = Array(options.utf8)
      buffer.append(0)
      buffer.withUnsafeBufferPointer { pointer in
        pointer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) { optionsPointer in
          element_observeMutations(id, optionsPointer, Int32(buffer.count - 1), Int32(callbackID))
        }
      }
    }
  }

  @_extern(wasm, module: "env", name: "element_observeMutations")
  func element_observeMutations(
    _ elementID: Int32, _ optionsPointer: UnsafePointer<CChar>, _ optionsLen: Int32, _ callbackID: Int32)
#endif
