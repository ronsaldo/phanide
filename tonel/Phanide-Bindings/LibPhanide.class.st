"
I have bindings to global libphanide functions.
"
Class {
	#name : #LibPhanide,
	#superclass : #PhaNAPILibrary,
	#pools : [
		'LibPhanidePool'
	],
	#category : #'Phanide-Bindings-Bindings'
}

{ #category : #testing }
LibPhanide class >> isAvailable [
	^ self uniqueInstance isAvailable
]

{ #category : #'library path' }
LibPhanide >> findLibraryPath [
	^ PhaNAPI fullLibraryPathForCurrentPlatform: 'phanide' package: 'phanide'
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
