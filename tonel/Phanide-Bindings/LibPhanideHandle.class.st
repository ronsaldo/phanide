Class {
	#name : #LibPhanideHandle,
	#superclass : #FFIExternalObject,
	#pools : [
		'LibPhanidePool'
	],
	#category : 'Phanide-Bindings-Bindings'
}

{ #category : #'library path' }
LibPhanideHandle class >> ffiLibraryName [
	^ LibPhanide
]

{ #category : #'library path' }
LibPhanideHandle >> ffiLibraryName [
	^ LibPhanide
]
