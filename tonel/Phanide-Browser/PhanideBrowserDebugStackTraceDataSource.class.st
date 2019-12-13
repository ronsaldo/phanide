Class {
	#name : #PhanideBrowserDebugStackTraceDataSource,
	#superclass : #FTSimpleDataSource,
	#category : #'Phanide-Browser-UI'
}

{ #category : #accessing }
PhanideBrowserDebugStackTraceDataSource >> addressColumn: column row: rowIndex [
	^ FTCellMorph new  
		addMorphBack: (self elementAt: rowIndex) address asStringMorph;
		yourself
]

{ #category : #accessing }
PhanideBrowserDebugStackTraceDataSource >> cellColumn: column row: rowIndex [ 
	column id = '#' ifTrue: [ ^ self levelColumn: column row: rowIndex ].
	column id = 'Function' ifTrue: [ ^ self functionColumn: column row: rowIndex ].
	column id = 'Address' ifTrue: [ ^ self addressColumn: column row: rowIndex ].
	
	self error: 'Invalid column'
]

{ #category : #accessing }
PhanideBrowserDebugStackTraceDataSource >> functionColumn: column row: rowIndex [
	^ FTCellMorph new  
		addMorphBack: (self elementAt: rowIndex) function asStringMorph;
		yourself
]

{ #category : #accessing }
PhanideBrowserDebugStackTraceDataSource >> levelColumn: column row: rowIndex [
	^ FTCellMorph new  
		addMorphBack: (self elementAt: rowIndex) level asStringMorph;
		yourself
]
