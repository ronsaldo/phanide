records
consoleStreamRecord
	^ super consoleStreamRecord ==> [ :tok | PhanideGDBConsoleStreamRecord new value: tok second ]