"
I represent a condition variable.
"
Class {
	#name : #PhanideConditionVariable,
	#superclass : #Object,
	#instVars : [
		'mutex',
		'waitingQueue'
	],
	#category : 'Phanide-Bindings-Syncronization'
}

{ #category : #initialization }
PhanideConditionVariable >> initialize [
	mutex := Semaphore forMutualExclusion.
	waitingQueue := OrderedCollection new.
	
]

{ #category : #communication }
PhanideConditionVariable >> signal [
	| process |
	mutex critical: [
		waitingQueue ifNotEmpty: [
			process := waitingQueue removeFirst.
			process resume
		].
	]
]

{ #category : #communication }
PhanideConditionVariable >> signalAll [
	mutex critical: [
		waitingQueue do: #resume.
		waitingQueue removeAll
	]
]

{ #category : #communication }
PhanideConditionVariable >> wait: aSemaphoreMutexToRelease [
	"Release the mutex"
	| activeProcess waitFinished |
	mutex wait.
	aSemaphoreMutexToRelease signal.
	activeProcess := Processor activeProcess.
	waitingQueue add: activeProcess.
	
	"Release the mutex and suspend the active process, atomically."
	waitFinished := Semaphore new.
	[
		activeProcess suspend.
		mutex signal.
		waitFinished signal.
	] forkAt: Processor highestPriority.
	waitFinished wait.
	
	"Reacquire the mutex"
	aSemaphoreMutexToRelease wait
]
