"
A PhideProjectTest is a test class for testing the behavior of PhideProject
"
Class {
	#name : #PhideProjectTest,
	#superclass : #TestCase,
	#category : #'Phanide-ProjectModel-Tests'
}

{ #category : #tests }
PhideProjectTest >> testAddElement [
	| project group |
	project := PhideProject new.
	self assert: project isEmpty.
	
	group := PhideProjectGroup new name: 'TestGroup'.
	project addTopLevelElement: group.
	self assert: project isEmpty not.
	self assert: (project topLevelElements includes: group).

]

{ #category : #tests }
PhideProjectTest >> testNew [
	| project |
	project := PhideProject new.
	self assert: project topLevelElements isEmpty.
	self assert: project isEmpty.
]
