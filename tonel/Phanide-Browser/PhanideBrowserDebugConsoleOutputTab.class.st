Class {
	#name : #PhanideBrowserDebugConsoleOutputTab,
	#superclass : #PhanideBrowserConsoleOutputTab,
	#category : #'Phanide-Browser-UI'
}

{ #category : #accessing }
PhanideBrowserDebugConsoleOutputTab >> defaultLabel [
	^ 'Debugger Console Output'
]

{ #category : #accessing }
PhanideBrowserDebugConsoleOutputTab >> defaultName [
	^ #DebugConsoleOutput
]

{ #category : #'as yet unclassified' }
PhanideBrowserDebugConsoleOutputTab >> installLocation [
	^ #rightBottomTabs
]
