Class {
	#name : #PhanideBrowserDebugStackTrace,
	#superclass : #PhanideBrowserComponent,
	#traits : 'TPhanideBrowserMorphComponent',
	#classTraits : 'TPhanideBrowserMorphComponent classTrait',
	#instVars : [
		'dataSource'
	],
	#category : #'Phanide-Browser-UI'
}

{ #category : #testing }
PhanideBrowserDebugStackTrace class >> isPermanentComponent [
	^ true
]

{ #category : #initialization }
PhanideBrowserDebugStackTrace >> createMorph [
	dataSource := PhanideBrowserDebugStackTraceDataSource new.
	^ FTTableMorph new
		addColumn: ((FTColumn id: '#') width: 30);
		addColumn: ((FTColumn id: 'Address') width: 150);
		addColumn: (FTColumn id: 'Function');
		intercellSpacing: 1;
		dataSource: dataSource;
		yourself
]

{ #category : #accessing }
PhanideBrowserDebugStackTrace >> defaultLabel [
	^ 'Stack trace'
]

{ #category : #accessing }
PhanideBrowserDebugStackTrace >> defaultName [
	^ #DebugStackTrace
]

{ #category : #'as yet unclassified' }
PhanideBrowserDebugStackTrace >> installLocation [
	^ #rightMiddleTabs
]

{ #category : #notifications }
PhanideBrowserDebugStackTrace >> notifyDebugStopWithReason: reason atFrame: stackFrame [
	self updateStackTrace
]

{ #category : #'as yet unclassified' }
PhanideBrowserDebugStackTrace >> updateStackTrace [
	dataSource
		elements: self debuggerState getStackTrace;
		tableRefresh
]
