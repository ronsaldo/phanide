Class {
	#name : #PhideAbstractProgramLaunchSession,
	#superclass : #Object,
	#category : #'Phanide-ProjectModel'
}

{ #category : #actions }
PhideAbstractProgramLaunchSession >> isRunning [
	self subclassResponsibility
]

{ #category : #enumerating }
PhideAbstractProgramLaunchSession >> onStderrMessageDo: aBlock [
	self subclassResponsibility
]

{ #category : #enumerating }
PhideAbstractProgramLaunchSession >> onStdoutMessageDo: aBlock [
	self subclassResponsibility
]

{ #category : #enumerating }
PhideAbstractProgramLaunchSession >> sendMessageToStdin: message [
	self subclassResponsibility
]

{ #category : #accessing }
PhideAbstractProgramLaunchSession >> start [
	self subclassResponsibility
]

{ #category : #actions }
PhideAbstractProgramLaunchSession >> terminate [
	self subclassResponsibility
]

{ #category : #actions }
PhideAbstractProgramLaunchSession >> whenFinishedDo: aBlock [
	self subclassResponsibility
]
