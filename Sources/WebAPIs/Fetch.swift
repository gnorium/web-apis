import WebTypes
#if CLIENT
  import EmbeddedSwiftUtilities

  /// The Fetch standard's `RequestInit`, as far as the page uses it: the
  /// method, the headers, and a body of text or a `FormData` (sent as
  /// `multipart/form-data`, its boundary chosen by the browser, so no
  /// Content-Type is given for it). `credentials` is the standard's default,
  /// `same-origin`: a request to another origin carries no cookies.
  public struct RequestInit: Sendable {
    public enum Body: Sendable {
      case text(String)
      case formData(FormData)
    }

    public var method: String
    public var headers: [(String, String)]
    public var body: Body?

    public init(method: String = "GET", headers: [(String, String)] = [], body: Body? = nil) {
      self.method = method
      self.headers = headers
      self.body = body
    }
  }

  /// The Fetch standard's `Response`, read whole: its status (0 when the
  /// request never got one: a network error, or a refusal by CORS), whether
  /// it is `ok` (2xx), and its body as text.
  public struct Response: Sendable {
    public let status: Int
    public let text: String

    public var ok: Bool { status >= 200 && status < 300 }
  }

  extension Window {
    /// `fetch(url, init)`, then `response.text()`: the callback has the
    /// status and the body.
    public func fetch(_ url: String, _ options: RequestInit, _ callback: @escaping @Sendable (Response) -> Void) {
      let callbackID = CallbackRegistry.register { result in
        // "<status>\n<body>"
        var status = 0
        var index = 0
        while index < result.len {
          let byte = UInt8(bitPattern: result.ptr[index])
          if byte == 10 { break }
          if byte >= 48 && byte <= 57 { status = status * 10 + Int(byte - 48) }
          index += 1
        }
        let start = index < result.len ? index + 1 : result.len
        let bytes = UnsafeBufferPointer(start: result.ptr + start, count: result.len - start).map {
          UInt8(bitPattern: $0)
        }
        callback(Response(status: status, text: String(decoding: bytes, as: UTF8.self)))
      }
      // Headers as "name\nvalue\n" pairs.
      var headerText: [UInt8] = []
      for (name, value) in options.headers {
        headerText.append(contentsOf: name.utf8)
        headerText.append(10)
        headerText.append(contentsOf: value.utf8)
        headerText.append(10)
      }
      var bodyText: [UInt8] = []
      var formDataHandle: Int32 = -1
      switch options.body {
      case .text(let text)?: bodyText = Array(text.utf8)
      case .formData(let formData)?: formDataHandle = formData.handle
      case nil: break
      }
      let hasTextBody: Int32 = {
        if case .text? = options.body { return 1 }
        return 0
      }()
      var urlBuffer = Array(url.utf8)
      var methodBuffer = Array(options.method.utf8)
      urlBuffer.withUnsafeMutableBufferPointer { urlPointer in
        methodBuffer.withUnsafeMutableBufferPointer { methodPointer in
          headerText.withUnsafeMutableBufferPointer { headerPointer in
            bodyText.withUnsafeMutableBufferPointer { bodyPointer in
              window_fetchRequest(
                urlPointer.baseAddress, Int32(urlPointer.count), methodPointer.baseAddress,
                Int32(methodPointer.count), headerPointer.baseAddress, Int32(headerPointer.count),
                hasTextBody, bodyPointer.baseAddress, Int32(bodyPointer.count), formDataHandle, Int32(callbackID))
            }
          }
        }
      }
    }
  }

  @_extern(wasm, module: "env", name: "window_fetchRequest")
  func window_fetchRequest(
    _ url: UnsafeMutablePointer<UInt8>?, _ urlLen: Int32, _ method: UnsafeMutablePointer<UInt8>?, _ methodLen: Int32,
    _ headers: UnsafeMutablePointer<UInt8>?, _ headersLen: Int32, _ hasTextBody: Int32,
    _ body: UnsafeMutablePointer<UInt8>?, _ bodyLen: Int32, _ formDataHandle: Int32, _ callbackID: Int32)
#endif
