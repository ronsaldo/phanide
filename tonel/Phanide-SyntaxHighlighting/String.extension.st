Extension { #name : #String }

{ #category : #'*Phanide-SyntaxHighlighting' }
String >> asPhanideRegex [
	^ (PhanideRegexParser parse: self) simplified
]
