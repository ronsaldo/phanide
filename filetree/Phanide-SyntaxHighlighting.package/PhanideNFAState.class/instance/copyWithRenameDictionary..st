copying
copyWithRenameDictionary: renameDictionary
	| result |
	result := self class new.
	result transitions: (transitions collect: [ :t | t copyWithRenameDictionary: renameDictionary ] ).
	^ result