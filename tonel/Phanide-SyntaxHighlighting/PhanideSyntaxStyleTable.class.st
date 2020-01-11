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
		'CurrentLightStyleTable',
		'CurrentStyleTable'
	],
	#category : #'Phanide-SyntaxHighlighting-Style'
}

{ #category : #accessing }
PhanideSyntaxStyleTable class >> current [
	^ CurrentStyleTable ifNil: [ CurrentStyleTable := self parse: self findCurrentStyleTable ]
]

{ #category : #accessing }
PhanideSyntaxStyleTable class >> currentLightTheme [
	^ CurrentLightStyleTable ifNil: [ CurrentLightStyleTable := self parse: self lightStyleTableDefinition ]
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

	^ self styleTableDefinitionFromEclipseTheme: #(
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
	)

]

{ #category : #'style tables' }
PhanideSyntaxStyleTable class >> defaultStyleTableDefinition [
	^ UITheme current phanideStyleTableDefinition
]

{ #category : #'as yet unclassified' }
PhanideSyntaxStyleTable class >> findCurrentStyleTable [
	^ self defaultStyleTableDefinition
]

{ #category : #'as yet unclassified' }
PhanideSyntaxStyleTable class >> lightStyleTableDefinition [
	^ self mrStyleTableDefinition
]

{ #category : #'style tables' }
PhanideSyntaxStyleTable class >> mrStyleTableDefinition [
	"
	This style is converted from the Mr. theme from Eclipse: http://www.eclipsecolorthemes.org/?view=theme&id=32.  
	"
	<styleTable: 'Mr'>

	^ self styleTableDefinitionFromEclipseTheme: #(
			(searchResultIndication 'D8D8D8')
			(filteredSearchResultIndication 'D8D8D8')
			(occurrenceIndication '000000')
			(writeOccurrenceIndication '000000')
			(sourceHoverBackground 'D8D8D8')
			(singleLineComment 'FF9900')
			(multiLineComment 'FF9900')
			(commentTaskTag 'FF3300')
			(javadoc 'FF3300')
			(javadocLink '990099')
			(javadocTag '990099')
			(javadocKeyword '990099')
			(class '006600')
			(interface '666666')
			(method '000099')
			(methodDeclaration '000099')
			(bracket '000099')
			(number '0000FF')
			(string 'CC0000')
			(operator '0000FF')
			(keyword '0000FF')
			(annotation '990000')
			(staticMethod '990000')
			(localVariable '0066FF')
			(localVariableDeclaration '000099')
			(field '000099')
			(staticField '552200')
			(staticFinalField '552200')
			(deprecatedMember 'D8D8D8')
			(enum 'FF0000')
			(inheritedMethod '000099')
			(abstractMethod '000099')
			(parameterVariable '0000FF')
			(typeArgument '0000FF')
			(typeParameter '006600')
			(constant '552200')
			(background 'FFFFFF')
			(currentLine 'D8D8D8')
			(foreground '333333')
			(lineNumber 'D8D8D8')
			(selectionBackground 'D8D8D8')
			(selectionForeground '333333')
	)

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
	<script>
	CurrentStyleTable := nil.
	CurrentLightStyleTable := nil.
	
]

{ #category : #parsing }
PhanideSyntaxStyleTable class >> styleTableDefinitionFromEclipseTheme: nameAndColorArray [
	| nameAndColorDictionary |
	nameAndColorDictionary := Dictionary newFrom: (nameAndColorArray collect: [:pair | pair first -> pair second]).
	^ nameAndColorArray , {
		{ #type. nameAndColorDictionary at: #keyword }.
		{ #preprocessor. nameAndColorDictionary at: #annotation }.
		{ #module. nameAndColorDictionary at: #interface }.
		{ #struct. nameAndColorDictionary at: #class }.
		{ #patternDontCare. nameAndColorDictionary at: #foreground }.
		{ #identifier. nameAndColorDictionary at: #foreground }.
		{ #symbol. nameAndColorDictionary at: #string . #bold}.
		{ #callBracket. nameAndColorDictionary at: #bracket }.
		{ #methodBracket. nameAndColorDictionary at: #bracket }.
		{ #methodHeaderSelector. nameAndColorDictionary at: #methodDeclaration. #bold }.
		{ #localDefinition. nameAndColorDictionary at: #constant }.
		{ #bar. nameAndColorDictionary at: #methodDeclaration }.
	}
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
