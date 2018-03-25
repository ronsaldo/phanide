"
I am a grammar for an output record from the GDB Machine Interface.
"
Class {
	#name : #PhanideGDBOutputGrammar,
	#superclass : #PPCompositeParser,
	#instVars : [
		'outOfBandRecord',
		'resultRecord',
		'endRecord',
		'asyncRecord',
		'streamRecord',
		'recordToken',
		'resultClass',
		'results',
		'string',
		'stringCharacter',
		'variable',
		'value',
		'const',
		'tuple',
		'list',
		'cstring',
		'emptyTuple',
		'nonEmptyTuple',
		'result',
		'emptyList',
		'nonEmptyList',
		'execAsyncRecord',
		'statusAsyncRecord',
		'asyncClass',
		'consoleStreamRecord',
		'targetStreamRecord',
		'logStreamRecord',
		'notifyAsyncOutputRecord'
	],
	#category : 'Phanide-GDB-Output'
}

{ #category : #accessing }
PhanideGDBOutputGrammar >> asyncClass [
	^ string
]

{ #category : #records }
PhanideGDBOutputGrammar >> asyncRecord [
	^ execAsyncRecord / statusAsyncRecord / notifyAsyncOutputRecord
]

{ #category : #records }
PhanideGDBOutputGrammar >> consoleStreamRecord [
	^ '~' asParser , cstring
]

{ #category : #accessing }
PhanideGDBOutputGrammar >> const [
	^ cstring
]

{ #category : #accessing }
PhanideGDBOutputGrammar >> cstring [
	^ $" asParser , (($\ asParser , #any asParser) / $" asParser negate) star flatten, $" asParser
]

{ #category : #accessing }
PhanideGDBOutputGrammar >> emptyList [
	^ '[]' asParser
]

{ #category : #accessing }
PhanideGDBOutputGrammar >> emptyTuple [
	^ '{}' asParser
]

{ #category : #records }
PhanideGDBOutputGrammar >> endRecord [
	^ '(gdb)' asParser
]

{ #category : #records }
PhanideGDBOutputGrammar >> execAsyncRecord [
	^ recordToken optional , $* asParser , asyncClass , results
]

{ #category : #accessing }
PhanideGDBOutputGrammar >> list [
	^ emptyList / nonEmptyList
]

{ #category : #records }
PhanideGDBOutputGrammar >> logStreamRecord [
	^ '&' asParser , cstring
]

{ #category : #accessing }
PhanideGDBOutputGrammar >> nonEmptyList [
	^ $[ asParser , value , ($, asParser , value) star, $] asParser
]

{ #category : #accessing }
PhanideGDBOutputGrammar >> nonEmptyTuple [
	^ ${ asParser , result , ($, asParser , result) star , $}
]

{ #category : #records }
PhanideGDBOutputGrammar >> notifyAsyncOutputRecord [
	^ recordToken optional , $= asParser , asyncClass , results
]

{ #category : #records }
PhanideGDBOutputGrammar >> outOfBandRecord [
	^ asyncRecord / streamRecord
]

{ #category : #accessing }
PhanideGDBOutputGrammar >> recordToken [
	^ #digit asParser plus flatten
]

{ #category : #accessing }
PhanideGDBOutputGrammar >> result [
	^ variable , $= asParser , value
]

{ #category : #accessing }
PhanideGDBOutputGrammar >> resultClass [
	^ string
]

{ #category : #records }
PhanideGDBOutputGrammar >> resultRecord [
	^ recordToken optional , '^' asParser , resultClass, results
]

{ #category : #accessing }
PhanideGDBOutputGrammar >> results [
	^ ($, asParser , result) star
]

{ #category : #accessing }
PhanideGDBOutputGrammar >> start [
	^ outOfBandRecord / resultRecord / endRecord
]

{ #category : #records }
PhanideGDBOutputGrammar >> statusAsyncRecord [
	^ recordToken optional , $+ asParser , asyncClass , results
]

{ #category : #records }
PhanideGDBOutputGrammar >> streamRecord [
	^ consoleStreamRecord / targetStreamRecord / logStreamRecord
]

{ #category : #accessing }
PhanideGDBOutputGrammar >> string [
	^ stringCharacter plus flatten
]

{ #category : #accessing }
PhanideGDBOutputGrammar >> stringCharacter [
	^ #letter asParser / #digit asParser / $_ asParser / $- asParser
]

{ #category : #records }
PhanideGDBOutputGrammar >> targetStreamRecord [
	^ '@' asParser , cstring
]

{ #category : #accessing }
PhanideGDBOutputGrammar >> tuple [
	^ emptyTuple / nonEmptyTuple
]

{ #category : #accessing }
PhanideGDBOutputGrammar >> value [
	^ const / tuple / list
]

{ #category : #accessing }
PhanideGDBOutputGrammar >> variable [
	^ string
]
