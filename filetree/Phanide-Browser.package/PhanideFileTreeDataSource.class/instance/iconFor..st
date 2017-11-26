accessing
iconFor: fileReference
	^ (fileReference isDirectory 
			ifTrue: [ GLMUIThemeExtraIcons glamorousFolder ] 
			ifFalse: [ GLMUIThemeExtraIcons glamorousBrowse ]) asMorph