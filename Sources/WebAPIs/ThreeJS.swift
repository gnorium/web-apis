#if os(WASI)

// MARK: - Three.js WASM Bindings

@_extern(wasm, module: "env", name: "three_loadLibrary")
fileprivate func js_three_loadLibrary(_ callbackID: Int32)

public func three_loadLibrary(callback: @escaping @Sendable (String) -> Void) {
	let callbackID = CallbackRegistry.register { message in
		callback(message.toString())
	}
	js_three_loadLibrary(Int32(callbackID))
}

@_extern(wasm, module: "env", name: "three_createScene")
public func three_createScene() -> Int32

@_extern(wasm, module: "env", name: "three_createGroup")
public func three_createGroup() -> Int32

@_extern(wasm, module: "env", name: "three_createPerspectiveCamera")
public func three_createPerspectiveCamera(fov: Double, aspect: Double, near: Double, far: Double) -> Int32

@_extern(wasm, module: "env", name: "three_createOrthographicCamera")
public func three_createOrthographicCamera(left: Double, right: Double, top: Double, bottom: Double, near: Double, far: Double) -> Int32

@_extern(wasm, module: "env", name: "three_createWebGLRenderer")
public func three_createWebGLRenderer(canvasID: Int32, alpha: Int32, antialias: Int32) -> Int32

@_extern(wasm, module: "env", name: "three_setRendererSize")
public func three_setRendererSize(_ rendererID: Int32, width: Int32, height: Int32, pixelRatio: Double)

@_extern(wasm, module: "env", name: "three_setClearColor")
public func three_setClearColor(_ rendererID: Int32, color: Int32, alpha: Double)

@_extern(wasm, module: "env", name: "three_disableShadowMap")
public func three_disableShadowMap(_ rendererID: Int32)

@_extern(wasm, module: "env", name: "three_render")
public func three_render(_ rendererID: Int32, sceneID: Int32, cameraID: Int32)

@_extern(wasm, module: "env", name: "three_compileScene")
public func three_compileScene(_ rendererID: Int32, sceneID: Int32, cameraID: Int32)

@_extern(wasm, module: "env", name: "three_createAmbientLight")
public func three_createAmbientLight(color: Int32, intensity: Double) -> Int32

@_extern(wasm, module: "env", name: "three_createDirectionalLight")
public func three_createDirectionalLight(color: Int32, intensity: Double) -> Int32

@_extern(wasm, module: "env", name: "three_setPosition")
public func three_setPosition(_ objectID: Int32, x: Double, y: Double, z: Double)

@_extern(wasm, module: "env", name: "three_setRotation")
public func three_setRotation(_ objectID: Int32, x: Double, y: Double, z: Double)

@_extern(wasm, module: "env", name: "three_rotateY")
public func three_rotateY(_ objectID: Int32, angle: Double)

@_extern(wasm, module: "env", name: "three_rotateZ")
public func three_rotateZ(_ objectID: Int32, angle: Double)

@_extern(wasm, module: "env", name: "three_setScale")
public func three_setScale(_ objectID: Int32, x: Double, y: Double, z: Double)

@_extern(wasm, module: "env", name: "three_getRotation")
public func three_getRotation(_ objectID: Int32, buffer: UnsafeMutablePointer<Double>) -> Bool

@_extern(wasm, module: "env", name: "three_getPosition")
public func three_getPosition(_ objectID: Int32, buffer: UnsafeMutablePointer<Double>) -> Bool

@_extern(wasm, module: "env", name: "three_getWorldPosition")
public func three_getWorldPosition(_ objectID: Int32, buffer: UnsafeMutablePointer<Double>) -> Bool

@_extern(wasm, module: "env", name: "three_getScale")
public func three_getScale(_ objectID: Int32, buffer: UnsafeMutablePointer<Double>) -> Bool

@_extern(wasm, module: "env", name: "three_getWorldScale")
public func three_getWorldScale(_ objectID: Int32, buffer: UnsafeMutablePointer<Double>) -> Bool

