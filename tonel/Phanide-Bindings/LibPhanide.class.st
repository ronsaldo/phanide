"
I have bindings to global libphanide functions.
"
Class {
	#name : #LibPhanide,
	#superclass : #FFILibrary,
	#pools : [
		'LibPhanidePool'
	],
	#category : #'Phanide-Bindings-Bindings'
}

{ #category : #testing }
LibPhanide class >> isAvailable [
	^ self uniqueInstance isAvailable
]

{ #category : #'libgit-finalization' }
LibPhanide >> free: pointer [
	^ self ffiCall: #(void phanide_free(void* pointer))
]

{ #category : #testing }
LibPhanide >> isAvailable [
	| result |
	result := true.
	[
		ExternalAddress loadSymbol: 'phanide_createContext' from: self
	] on: Error do: [ :e | result := false ].
	^ result
]

{ #category : #'accessing platform' }
LibPhanide >> macModuleName [
	^ 'libphanide.dylib'
]

{ #category : #'accessing platform' }
LibPhanide >> unixModuleName [
	^ 'libphanide.so'
]

{ #category : #'accessing platform' }
LibPhanide >> win32ModuleName [
	^ 'phanide.dll'
]
