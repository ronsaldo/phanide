Extension { #name : #AbstractFileReference }

{ #category : #'*Phanide-Browser' }
AbstractFileReference >> browseDirectory [
	^ (PhanideBrowserModel newWithDirectory: self) openWithSpec
]

{ #category : #'*Phanide-Browser' }
AbstractFileReference >> browseDirectoryInExternalWindow [
	^ (PhanideBrowserModel newWithDirectory: self) openExternalWindowWithSpec 
]
