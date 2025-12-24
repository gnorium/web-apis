#if os(WASI)

public func setTimeout(_ ms: Int, _ callback: @escaping @Sendable () -> Void) -> Int32 {
	let callbackId = CallbackRegistry.register { _ in
		callback()
	}
	return timing_setTimeout(Int32(ms), Int32(callbackId))
}

public func clearTimeout(_ timerId: Int32) {
	timing_clearTimeout(timerId)
}

@_extern(wasm, module: "env", name: "timing_setTimeout")
fileprivate func timing_setTimeout(_ ms: Int32, _ callbackId: Int32) -> Int32

@_extern(wasm, module: "env", name: "timing_clearTimeout")
fileprivate func timing_clearTimeout(_ timerId: Int32)

#endif