@_extern(wasm, module: "env", name: "three_setVisible")
public func three_setVisible(_ objectID: Int32, _ visible: Int32)

@_extern(wasm, module: "env", name: "three_setCastShadow")
public func three_setCastShadow(_ objectID: Int32, _ castShadow: Int32)

@_extern(wasm, module: "env", name: "three_setMaterialOpacity")
public func three_setMaterialOpacity(_ objectID: Int32, opacity: Double)

@_extern(wasm, module: "env", name: "three_setDepthWrite")
public func three_setDepthWrite(_ objectID: Int32, _ depthWrite: Int32)

@_extern(wasm, module: "env", name: "three_setMaterialDepthWrite")
public func three_setMaterialDepthWrite(_ materialID: Int32, _ depthWrite: Int32)

@_extern(wasm, module: "env", name: "three_setMaterialDepthTest")
public func three_setMaterialDepthTest(_ materialID: Int32, _ depthTest: Int32)

@_extern(wasm, module: "env", name: "three_setMaterialDepthFunc")
public func three_setMaterialDepthFunc(_ materialID: Int32, _ depthFunc: Int32)

@_extern(wasm, module: "env", name: "three_setMaterialAlphaTest")
public func three_setMaterialAlphaTest(_ materialID: Int32, _ alphaTest: Double)

@_extern(wasm, module: "env", name: "three_cleanMaterialMaps")
public func three_cleanMaterialMaps(_ objectID: Int32)

@_extern(wasm, module: "env", name: "three_addToScene")
public func three_addToScene(_ sceneID: Int32, objectID: Int32)

@_extern(wasm, module: "env", name: "three_attachToParent")
public func three_attachToParent(_ parentID: Int32, childID: Int32)

@_extern(wasm, module: "env", name: "three_getParent")
public func three_getParent(_ objectID: Int32) -> Int32

@_extern(wasm, module: "env", name: "three_insertPivot")
public func three_insertPivot(_ pivotID: Int32, childID: Int32) -> Bool

@_extern(wasm, module: "env", name: "three_stopAnimations")
public func three_stopAnimations(_ objectID: Int32)

@_extern(wasm, module: "env", name: "three_removeFromParent")
public func three_removeFromParent(_ objectID: Int32)

@_extern(wasm, module: "env", name: "three_updateMatrixWorld")
public func three_updateMatrixWorld(_ objectID: Int32)

@_extern(wasm, module: "env", name: "three_getName")
fileprivate func js_three_getName(_ objectID: Int32, _ bufferPointer: UnsafeMutablePointer<CChar>, _ bufferLen: Int32) -> Int32

public func three_getName(_ objectID: Int32) -> String {
	var buffer = [CChar](repeating: 0, count: 256)
	let len = js_three_getName(objectID, &buffer, 256)
	if len > 0 {
		let bytes = buffer.prefix(Int(len)).map { UInt8(bitPattern: $0) }
		return String(decoding: bytes, as: UTF8.self)
	}
	return ""
}

@_extern(wasm, module: "env", name: "three_getObjectByName")
fileprivate func js_three_getObjectByName(_ sceneID: Int32, _ namePointer: UnsafePointer<CChar>, _ nameLen: Int32) -> Int32

public func three_getObjectByName(_ sceneID: Int32, _ name: String) -> Int32 {
	return name.withCString { namePtr in
		js_three_getObjectByName(sceneID, namePtr, Int32(name.utf8.count))
	}
}

@_extern(wasm, module: "env", name: "three_loadGLTF")
fileprivate func js_three_loadGLTF(_ urlPointer: UnsafePointer<CChar>, _ urlLen: Int32, _ callbackID: Int32)

public func three_loadGLTF(_ url: String, callback: @escaping @Sendable (String) -> Void) {
	let callbackID = CallbackRegistry.register { message in
		callback(message.toString())
	}
	url.withCString { urlPtr in
		js_three_loadGLTF(urlPtr, Int32(url.utf8.count), Int32(callbackID))
	}
}

