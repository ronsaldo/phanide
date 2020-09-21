Extension { #name : #PhideProjectFileReference }

{ #category : #'*Phanide-ProjectBrowser' }
PhideProjectFileReference >> openEditorOn: aProjectBrowser [
	aProjectBrowser openFileEditorFor: self
]

{ #category : #'*Phanide-ProjectBrowser' }
PhideProjectFileReference >> openTemporaryEditorOn: aProjectBrowser [
	aProjectBrowser openFileTemporaryEditorFor: self
]
