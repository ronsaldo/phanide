Extension { #name : #AbstractFileReference }

{ #category : #'*Phanide-ProjectBrowser' }
AbstractFileReference >> browseDirectory [
	^ (PhideProject forDirectory: self) openBrowser
]
