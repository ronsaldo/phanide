"
I represent an out of band gdb output record. I can be generated asynchronously.
"
Class {
	#name : #PhanideGDBOutOfBandRecord,
	#superclass : #PhanideGDBOutputRecord,
	#category : 'Phanide-GDB-Output'
}

{ #category : #testing }
PhanideGDBOutOfBandRecord >> isOutOfBandRecord [
	^ true
]
