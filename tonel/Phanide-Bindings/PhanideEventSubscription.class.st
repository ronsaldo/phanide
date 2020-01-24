"
I am a particular Phanide event subscription. I can be removed with the #unsubscribe message.
"
Class {
	#name : #PhanideEventSubscription,
	#superclass : #PhanideAbstractEventSubscription,
	#instVars : [
		'dispatcher',
		'eventClass',
		'action'
	],
	#category : #'Phanide-Bindings-Event'
}

{ #category : #accessing }
PhanideEventSubscription >> action [
	^ action
]

{ #category : #accessing }
PhanideEventSubscription >> action: anObject [
	action := anObject
]

{ #category : #'dispatching events' }
PhanideEventSubscription >> deliverEvent: anEvent [
	UIManager default defer: [ 
		action cull: anEvent cull: self
	].

]

{ #category : #accessing }
PhanideEventSubscription >> dispatcher [
	^ dispatcher
]

{ #category : #accessing }
PhanideEventSubscription >> dispatcher: anObject [
	dispatcher := anObject
]

{ #category : #accessing }
PhanideEventSubscription >> eventClass [
	^ eventClass
]

{ #category : #accessing }
PhanideEventSubscription >> eventClass: anObject [
	eventClass := anObject
]

{ #category : #'dispatching events' }
PhanideEventSubscription >> unsubscribe [
	dispatcher ifNotNil: [ :d |
		d removeSubscription: self
	].
]
