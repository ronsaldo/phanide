"
I represent a external subprocess.
"
Class {
	#name : #PhanideProcess,
	#superclass : #Object,
	#instVars : [
		'driver',
		'handle',
		'exitCode',
		'finishedCondition',
		'mutex',
		'pipes'
	],
	#pools : [
		'LibPhanidePool'
	],
	#category : 'Phanide-Bindings-Driver'
}

{ #category : #'instance creation' }
PhanideProcess class >> newWithDriver: driver handle: handle [
	^ self basicNew initializeWithDriver: driver handle: handle
]

{ #category : #accessing }
PhanideProcess >> driver [
	^ driver
]

{ #category : #events }
PhanideProcess >> finishedWithExitCode: anExitCode [
	mutex critical: [ 
		exitCode := anExitCode.
		finishedCondition signal
	]
	
	
]

{ #category : #accessing }
PhanideProcess >> handle [
	^ handle
]

{ #category : #initialization }
PhanideProcess >> initializeWithDriver: aDriver handle: aHandle [
	driver := aDriver.
	handle := aHandle.
	mutex := Semaphore forMutualExclusion.
	finishedCondition := PhanideConditionVariable new.
	pipes := {
		"stdin" PhanideProcessWritePipe forProcess: self index: 0 .
		"stdout" PhanideProcessReadPipe forProcess: self index: 1 .
		"stderr" PhanideProcessReadPipe forProcess: self index: 2
	}
]

{ #category : #events }
PhanideProcess >> signalPipe: pipeIndex [
	(pipes at: pipeIndex + 1) signal
]

{ #category : #accessing }
PhanideProcess >> stderr [
	^ pipes at: PHANIDE_PIPE_INDEX_STDERR + 1
]

{ #category : #accessing }
PhanideProcess >> stdin [
	^ pipes at: PHANIDE_PIPE_INDEX_STDIN + 1
]

{ #category : #accessing }
PhanideProcess >> stdout [
	^ pipes at: PHANIDE_PIPE_INDEX_STDOUT + 1
]

{ #category : #waiting }
PhanideProcess >> wait [
	mutex critical: [
		[exitCode] whileNil: [ 
			finishedCondition wait: mutex
		].
	
		^ exitCode
	]
]
