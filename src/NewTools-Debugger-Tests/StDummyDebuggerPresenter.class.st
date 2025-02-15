"
I am a dummy debugger presenter for tests.
I'm used in tests to easily ensure that commands or other clients call the correct interface on their debugger object.
The debugger interface itself is tested in the debugger test class.
"
Class {
	#name : #StDummyDebuggerPresenter,
	#superclass : #SpPresenter,
	#traits : 'TStDebuggerExtension',
	#classTraits : 'TStDebuggerExtension classTrait',
	#instVars : [
		'tag'
	],
	#category : #'NewTools-Debugger-Tests-Utils'
}

{ #category : #testing }
StDummyDebuggerPresenter class >> isOnlyForTests [

	^ true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> copyStackToClipboard [
tag := thisContext method selector.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> createMissingClass [
tag := thisContext method selector.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> createMissingMethod [
tag := thisContext method selector.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> createSubclassResponsibility [
tag := thisContext method selector.
^true
]

{ #category : #'accessing - context' }
StDummyDebuggerPresenter >> currentContext [
	^self
]

{ #category : #accessing }
StDummyDebuggerPresenter >> debuggerExtensionToolName [
	^'Test extendedDebuggingToolTitle'
	
]

{ #category : #layout }
StDummyDebuggerPresenter >> defaultLayout [

	^ SpBoxLayout newVertical 
]

{ #category : #mocks }
StDummyDebuggerPresenter >> fileOutSelectedContext [
tag := thisContext method selector.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> peelToFirstLike: aStDummyDebuggerPresenter [

	tag := thisContext method selector.
	^ true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> proceedDebugSession [
tag := thisContext method selector.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> restartCurrentContext [
tag := thisContext method selector.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> returnEnteredValue [
tag := thisContext method selector.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> runToSelection [
tag := thisContext method selector.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> selectNextExecutedExpression [
tag := thisContext method selector.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> showFullStack [
tag := thisContext method selector.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> stepInto [
tag := thisContext method selector.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> stepOver [
tag := thisContext method selector.
^true
]

{ #category : #mocks }
StDummyDebuggerPresenter >> stepThrough [
tag := thisContext method selector.
^true
]

{ #category : #accessing }
StDummyDebuggerPresenter >> tag [
	^ tag
]

{ #category : #mocks }
StDummyDebuggerPresenter >> unimplementedSubclassResponsibility [
	self subclassResponsibility 
]