@_extern(wasm, module: "env", name: "three_loadUSDZ")
fileprivate func js_three_loadUSDZ(_ urlPointer: UnsafePointer<CChar>, _ urlLen: Int32, _ callbackID: Int32)

public func three_loadUSDZ(_ url: String, callback: @escaping @Sendable (String) -> Void) {
	let callbackID = CallbackRegistry.register { message in
		callback(message.toString())
	}
	url.withCString { urlPtr in
		js_three_loadUSDZ(urlPtr, Int32(url.utf8.count), Int32(callbackID))
	}
}

@_extern(wasm, module: "env", name: "three_traverseScene")
public func three_traverseScene(_ sceneID: Int32, meshBuffer: UnsafeMutablePointer<Int32>, bufferSize: Int32) -> Int32

@_extern(wasm, module: "env", name: "three_cloneGeometry")
public func three_cloneGeometry(_ meshID: Int32) -> Int32

@_extern(wasm, module: "env", name: "three_cloneMaterial")
public func three_cloneMaterial(_ meshID: Int32) -> Int32

@_extern(wasm, module: "env", name: "three_createMesh")
public func three_createMesh(_ geometryID: Int32, materialID: Int32) -> Int32

@_extern(wasm, module: "env", name: "three_bakeSkinnedMesh")
public func three_bakeSkinnedMesh(_ meshID: Int32, _ rootID: Int32) -> Int32

@_extern(wasm, module: "env", name: "three_updateCameraAspect")
public func three_updateCameraAspect(_ cameraID: Int32, aspect: Double)

@_extern(wasm, module: "env", name: "three_cameraLookAt")
public func three_cameraLookAt(_ cameraID: Int32, x: Double, y: Double, z: Double)

@_extern(wasm, module: "env", name: "three_computeBoundingBox")
public func three_computeBoundingBox(_ objectID: Int32, buffer: UnsafeMutablePointer<Double>) -> Bool

@_extern(wasm, module: "env", name: "three_getMeshTexture")
public func three_getMeshTexture(_ meshID: Int32) -> Int32

@_extern(wasm, module: "env", name: "three_setTextureFiltering")
public func three_setTextureFiltering(_ textureID: Int32, _ useNearest: Int32)

@_extern(wasm, module: "env", name: "three_setAllTexturesFiltering")
public func three_setAllTexturesFiltering(_ sceneID: Int32, _ useNearest: Int32)

@_extern(wasm, module: "env", name: "three_createShaderMaterial")
fileprivate func js_three_createShaderMaterial(_ vertexShaderPtr: UnsafePointer<CChar>, _ vertexShaderLen: Int32, _ fragmentShaderPtr: UnsafePointer<CChar>, _ fragmentShaderLen: Int32, _ textureID: Int32) -> Int32

public func three_createShaderMaterial(vertexShader: String, fragmentShader: String, textureID: Int32) -> Int32 {
	return vertexShader.withCString { vertexPtr in
		fragmentShader.withCString { fragmentPtr in
			js_three_createShaderMaterial(vertexPtr, Int32(vertexShader.utf8.count), fragmentPtr, Int32(fragmentShader.utf8.count), textureID)
		}
	}
}

@_extern(wasm, module: "env", name: "three_createBasicMaterial")
public func three_createBasicMaterial(color: Int32, opacity: Double, side: Int32) -> Int32

@_extern(wasm, module: "env", name: "three_getMaterialFromMesh")
public func three_getMaterialFromMesh(_ meshID: Int32) -> Int32

@_extern(wasm, module: "env", name: "three_getGeometryFromMesh")
public func three_getGeometryFromMesh(_ meshID: Int32) -> Int32

@_extern(wasm, module: "env", name: "three_setMeshMaterial")
public func three_setMeshMaterial(_ meshID: Int32, _ materialID: Int32)

