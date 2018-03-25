Extension { #name : #TabMorph }

{ #category : #'*Phanide-Browser' }
TabMorph >> mouseDown: event [

	self flag: 'ToDo: Add drag'.
	^ super mouseDown: event
]

{ #category : #'*Phanide-Browser' }
TabMorph >> mouseUp: event [

	(event commandKeyPressed or: [ event controlKeyPressed ])
		ifTrue: [ self toggleSelection ]
		ifFalse: [ 
			event shiftPressed
				ifTrue: [ self selectToMe ]
				ifFalse: [ self selected: true ] ].
	^ super mouseUp: event
]
