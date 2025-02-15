"
I am a dummy object to test StDebuggerContext inspector nodes building.
"
Class {
	#name : #StDebuggerObjectForTests,
	#superclass : #Object,
	#instVars : [
		'instVar'
	],
	#category : #'NewTools-Debugger-Tests-Utils'
}

{ #category : #util }
StDebuggerObjectForTests >> haltingMethod [ <haltOrBreakpointForTesting> self halt. ^self
]

{ #category : #initialization }
StDebuggerObjectForTests >> initialize [ 
	instVar := 0
]

{ #category : #accessing }
StDebuggerObjectForTests >> instVar [
	^ instVar
]

{ #category : #utilities }
StDebuggerObjectForTests >> methodWithArg1: i arg2: j [
	|a b|
	a := i.
	b := j.	
	^a + b
]

{ #category : #utilities }
StDebuggerObjectForTests >> methodWithArgsInBlock [
	^[ :a :b| a + b ] value: 4 value: 2
]

{ #category : #utilities }
StDebuggerObjectForTests >> methodWithTemps [
	|a b|
	a := 0.
	b := 0.
	^a + b
]
