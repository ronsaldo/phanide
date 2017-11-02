specs
defaultSpec
	^ SpecLayout composed
		newRow: [ :centerRow |
			centerRow
				newColumn: [ :column  |
					column add: #leftTabs
				] left: 0.0 right: 0.75;
				addSplitter;
				newColumn: [ :column |
					column
						newRow: [:row | row add: #mainTabs] top: 0.0 bottom: 0.25;
						addSplitter;
						newRow: [:row | row add: #bottomTabs] top: 0.75 bottom: 0.0
				] left: 0.0 right: 0.25
		];
		yourself