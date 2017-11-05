accessing
anyMetaCharacter
	^ super anyMetaCharacter ==> [ :c |
		PhanideNFA metaCharacter: c
	]