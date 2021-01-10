Extension { #name : #String }

{ #category : #'*Phanide-Browser' }
String >> browseDirectoryInExternalWindow [
	^ (PhanideBrowserModel newWithDirectory: self) openExternalWindowWithSpec 
]
