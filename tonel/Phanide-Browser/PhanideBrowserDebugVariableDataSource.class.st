Class {
	#name : #PhanideBrowserDebugVariableDataSource,
	#superclass : #FTSimpleDataSource,
	#category : #'Phanide-Browser-UI'
}

{ #category : #accessing }
PhanideBrowserDebugVariableDataSource >> cellColumn: column row: rowIndex [ 
	column id = 'Name' ifTrue: [ ^ self nameColumn: column row: rowIndex ].
	column id = 'Type' ifTrue: [ ^ self typeColumn: column row: rowIndex ].
	column id = 'Value' ifTrue: [ ^ self valueColumn: column row: rowIndex ].
	
	self error: 'Invalid column'
]

{ #category : #accessing }
PhanideBrowserDebugVariableDataSource >> nameColumn: column row: rowIndex [
	^ FTCellMorph new  
		addMorphBack: (self elementAt: rowIndex) name asStringMorph;
		yourself
]

{ #category : #accessing }
PhanideBrowserDebugVariableDataSource >> typeColumn: column row: rowIndex [
	^ FTCellMorph new  
		addMorphBack: (self elementAt: rowIndex) type asStringMorph;
		yourself
]

{ #category : #accessing }
PhanideBrowserDebugVariableDataSource >> valueColumn: column row: rowIndex [
	^ FTCellMorph new  
		addMorphBack: (self elementAt: rowIndex) value asStringMorph;
		yourself
]
