initialization
metaCharacter: aChar
	MetaCharacters ifNil: [ self initialize ].
	^ MetaCharacters at: aChar
