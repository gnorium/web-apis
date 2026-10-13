#if CLIENT
  import DOMBuilder
  import WebTypes

  extension DOM {
    /// The DOM's own `TextMetrics`, as `measureText` answers it: the text's
    /// advance and its boxes in CSS pixels of the context's font, measured
    /// from the text's start (across, positive to the right of it for a box's
    /// right edge, to the left of it for its left edge) and from its
    /// alphabetic baseline (up, positive above it for an ascent, below it for
    /// a descent). The font box is the font's ascent and descent, the box a
    /// line of the text lays out in; the actual box is its glyphs' ink.
    public struct TextMetrics: Sendable {
      public let width: Double
      public let actualBoundingBoxLeft: Double
      public let actualBoundingBoxRight: Double
      public let fontBoundingBoxAscent: Double
      public let fontBoundingBoxDescent: Double
      public let actualBoundingBoxAscent: Double
      public let actualBoundingBoxDescent: Double
      public let emHeightAscent: Double
      public let emHeightDescent: Double
      public let hangingBaseline: Double
      public let alphabeticBaseline: Double
      public let ideographicBaseline: Double
    }

    /// The DOM's own `CanvasRenderingContext2D`, as a canvas's
    /// `getContext("2d")` makes it: its text state and `measureText`. It is
    /// released when the last reference to it goes.
    public final class CanvasRenderingContext2D: @unchecked Sendable {
      let handle: Int32

      init(handle: Int32) {
        self.handle = handle
      }

      deinit {
        domObject_release(handle)
      }

      /// `font`: the CSS `font` shorthand text is set in ("italic 600 16px
      /// serif"); a value that does not parse leaves it as it was.
      public var font: String {
        get { property("font") }
        set { setProperty("font", newValue) }
      }

      /// `fontKerning`: "auto", "normal" or "none".
      public var fontKerning: String {
        get { property("fontKerning") }
        set { setProperty("fontKerning", newValue) }
      }

      /// `fontVariantCaps`: "normal", "small-caps", "all-small-caps",
      /// "petite-caps", "all-petite-caps", "unicase" or "titling-caps".
      public var fontVariantCaps: String {
        get { property("fontVariantCaps") }
        set { setProperty("fontVariantCaps", newValue) }
      }

      /// `fontStretch`: "normal", "condensed", "expanded" and the rest of
      /// CSS's keywords.
      public var fontStretch: String {
        get { property("fontStretch") }
        set { setProperty("fontStretch", newValue) }
      }

      /// `letterSpacing`: a CSS length ("0.1em", "2px").
      public var letterSpacing: String {
        get { property("letterSpacing") }
        set { setProperty("letterSpacing", newValue) }
      }

      /// `wordSpacing`: a CSS length.
      public var wordSpacing: String {
        get { property("wordSpacing") }
        set { setProperty("wordSpacing", newValue) }
      }

      /// `direction`: "ltr", "rtl" or "inherit".
      public var direction: String {
        get { property("direction") }
        set { setProperty("direction", newValue) }
      }

      /// `measureText(text)`.
      public func measureText(_ text: String) -> TextMetrics {
        let buffer = UnsafeMutablePointer<Double>.allocate(capacity: Self.metricsCount)
        defer { buffer.deallocate() }
        var bytes = Array(text.utf8)
        bytes.append(0)
        bytes.withUnsafeBufferPointer { pointer in
          canvasContext2D_measureText(handle, pointer.baseAddress!, Int32(bytes.count - 1), buffer)
        }
        return TextMetrics(
          width: buffer[0], actualBoundingBoxLeft: buffer[1], actualBoundingBoxRight: buffer[2],
          fontBoundingBoxAscent: buffer[3], fontBoundingBoxDescent: buffer[4],
          actualBoundingBoxAscent: buffer[5], actualBoundingBoxDescent: buffer[6],
          emHeightAscent: buffer[7], emHeightDescent: buffer[8],
          hangingBaseline: buffer[9], alphabeticBaseline: buffer[10], ideographicBaseline: buffer[11])
      }

      /// The values `measureText` writes, in `TextMetrics`'s order.
      static let metricsCount = 12
      /// Room for a text property's value as the bridge copies it.
      static let propertyCapacity = 1024

      private func property(_ name: StaticString) -> String {
        var result = [UInt8](repeating: 0, count: Self.propertyCapacity)
        let length = name.withUTF8Buffer { nameBuffer in
          canvasContext2D_getProperty(
            handle, nameBuffer.baseAddress!, Int32(nameBuffer.count), &result, Int32(Self.propertyCapacity))
        }
        return String(decoding: result[0..<Int(max(0, length))], as: UTF8.self)
      }

      private func setProperty(_ name: StaticString, _ value: String) {
        var bytes = Array(value.utf8)
        bytes.append(0)
        name.withUTF8Buffer { nameBuffer in
          bytes.withUnsafeBufferPointer { valueBuffer in
            canvasContext2D_setProperty(
              handle, nameBuffer.baseAddress!, Int32(nameBuffer.count), valueBuffer.baseAddress!,
              Int32(bytes.count - 1))
          }
        }
      }
    }
  }

  extension DOM.Element {
    /// `HTMLCanvasElement.getContext(contextId)` for "2d": the canvas's 2D
    /// context; nil for an element that is no canvas, or another kind of
    /// context.
    public func getContext(_ contextId: StaticString) -> DOM.CanvasRenderingContext2D? {
      let handle = contextId.withUTF8Buffer { buffer in
        canvas_getContext(id, buffer.baseAddress!, Int32(buffer.count))
      }
      return handle >= 0 ? DOM.CanvasRenderingContext2D(handle: handle) : nil
    }
  }

  /// A canvas's context by `getContext(contextId)`, held by the bridge;
  /// -1 where it is no canvas or the context is no 2D context.
  @_extern(wasm, module: "env", name: "canvas_getContext")
  func canvas_getContext(_ elementID: Int32, _ contextID: UnsafePointer<UInt8>, _ contextIDLength: Int32) -> Int32

  /// A 2D context's text property as UTF-8 into `buffer`, at most
  /// `max - 1` bytes and a terminator; returns how many it wrote.
  @_extern(wasm, module: "env", name: "canvasContext2D_getProperty")
  func canvasContext2D_getProperty(
    _ handle: Int32, _ name: UnsafePointer<UInt8>, _ nameLength: Int32, _ buffer: UnsafeMutablePointer<UInt8>,
    _ max: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "canvasContext2D_setProperty")
  func canvasContext2D_setProperty(
    _ handle: Int32, _ name: UnsafePointer<UInt8>, _ nameLength: Int32, _ value: UnsafePointer<UInt8>,
    _ valueLength: Int32)

  /// `measureText(text)`'s twelve metrics into `buffer`, in `TextMetrics`'s
  /// order.
  @_extern(wasm, module: "env", name: "canvasContext2D_measureText")
  func canvasContext2D_measureText(
    _ handle: Int32, _ text: UnsafePointer<UInt8>, _ textLength: Int32, _ buffer: UnsafeMutablePointer<Double>)
#endif
