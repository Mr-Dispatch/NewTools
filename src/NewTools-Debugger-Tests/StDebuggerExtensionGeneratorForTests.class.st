"
I just provide helper methods to generate and remove classes that use the `TStDebuggerExtension` trait.
These classes are used exclusively in tests, and should be part of the system (remove them in your `tearDown`).
"
Class {
	#name : #StDebuggerExtensionGeneratorForTests,
	#superclass : #Object,
	#category : #'NewTools-Debugger-Tests-Utils'
}

{ #category : #running }
StDebuggerExtensionGeneratorForTests class >> generateTestClass [

	SpPresenter
		subclass: #TStDebuggerExtensionTestClass
		uses: TStDebuggerExtension
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'NewTools-Debugger-Tests-Model'.
	Smalltalk compiler
		class: (Smalltalk at: #TStDebuggerExtensionTestClass) class;
		source: 'defaultLayout ^ SpBoxLayout newVertical';
		compile
]

{ #category : #running }
StDebuggerExtensionGeneratorForTests class >> removeTestClass [

	Smalltalk
		at: #TStDebuggerExtensionTestClass
		ifPresent: [ :class | class removeFromSystem ]
]

{ #category : #running }
StDebuggerExtensionGeneratorForTests class >> testClass [

	^ Smalltalk at: #TStDebuggerExtensionTestClass
]
