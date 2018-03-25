"
I am a data source for the file tree.
"
Class {
	#name : #PhanideFileTreeDataSource,
	#superclass : #FTTreeDataSource,
	#instVars : [
		'model'
	],
	#category : 'Phanide-Browser-UI'
}

{ #category : #accessing }
PhanideFileTreeDataSource >> cellColumn: column row: rowIndex [
	| item cell |
	item := self elementAt: rowIndex.
	cell := FTIndentedCellMorph new.
	cell indentBy: item depth * 16.
	
	cell addMorphBack: (self buttonFor: item).
	cell addMorphBack: (self iconFor: item data).
	cell addMorphBack: item data basename asMorph.
	^ cell
]

{ #category : #accessing }
PhanideFileTreeDataSource >> iconFor: fileReference [
	^ (fileReference isDirectory 
			ifTrue: [ GLMUIThemeExtraIcons glamorousFolder ] 
			ifFalse: [ GLMUIThemeExtraIcons glamorousBrowse ]) asMorph
]

{ #category : #accessing }
PhanideFileTreeDataSource >> menuColumn: column row: rowIndex [
	^ model menuForElementIndex: rowIndex
]

{ #category : #accessing }
PhanideFileTreeDataSource >> model [
	^ model
]

{ #category : #accessing }
PhanideFileTreeDataSource >> model: anObject [
	model := anObject
]