@_extern(wasm, module: "env", name: "three_setRenderOrder")
public func three_setRenderOrder(_ meshID: Int32, _ order: Int32)

@_extern(wasm, module: "env", name: "three_setMaterialSide")
public func three_setMaterialSide(_ materialID: Int32, _ side: Int32)

@_extern(wasm, module: "env", name: "window_devicePixelRatio")
fileprivate func js_getDevicePixelRatio() -> Float

public func getDevicePixelRatio() -> Float {
	js_getDevicePixelRatio()
}

// Mouse event helpers
@_extern(wasm, module: "env", name: "event_clientX")
fileprivate func js_getMouseX_raw(_ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32) -> Double

@_extern(wasm, module: "env", name: "event_clientY")
fileprivate func js_getMouseY_raw(_ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32) -> Double

public func getMouseX(_ event: CallbackString) -> Double {
	return event.withCString { ptr in
		js_getMouseX_raw(ptr, Int32(event.len))
	}
}

public func getMouseY(_ event: CallbackString) -> Double {
	return event.withCString { ptr in
		js_getMouseY_raw(ptr, Int32(event.len))
	}
}

@_extern(wasm, module: "env", name: "event_key")
fileprivate func js_getEventKey_raw(_ eventPtr: UnsafePointer<CChar>, _ eventLen: Int32, _ buffer: UnsafeMutablePointer<CChar>, _ bufferLen: Int32) -> Int32

public func getEventKey(_ event: CallbackString) -> String {
	var buffer = [CChar](repeating: 0, count: 256)
	return event.withCString { ptr in
		let len = js_getEventKey_raw(ptr, Int32(event.len), &buffer, 256)
		if len > 0 {
			let bytes = buffer.prefix(Int(len)).map { UInt8(bitPattern: $0) }
			return String(decoding: bytes, as: UTF8.self)
		}
		return ""
	}
}

// MARK: - Namespace-style API

public enum three {
	public static func loadLibrary(callback: @escaping @Sendable (String) -> Void) {
		three_loadLibrary(callback: callback)
	}

