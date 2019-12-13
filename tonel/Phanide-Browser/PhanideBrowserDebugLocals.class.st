Class {
	#name : #PhanideBrowserDebugLocals,
	#superclass : #PhanideBrowserComponent,
	#traits : 'TPhanideBrowserMorphComponent',
	#classTraits : 'TPhanideBrowserMorphComponent classTrait',
	#instVars : [
		'dataSource'
	],
	#category : #'Phanide-Browser-UI'
}

{ #category : #testing }
PhanideBrowserDebugLocals class >> isPermanentComponent [
	^ true
]

{ #category : #initialization }
PhanideBrowserDebugLocals >> createMorph [
	dataSource := PhanideBrowserDebugVariableDataSource new.
	^ FTTableMorph new
		addColumn: ((FTColumn id: 'Name') width: 100);
		addColumn: ((FTColumn id: 'Type') width: 100);
		addColumn: (FTColumn id: 'Value');
		intercellSpacing: 1;
		dataSource: dataSource;
		yourself
]

{ #category : #notifications }
PhanideBrowserDebugLocals >> debuggerFinished [
	self updateLocals
]

{ #category : #accessing }
PhanideBrowserDebugLocals >> defaultLabel [
	^ 'Locals'
]

{ #category : #accessing }
PhanideBrowserDebugLocals >> defaultName [
	^ #DebugLocals
]

{ #category : #initialization }
PhanideBrowserDebugLocals >> initializePresenter [
	morph onAnnouncement: FTStrongSelectionChanged do: [ :ann |
		self onDoubleClick: ann selectedRowIndex
	].
]

{ #category : #'as yet unclassified' }
PhanideBrowserDebugLocals >> installLocation [
	^ #rightTopTabs
]

{ #category : #'as yet unclassified' }
PhanideBrowserDebugLocals >> notifyDebugProgramIsRunning [
	dataSource elements: #(); tableRefresh
]

{ #category : #notifications }
PhanideBrowserDebugLocals >> notifyDebugStackFrameChanged [
	self updateLocals
]

{ #category : #initialization }
PhanideBrowserDebugLocals >> onDoubleClick: selectedElement [
	(morph dataSource elementAt: selectedElement) inspect
]

{ #category : #notifications }
PhanideBrowserDebugLocals >> updateLocals [
	dataSource
		elements: self debuggerState getLocals;
		tableRefresh
]
