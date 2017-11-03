as yet unclassified
styleText: aText onError: aBlock
	| result |
	result := nil.
	[
		result := self styleText: aText
	] on: Error do: aBlock.
	^ result