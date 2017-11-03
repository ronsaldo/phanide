accessing
defaultStyler

	^ PhanideShoutStylerAdapter new
		view: self;
		styler: self
	