	public static func createScene() -> Int32 { three_createScene() }
	public static func createGroup() -> Int32 { three_createGroup() }
	public static func createPerspectiveCamera(fov: Double, aspect: Double, near: Double, far: Double) -> Int32 {
		three_createPerspectiveCamera(fov: fov, aspect: aspect, near: near, far: far)
	}
	public static func createOrthographicCamera(left: Double, right: Double, top: Double, bottom: Double, near: Double, far: Double) -> Int32 {
		three_createOrthographicCamera(left: left, right: right, top: top, bottom: bottom, near: near, far: far)
	}
	public static func createWebGLRenderer(canvasID: Int32, alpha: Int32, antialias: Int32) -> Int32 {
		three_createWebGLRenderer(canvasID: canvasID, alpha: alpha, antialias: antialias)
	}
	public static func setRendererSize(_ renderID: Int32, width: Int32, height: Int32, pixelRatio: Double) {
		three_setRendererSize(renderID, width: width, height: height, pixelRatio: pixelRatio)
	}
	public static func setClearColor(_ renderID: Int32, color: Int32, alpha: Double) {
		three_setClearColor(renderID, color: color, alpha: alpha)
	}
	public static func disableShadowMap(_ renderID: Int32) {
		three_disableShadowMap(renderID)
	}
	public static func render(_ renderID: Int32, sceneID: Int32, cameraID: Int32) {
		three_render(renderID, sceneID: sceneID, cameraID: cameraID)
	}
	public static func compileScene(_ renderID: Int32, sceneID: Int32, cameraID: Int32) {
		three_compileScene(renderID, sceneID: sceneID, cameraID: cameraID)
	}
	public static func createAmbientLight(color: Int32, intensity: Double) -> Int32 {
		three_createAmbientLight(color: color, intensity: intensity)
	}
	public static func createDirectionalLight(color: Int32, intensity: Double) -> Int32 {
		three_createDirectionalLight(color: color, intensity: intensity)
	}
	public static func setPosition(_ objectID: Int32, x: Double, y: Double, z: Double) {
		three_setPosition(objectID, x: x, y: y, z: z)
	}
	public static func setRotation(_ objectID: Int32, x: Double, y: Double, z: Double) {
		three_setRotation(objectID, x: x, y: y, z: z)
	}
	public static func rotateY(_ objectID: Int32, angle: Double) {
		three_rotateY(objectID, angle: angle)
	}
	public static func rotateZ(_ objectID: Int32, angle: Double) {
		three_rotateZ(objectID, angle: angle)
	}
	public static func setScale(_ objectID: Int32, x: Double, y: Double, z: Double) {
		three_setScale(objectID, x: x, y: y, z: z)
	}
	@discardableResult
	public static func getRotation(_ objectID: Int32, buffer: inout [Double]) -> Bool {
		buffer.withUnsafeMutableBufferPointer { ptr in
			three_getRotation(objectID, buffer: ptr.baseAddress!)
		}
	}
	@discardableResult
	public static func getPosition(_ objectID: Int32, buffer: inout [Double]) -> Bool {
		buffer.withUnsafeMutableBufferPointer { ptr in
			three_getPosition(objectID, buffer: ptr.baseAddress!)
		}
	}
	@discardableResult
	public static func getWorldPosition(_ objectID: Int32, buffer: inout [Double]) -> Bool {
		buffer.withUnsafeMutableBufferPointer { ptr in
			three_getWorldPosition(objectID, buffer: ptr.baseAddress!)
		}
	}
	@discardableResult
	public static func getScale(_ objectID: Int32, buffer: inout [Double]) -> Bool {
		buffer.withUnsafeMutableBufferPointer { ptr in
			three_getScale(objectID, buffer: ptr.baseAddress!)
		}
	}
	@discardableResult
	public static func getWorldScale(_ objectID: Int32, buffer: inout [Double]) -> Bool {
		buffer.withUnsafeMutableBufferPointer { ptr in
			three_getWorldScale(objectID, buffer: ptr.baseAddress!)
		}
	}
	public static func setVisible(_ objectID: Int32, _ visible: Int32) {
		three_setVisible(objectID, visible)
	}
	public static func setCastShadow(_ objectID: Int32, _ castShadow: Int32) {
		three_setCastShadow(objectID, castShadow)
	}
	public static func setMaterialOpacity(_ objectID: Int32, opacity: Double) {
		three_setMaterialOpacity(objectID, opacity: opacity)
	}
	public static func setDepthWrite(_ objectID: Int32, _ depthWrite: Int32) {
		three_setDepthWrite(objectID, depthWrite)
	}
	public static func setMaterialDepthWrite(_ materialID: Int32, _ depthWrite: Int32) {
		three_setMaterialDepthWrite(materialID, depthWrite)
	}
	public static func setMaterialDepthTest(_ materialID: Int32, _ depthTest: Int32) {
		three_setMaterialDepthTest(materialID, depthTest)
	}
	public static func setMaterialDepthFunc(_ materialID: Int32, _ depthFunc: Int32) {
		three_setMaterialDepthFunc(materialID, depthFunc)
	}
	public static func setMaterialAlphaTest(_ materialID: Int32, _ alphaTest: Double) {
		three_setMaterialAlphaTest(materialID, alphaTest)
	}
	public static func cleanMaterialMaps(_ objectID: Int32) {
		three_cleanMaterialMaps(objectID)
	}
	public static func addToScene(_ sceneID: Int32, objectID: Int32) {
		three_addToScene(sceneID, objectID: objectID)
	}
	public static func attachToParent(_ parentID: Int32, childID: Int32) {
		three_attachToParent(parentID, childID: childID)
	}
	public static func stopAnimations(_ objectID: Int32) {
		three_stopAnimations(objectID)
	}
	public static func removeFromParent(_ objectID: Int32) {
		three_removeFromParent(objectID)
	}
	public static func updateMatrixWorld(_ objectID: Int32) {
		three_updateMatrixWorld(objectID)
	}
	public static func getName(_ objectID: Int32) -> String {
		three_getName(objectID)
	}
	public static func getObjectByName(_ sceneID: Int32, _ name: String) -> Int32 {
		three_getObjectByName(sceneID, name)
	}
	public static func loadGLTF(_ url: String, callback: @escaping @Sendable (String) -> Void) {
		three_loadGLTF(url, callback: callback)
	}
	public static func loadUSDZ(_ url: String, callback: @escaping @Sendable (String) -> Void) {
		three_loadUSDZ(url, callback: callback)
	}
	public static func traverseScene(_ sceneID: Int32, meshBuffer: inout [Int32], bufferSize: Int32) -> Int32 {
		three_traverseScene(sceneID, meshBuffer: &meshBuffer, bufferSize: bufferSize)
	}
	public static func cloneGeometry(_ meshID: Int32) -> Int32 {
		three_cloneGeometry(meshID)
	}
	public static func cloneMaterial(_ meshID: Int32) -> Int32 {
		three_cloneMaterial(meshID)
	}
	public static func createMesh(_ geometryID: Int32, materialID: Int32) -> Int32 {
		three_createMesh(geometryID, materialID: materialID)
	}
	public static func bakeSkinnedMesh(_ meshID: Int32, _ rootID: Int32) -> Int32 {
		three_bakeSkinnedMesh(meshID, rootID)
	}
	public static func updateCameraAspect(_ cameraID: Int32, aspect: Double) {
		three_updateCameraAspect(cameraID, aspect: aspect)
	}
	public static func cameraLookAt(_ cameraID: Int32, x: Double, y: Double, z: Double) {
		three_cameraLookAt(cameraID, x: x, y: y, z: z)
	}
	@discardableResult
	public static func computeBoundingBox(_ objectID: Int32, buffer: inout [Double]) -> Bool {
		buffer.withUnsafeMutableBufferPointer { ptr in
			three_computeBoundingBox(objectID, buffer: ptr.baseAddress!)
		}
	}
	public static func getMeshTexture(_ meshID: Int32) -> Int32 {
		three_getMeshTexture(meshID)
	}
	public static func setTextureFiltering(_ textureID: Int32, useNearest: Bool) {
		three_setTextureFiltering(textureID, useNearest ? 1 : 0)
	}
	public static func setAllTexturesFiltering(_ sceneID: Int32, useNearest: Bool) {
		three_setAllTexturesFiltering(sceneID, useNearest ? 1 : 0)
	}
	public static func createShaderMaterial(vertexShader: String, fragmentShader: String, textureID: Int32) -> Int32 {
		three_createShaderMaterial(vertexShader: vertexShader, fragmentShader: fragmentShader, textureID: textureID)
	}
	public static func createBasicMaterial(color: Int32, opacity: Double, side: Int32) -> Int32 {
		three_createBasicMaterial(color: color, opacity: opacity, side: side)
	}
	public static func getMaterialFromMesh(_ meshID: Int32) -> Int32 {
		three_getMaterialFromMesh(meshID)
	}
	public static func getGeometryFromMesh(_ meshID: Int32) -> Int32 {
		three_getGeometryFromMesh(meshID)
	}
	public static func setMeshMaterial(_ meshID: Int32, _ materialID: Int32) {
		three_setMeshMaterial(meshID, materialID)
	}
	public static func setRenderOrder(_ meshID: Int32, _ order: Int32) {
		three_setRenderOrder(meshID, order)
	}
	public static func setMaterialSide(_ materialID: Int32, _ side: Int32) {
		three_setMaterialSide(materialID, side)
	}
}

#endif
