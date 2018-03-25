"
I represent a pipe from a process.
"
Class {
	#name : #PhanideProcessPipe,
	#superclass : #Stream,
	#instVars : [
		'process',
		'index',
		'ready',
		'readyCondition',
		'mutex'
	],
	#pools : [
		'LibPhanidePool'
	],
	#category : 'Phanide-Bindings-Driver'
}

{ #category : #construction }
PhanideProcessPipe class >> forProcess: aProcess index: aPipeIndex [
	^ self basicNew initializeForProcess: aProcess index: aPipeIndex
]

{ #category : #'as yet unclassified' }
PhanideProcessPipe >> convertPipeError: aPipeResult [
	aPipeResult < 0 ifTrue: [
		self error: 'Got an error from a pipe.'
	]
]

{ #category : #initialization }
PhanideProcessPipe >> initializeForProcess: aProcess index: aPipeIndex [
	process := aProcess.
	index := aPipeIndex.
	mutex := Semaphore forMutualExclusion.
	readyCondition := PhanideConditionVariable new.
	ready := true.
]

{ #category : #testing }
PhanideProcessPipe >> isBinary [
	^ true
]

{ #category : #signalling }
PhanideProcessPipe >> signal [
	mutex critical: [ 
		ready := true.
		readyCondition signalAll
	]
	
]
