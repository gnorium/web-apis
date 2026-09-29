#if CLIENT
  import DOMBuilder
  import WebTypes

  /// The CSS Custom Highlight API's `Highlight`: a set of ranges painted by a
  /// `::highlight(name)` rule once it is registered under that name in
  /// `CSS.highlights`. Nothing is written into the document.
  public final class Highlight: @unchecked Sendable {
    let handle: Int32

    /// `new Highlight(...ranges)`.
    public init(_ ranges: [DOM.Range] = []) {
      handle = highlight_create()
      for range in ranges { add(range) }
    }

    deinit {
      domObject_release(handle)
    }

    /// `add(range)`.
    public func add(_ range: DOM.Range) {
      highlight_add(handle, range.handle)
    }

    /// `clear()`.
    public func clear() {
      highlight_clear(handle)
    }

    /// `priority`: which of two overlapping highlights paints on top (the
    /// higher).
    public var priority: Int {
      get { Int(highlight_getPriority(handle)) }
      set { highlight_setPriority(handle, Int32(newValue)) }
    }
  }

  /// `CSS.highlights`, the document's `HighlightRegistry`: the highlights
  /// painted, by name.
  public struct HighlightRegistry: Sendable {
    /// `set(name, highlight)`.
    public func set(_ name: String, _ highlight: Highlight) {
      var buffer = Array(name.utf8)
      buffer.append(0)
      buffer.withUnsafeBufferPointer { pointer in
        pointer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) {
          highlights_set($0, Int32(buffer.count - 1), highlight.handle)
        }
      }
    }

    /// `delete(name)`.
    public func delete(_ name: String) {
      var buffer = Array(name.utf8)
      buffer.append(0)
      buffer.withUnsafeBufferPointer { pointer in
        pointer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count) {
          highlights_delete($0, Int32(buffer.count - 1))
        }
      }
    }

    /// `clear()`.
    public func clear() {
      highlights_clear()
    }
  }

  extension CSS {
    /// `CSS.highlights`.
    public static var highlights: HighlightRegistry { HighlightRegistry() }
  }

  @_extern(wasm, module: "env", name: "highlight_create")
  func highlight_create() -> Int32

  @_extern(wasm, module: "env", name: "highlight_add")
  func highlight_add(_ handle: Int32, _ rangeHandle: Int32)

  @_extern(wasm, module: "env", name: "highlight_clear")
  func highlight_clear(_ handle: Int32)

  @_extern(wasm, module: "env", name: "highlight_getPriority")
  func highlight_getPriority(_ handle: Int32) -> Int32

  @_extern(wasm, module: "env", name: "highlight_setPriority")
  func highlight_setPriority(_ handle: Int32, _ priority: Int32)

  @_extern(wasm, module: "env", name: "highlights_set")
  func highlights_set(_ namePointer: UnsafePointer<CChar>, _ nameLen: Int32, _ handle: Int32)

  @_extern(wasm, module: "env", name: "highlights_delete")
  func highlights_delete(_ namePointer: UnsafePointer<CChar>, _ nameLen: Int32)

  @_extern(wasm, module: "env", name: "highlights_clear")
  func highlights_clear()
#endif
