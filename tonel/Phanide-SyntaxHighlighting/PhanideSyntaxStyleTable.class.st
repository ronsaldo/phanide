"
I represent a style table. I am used for doing syntax highlighting.
"
Class {
	#name : #PhanideSyntaxStyleTable,
	#superclass : #Object,
	#instVars : [
		'styles'
	],
	#classVars : [
		'CurrentStyleTable'
	],
	#category : 'Phanide-SyntaxHighlighting-Style'
}

{ #category : #accessing }
PhanideSyntaxStyleTable class >> current [
	^ CurrentStyleTable ifNil: [ CurrentStyleTable := self parse: self findCurrentStyleTable ]
]

{ #category : #'style tables' }
PhanideSyntaxStyleTable class >> darkStyleTableDefinition [
	"color can be a valid argument to Color class>>colorFrom: , or nil to
	use the editor text color.
	Multiple emphases can be specified using an array e.g. #(bold italic).
	If emphasis is not specified, #normal will be used.
	if pixel height is not specified , then the editor font size will be used.
	
	This style is base on darkula theme from eclipse: http://eclipsecolorthemes.org/?view=theme&id=15515.  
	"
	<styleTable: 'Dark'>

	^ #(
			(searchResultIndication '616161')
			(filteredSearchResultIndication '616161')
			(occurrenceIndication '616161')
			(writeOccurrenceIndication '616161')
			(findScope 'E0E2E4')
			(deletionIndication 'E0E2E4')
			(sourceHoverBackground 'FFFFFF')
			(singleLineComment '7D8C93')
			(multiLineComment '7D8C93')
			(commentTaskTag 'FF8BFF')
			(javadoc '7D8C93')
			(javadocLink '678CB1')
			(javadocTag '006666')
			(javadocKeyword 'A082BD')
			(class '0080FF')
			(interface '3B94ED')
			(method '7EE7FA')
			(methodDeclaration 'A3D2FF')
			(bracket 'E8E2B7')
			(number 'FFE54B')
			(string 'E38C1E')
			(operator 'FAF0AC')
			(keyword '00CC6E')
			(annotation 'B4DD6E')
			(staticMethod 'B4A6FF')
			(localVariable 'A7E2ED')
			(localVariableDeclaration 'A7E2ED')
			(field '678CB1')
			(staticField 'BDA9F5')
			(staticFinalField 'BDA9F5')
			(deprecatedMember 'E0E2E4')
			(enum '0080FF')
			(inheritedMethod '7EE7FA')
			(abstractMethod '7EE7FA')
			(parameterVariable 'E0E2E4')
			(typeArgument 'E0E2E4')
			(typeParameter 'E0E2E4')
			(constant 'A082BD')
			(background '1E1E23')
			(currentLine '2F393C')
			(foreground 'EEEEEE')
			(lineNumber '81969A')
			(selectionBackground '804000')
			(selectionForeground 'E0E2E4')
			
			(type '00CC6E') "keyword"
			(preprocessor 'B4DD6E') "annotation"
			
			(identifier '0080FF')
			(symbol 'E38C1E') 
			(callBracket 'FFE54B')
			(methodBracket '7EE7FA')
			(methodHeaderSelector white bold)
			(localDefinition 'A7E2ED')
			(bar white)
	)

]

{ #category : #'style tables' }
PhanideSyntaxStyleTable class >> defaultStyleTableDefinition [
	^ self darkStyleTableDefinition
]

{ #category : #'as yet unclassified' }
PhanideSyntaxStyleTable class >> findCurrentStyleTable [
	^ self defaultStyleTableDefinition
]

{ #category : #compiling }
PhanideSyntaxStyleTable class >> noteCompilationOf: aSelector meta: isMeta [
	isMeta ifTrue: [
		self class methodDict at: aSelector ifPresent: [:cm |
			(cm hasPragmaNamed: #styleTable:) ifTrue: [
				self reset
			]
		]
	]
]

{ #category : #parsing }
PhanideSyntaxStyleTable class >> parse: aStyleTableDefinition [
	^ self new parse: aStyleTableDefinition
]

{ #category : #accessing }
PhanideSyntaxStyleTable class >> reset [
	CurrentStyleTable := nil
]

{ #category : #'as yet unclassified' }
PhanideSyntaxStyleTable >> applyStyle: styleName on: text from: start to: stop [
	| style |
	style := styles at: styleName ifAbsent: [ ^ self ].
	style applyOn: text from: start to: stop
]

{ #category : #'as yet unclassified' }
PhanideSyntaxStyleTable >> attributesForStyle: styleName [
	^ styles at: styleName ifPresent: [:style | style attributes ] ifAbsent: [ #() ].
]

{ #category : #parsing }
PhanideSyntaxStyleTable >> parse: aStyleTableDefinition [
	styles := Dictionary new.
	aStyleTableDefinition do: [ :styleDefinition | self parseStyleDefinition: styleDefinition ]
]

{ #category : #parsing }
PhanideSyntaxStyleTable >> parseStyleDefinition: styleDefinition [
	| style color parsedAttributes emphasis |
	style := PhanideSyntaxStyle new.
	style name: styleDefinition first.
	styles at: style name put: style.
	
	color := Color colorFrom: styleDefinition second. 
	parsedAttributes := {TextColor color: color}.
	styleDefinition size >= 3 ifTrue: [
		emphasis := styleDefinition third.
		parsedAttributes := parsedAttributes , { TextEmphasis perform: emphasis }
	].

	style textAttributes: parsedAttributes.
]

{ #category : #'as yet unclassified' }
PhanideSyntaxStyleTable >> textAttributesForStyle: styleName [
	^ styles at: styleName ifPresent: [:style | style textAttributes ] ifAbsent: [ #() ].
]
