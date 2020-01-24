"
I am a Phanide event dispatcher. I take care of managing event subscriptions, and delivering events to the subscribers.
"
Class {
	#name : #PhanideEventDispatcher,
	#superclass : #Object,
	#instVars : [
		'mutex',
		'subscriptionRegistry',
		'childDispatchers',
		'parentDispatcher',
		'childEventClassCounts',
		'owner'
	],
	#category : #'Phanide-Bindings-Event'
}

{ #category : #'as yet unclassified' }
PhanideEventDispatcher >> decrementChildEventClassCount: anEventClass [
	mutex critical: [
		childEventClassCounts at: anEventClass put: (childEventClassCounts at: anEventClass ifAbsent: [0]) + 1
	].
	owner ifNotNil: [ owner subscriptionRemoved ]
]

{ #category : #'dispatching events' }
PhanideEventDispatcher >> deliverChild: aChild event: anEvent [
	| childDispatcher |
	childDispatcher := mutex critical: [
		childDispatchers at: aChild ifAbsent: [ nil ]
	].

	childDispatcher ifNotNil: [ childDispatcher deliverEvent: anEvent ]
]

{ #category : #'dispatching events' }
PhanideEventDispatcher >> deliverEvent: anEvent [
	| subscriptions |
	subscriptions := mutex critical: [
		(subscriptionRegistry at: anEvent class ifAbsent: [ #() ]) asArray
	].
	subscriptions do: [ :each | each deliverEvent: anEvent ]
]

{ #category : #testing }
PhanideEventDispatcher >> hasAnySubscriptionForEventClasses: eventClasses [
	mutex critical: [ 
		eventClasses do: [ :cls |
			subscriptionRegistry at: cls ifPresent: [ :subscriptions |
				subscriptions ifNotEmpty: [ 
					^ true
				]
			].
			(childEventClassCounts at: cls ifAbsent: [ 0 ]) > 0 ifTrue: [ ^ true ]
		].
	].
	^ false
]

{ #category : #testing }
PhanideEventDispatcher >> hasSubscriptions [
	mutex critical: [ 
		subscriptionRegistry valuesDo: [ :subscriptions | subscriptions ifNotEmpty: [ ^ true ]].
		childEventClassCounts valuesDo: [ :count | count > 0 ifTrue: [ ^ true ] ].
	].
	^ false
]

{ #category : #'as yet unclassified' }
PhanideEventDispatcher >> incrementChildEventClassCount: anEventClass [
	mutex critical: [
		childEventClassCounts at: anEventClass put: (childEventClassCounts at: anEventClass ifAbsent: [0]) + 1
	]
]

{ #category : #initialization }
PhanideEventDispatcher >> initialize [
	super initialize.
	mutex := Mutex new.
	subscriptionRegistry := IdentityDictionary new.
	childDispatchers := Dictionary new.
	childEventClassCounts := IdentityDictionary new.
	parentDispatcher := WeakArray new: 1.
]

{ #category : #'as yet unclassified' }
PhanideEventDispatcher >> onChild: basename subscribeEvent: anEvent withAction: aBlock [
	^ mutex critical: [
		(childDispatchers at: basename ifAbsentPut: [
			self class new parentDispatcher: self
		]) subscribeEvent: anEvent withAction: aBlock
	]
]

{ #category : #accessing }
PhanideEventDispatcher >> owner [
	^ owner
]

{ #category : #accessing }
PhanideEventDispatcher >> owner: anObject [
	owner := anObject
]

{ #category : #initialization }
PhanideEventDispatcher >> parentDispatcher [
	^ parentDispatcher first
]

{ #category : #initialization }
PhanideEventDispatcher >> parentDispatcher: aParentDispatcher [
	parentDispatcher at: 1 put: aParentDispatcher
]

{ #category : #removing }
PhanideEventDispatcher >> removeSubscription: aSubscription [
	mutex critical: [ 
		subscriptionRegistry at: aSubscription eventClass ifPresent: [ :perClassSubscriptions |
			perClassSubscriptions remove: aSubscription ifAbsent: []
		].
		self parentDispatcher ifNotNil: [ :pd |
			pd decrementChildEventClassCount: aSubscription eventClass
		]
	].

	owner ifNotNil: [ owner subscriptionRemoved ]
]

{ #category : #'as yet unclassified' }
PhanideEventDispatcher >> subscribeEvent: anEventClass withAction: aBlock [
	^ mutex critical: [
		| perEventSubscriptions subscription |
		perEventSubscriptions := subscriptionRegistry at: anEventClass ifAbsentPut: [ IdentitySet new ].
		subscription := PhanideEventSubscription new
			dispatcher: self;
			eventClass: anEventClass;
			action: aBlock;
			yourself.
		perEventSubscriptions add: subscription.
		self parentDispatcher ifNotNil: [ :pd | parentDispatcher incrementChildEventClassCount: anEventClass ].
		subscription
	]
]
