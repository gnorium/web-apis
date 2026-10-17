#if CLIENT
  import DOMBuilder
  import HTMLBuilder
  import WebTypes

  /// `HTMLDialogElement`'s own methods.
  extension HTML.HTMLDialogElement {
    /// `showModal()`: opens it as a modal, in the top layer—over everything
    /// on the page whatever its z-index or the stacking context it stands
    /// in—with its `::backdrop` under it and the rest of the page inert (no
    /// focus, click or selection). Escape closes it (a `cancel`, then a
    /// `close` event); the focus goes into it, and back to what had it when
    /// it closes. A dialog already open, or not in the page, is left as it is
    /// (where the platform would throw).
    public func showModal() {
      dialog_showModal(id)
    }

    /// `show()`: opens it where it stands, not modal.
    public func show() {
      dialog_show(id)
    }

    /// `close()`: closes it, firing `close`.
    public func close() {
      dialog_close(id)
    }
  }

  @_extern(wasm, module: "env", name: "dialog_showModal")
  func dialog_showModal(_ elementID: Int32)

  @_extern(wasm, module: "env", name: "dialog_show")
  func dialog_show(_ elementID: Int32)

  @_extern(wasm, module: "env", name: "dialog_close")
  func dialog_close(_ elementID: Int32)
#endif
