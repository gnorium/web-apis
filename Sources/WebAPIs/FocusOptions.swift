#if CLIENT
  import WebTypes

  extension DOM {
    /// The dictionary `HTMLElement.focus()` takes.
    public struct FocusOptions: Sendable {
      public let preventScroll: Bool
      public let focusVisible: Bool

      public init(preventScroll: Bool = false, focusVisible: Bool = false) {
        self.preventScroll = preventScroll
        self.focusVisible = focusVisible
      }
    }
  }
#endif
