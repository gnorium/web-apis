#if CLIENT
  import EmbeddedSwiftUtilities

  /// A wrapper for EventSource (Server-Sent Events)
  public final class EventSource: @unchecked Sendable {
    private let sseID: Int32
    private var isClosed = false

    /// Create an EventSource connection to the given URL
    /// - Parameters:
    ///   - url: The SSE endpoint URL
    ///   - onStart: Called when the 'start' event is received
    ///   - onChunk: Called when a 'chunk' event is received
    ///   - onDone: Called when the 'done' event is received
    ///   - onError: Called when an error occurs
    public init(
      url: String,
      onStart: @escaping @Sendable (String) -> Void,
      onChunk: @escaping @Sendable (String) -> Void,
      onDone: @escaping @Sendable (String) -> Void,
      onError: @escaping @Sendable (String) -> Void
    ) {
      let startCallbackID = CallbackRegistry.register { data in
        onStart(data.toString())
      }
      let chunkCallbackID = CallbackRegistry.register { data in
        onChunk(data.toString())
      }
      let doneCallbackID = CallbackRegistry.register { data in
        onDone(data.toString())
      }
      let errorCallbackID = CallbackRegistry.register { data in
        onError(data.toString())
      }

      var urlBuffer = Array(url.utf8)
      urlBuffer.append(0)

      self.sseID = urlBuffer.withUnsafeBufferPointer { ptr in
        ptr.baseAddress!.withMemoryRebound(to: CChar.self, capacity: urlBuffer.count) { pointer in
          sse_create(
            pointer, Int32(urlBuffer.count - 1),
            Int32(startCallbackID),
            Int32(chunkCallbackID),
            Int32(doneCallbackID),
            Int32(errorCallbackID)
          )
        }
      }
    }

    /// Close the EventSource connection
    public func close() {
      guard !isClosed else { return }
      isClosed = true
      sse_close(sseID)
    }

    deinit {
      close()
    }
  }

  @_extern(wasm, module: "env", name: "sse_create")
  func sse_create(
    _ urlPointer: UnsafePointer<CChar>, _ urlLen: Int32,
    _ startCallbackID: Int32,
    _ chunkCallbackID: Int32,
    _ doneCallbackID: Int32,
    _ errorCallbackID: Int32
  ) -> Int32

  @_extern(wasm, module: "env", name: "sse_close")
  func sse_close(_ sseID: Int32)
#endif
