Extension { #name : #AbstractFileReference }

{ #category : #'*Phanide-ProjectModel' }
AbstractFileReference >> asPhanideProjectElement [
	self isDirectory ifTrue: [ ^ PhideProjectDirectory for: self ].
	self isFile ifTrue: [ ^ PhideProjectFileReference for: self ].
	^ nil
]
