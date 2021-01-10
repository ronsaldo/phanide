Extension { #name : #String }

{ #category : #'*Phanide-ProjectModel' }
String >> browseDirectory [
	^ (PhideProject forDirectory: self) openBrowser
]
