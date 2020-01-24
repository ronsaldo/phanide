Class {
	#name : #PhanideFileSystemMonitorFileState,
	#superclass : #Object,
	#instVars : [
		'fileReference',
		'isDirectory',
		'size',
		'name'
	],
	#category : #'Phanide-Bindings-FileSystem'
}

{ #category : #'instance creation' }
PhanideFileSystemMonitorFileState class >> for: aFileReference [
	^ self new
		fileReference: aFileReference;
		isDirectory: aFileReference isDirectory;
		size: aFileReference size;
		yourself
]

{ #category : #comparing }
PhanideFileSystemMonitorFileState >> <= other [
	^ self name <= other name
]

{ #category : #accessing }
PhanideFileSystemMonitorFileState >> fileReference [
	^ fileReference
]

{ #category : #accessing }
PhanideFileSystemMonitorFileState >> fileReference: anObject [
	fileReference := anObject
]

{ #category : #accessing }
PhanideFileSystemMonitorFileState >> isDirectory [
	^ isDirectory
]

{ #category : #accessing }
PhanideFileSystemMonitorFileState >> isDirectory: anObject [
	isDirectory := anObject
]

{ #category : #accessing }
PhanideFileSystemMonitorFileState >> name [
	^ name ifNil: [name := fileReference basename]
]

{ #category : #printing }
PhanideFileSystemMonitorFileState >> printOn: aStream [
	self name printOn: aStream
]

{ #category : #accessing }
PhanideFileSystemMonitorFileState >> size [
	^ size
]

{ #category : #accessing }
PhanideFileSystemMonitorFileState >> size: anObject [
	size := anObject
]
