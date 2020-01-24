"
I am a null phanide event subscription. All of my operations are a nop.
"
Class {
	#name : #PhanideNullEventSubscription,
	#superclass : #PhanideAbstractEventSubscription,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Phanide-Bindings-Event'
}

{ #category : #accessing }
PhanideNullEventSubscription class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #'dispatching events' }
PhanideNullEventSubscription >> deliverEvent: anEvent [
	"Do nothing"
]

{ #category : #'dispatching events' }
PhanideNullEventSubscription >> unsubscribe [
	"Do nothing"
]
