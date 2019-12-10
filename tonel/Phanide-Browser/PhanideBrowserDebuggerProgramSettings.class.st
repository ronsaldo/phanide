Class {
	#name : #PhanideBrowserDebuggerProgramSettings,
	#superclass : #Object,
	#instVars : [
		'programFileReference',
		'arguments',
		'workingDirectory',
		'name'
	],
	#category : #'Phanide-Browser-Debugging'
}

{ #category : #'instance creation' }
PhanideBrowserDebuggerProgramSettings class >> for: aFileReference [
	^ self new
		name: aFileReference basename;
		programFileReference: aFileReference;
		workingDirectory: aFileReference parent;
		yourself
]

{ #category : #accessing }
PhanideBrowserDebuggerProgramSettings >> arguments [
	^ arguments
]

{ #category : #accessing }
PhanideBrowserDebuggerProgramSettings >> arguments: anObject [
	arguments := anObject
]

{ #category : #initialization }
PhanideBrowserDebuggerProgramSettings >> initialize [
	super initialize.
	arguments := #().
]

{ #category : #accessing }
PhanideBrowserDebuggerProgramSettings >> name [
	^ name
]

{ #category : #accessing }
PhanideBrowserDebuggerProgramSettings >> name: anObject [
	name := anObject
]

{ #category : #printing }
PhanideBrowserDebuggerProgramSettings >> printOn: aStream [
	aStream nextPutAll: name
]

{ #category : #accessing }
PhanideBrowserDebuggerProgramSettings >> programFileReference [
	^ programFileReference
]

{ #category : #accessing }
PhanideBrowserDebuggerProgramSettings >> programFileReference: anObject [
	programFileReference := anObject
]

{ #category : #accessing }
PhanideBrowserDebuggerProgramSettings >> workingDirectory [
	^ workingDirectory
]

{ #category : #accessing }
PhanideBrowserDebuggerProgramSettings >> workingDirectory: anObject [
	workingDirectory := anObject
]
