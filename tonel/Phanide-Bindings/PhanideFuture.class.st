"
I represent a future value.
"
Class {
	#name : #PhanideFuture,
	#superclass : #Object,
	#instVars : [
		'value',
		'mutex',
		'ready',
		'readyCondition'
	],
	#category : 'Phanide-Bindings-Syncronization'
}

{ #category : #initialization }
PhanideFuture >> initialize [
	super initialize.
	ready := false.
	mutex := Semaphore forMutualExclusion.
	readyCondition := PhanideConditionVariable new.
]

{ #category : #accessing }
PhanideFuture >> value [
	mutex critical: [ 
		[ ready ] whileFalse: [
			readyCondition wait: mutex
		].
	
		^ value
	]
]

{ #category : #accessing }
PhanideFuture >> value: aValue [
	mutex critical: [ 
		ready ifTrue: [
			self error: 'Future value can only be set once.'
		].

		value := aValue.
		ready := true.
		readyCondition signalAll.
	].
	^ aValue
]
