"
I represent an abstract phanide event subscription.
"
Class {
	#name : #PhanideAbstractEventSubscription,
	#superclass : #Object,
	#category : #'Phanide-Bindings-Event'
}

{ #category : #'dispatching events' }
PhanideAbstractEventSubscription >> deliverEvent: anEvent [
	self subclassResponsibility
]

{ #category : #'dispatching events' }
PhanideAbstractEventSubscription >> unsubscribe [
	self subclassResponsibility
]
