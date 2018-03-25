Extension { #name : #String }

{ #category : #'*Phanide-Browser' }
String >> browseDirectory [
	^ (PhanideBrowserModel newWithDirectory: self) openWithSpec
]

{ #category : #'*Phanide-Browser' }
String >> browseDirectoryInExternalWindow [
	^ (PhanideBrowserModel newWithDirectory: self) openExternalWindowWithSpec 
]
