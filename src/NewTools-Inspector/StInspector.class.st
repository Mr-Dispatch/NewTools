"
I am an inspector of objects. 
I offer multiple views using a miller list as a navigation. 
One particular feature is that you can use the evaluator tab to enter code, and evaluating it results in opening another pane to the right.

The object finder asks dynamically the object for the actual presentations that are displayed in each pane.

Example:
self openOn: Smalltalk.

Register it as a replacement for inspector:
self registerToolsOn: Smalltalk tools.
"
Class {
	#name : #StInspector,
	#superclass : #StPresenter,
	#instVars : [
		'millerList',
		'model',
		'lastPageSelectedTabName',
		'withHeaderBar'
	],
	#classVars : [
		'IndexableDisplayLimit',
		'InspectorDiveOnSingleClick'
	],
	#classInstVars : [
		'preferredExtent'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #settings }
StInspector class >> defaultInspectorDiveOnSingleClick [

	^ true
]

{ #category : #layout }
StInspector class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: #millerList;
		yourself
]

{ #category : #accessing }
StInspector class >> defaultPreferredExtent [

	^ 700@500
]

{ #category : #accessing }
StInspector class >> defaultSpacing [

	^ 3
]

{ #category : #'instance creation' }
StInspector class >> explore: anObject [
 
	self openOn: anObject.
	^ anObject
]

{ #category : #settings }
StInspector class >> indexableDisplayLimit [

	^ IndexableDisplayLimit ifNil: [ 5000 ]
]

{ #category : #settings }
StInspector class >> indexableDisplayLimit: aNumber [

	IndexableDisplayLimit := aNumber
]

{ #category : #'class initialization' }
StInspector class >> initialize [

	self register
]

{ #category : #'instance creation' }
StInspector class >> inspect: anObject [

	^ self openOn: anObject
]

{ #category : #'instance creation' }
StInspector class >> inspect: anObject label: aString [

	(self openOn: anObject) title: aString.
	^ anObject

]

{ #category : #'instance creation' }
StInspector class >> inspector: anObject [
	
	self 
		deprecated: 'Use #inspect: instead.'
		transformWith: '`@receiver inspector: `@statements1'
				-> '`@receiver inspect: `@statements1'.

	^ self openOn: anObject
]

{ #category : #settings }
StInspector class >> inspectorDiveOnSingleClick [

	^ InspectorDiveOnSingleClick ifNil: [
		InspectorDiveOnSingleClick := self defaultInspectorDiveOnSingleClick ]
]

{ #category : #settings }
StInspector class >> inspectorDiveOnSingleClick: aBoolean [

	InspectorDiveOnSingleClick := aBoolean
]

{ #category : #'instance creation' }
StInspector class >> onObject: anObject [

	^ self on: (StInspectorModel on: anObject)
]

{ #category : #'instance creation' }
StInspector class >> openOn: anObject [

	^ (self onObject: anObject) open
]

{ #category : #accessing }
StInspector class >> preferredExtent [
	
	^ preferredExtent ifNil: [ preferredExtent := self defaultPreferredExtent ]
]

{ #category : #accessing }
StInspector class >> preferredExtent: aPoint [
	
	preferredExtent := aPoint
]

{ #category : #'tools registry' }
StInspector class >> register [
	<script>

	self registerToolsOn: Smalltalk tools
]

{ #category : #'tools registry' }
StInspector class >> registerToolsOn: registry [
	"self registerToolsOn: Smalltalk tools " 
	registry register: self as: #inspector.
	registry register: self as: #basicInspector
]

{ #category : #settings }
StInspector class >> settingsOn: aBuilder [
	<systemsettings>

	(aBuilder group: #inspector)
		parent: #tools;
		label: 'Inspector';
		description: 'Inspector'.
		
	(aBuilder setting: #inspectorDiveOnSingleClick)
		parent: #inspector;
		default: self inspectorDiveOnSingleClick;
		target: self;
		description: 'Whether inspector will dive with single or double click';
		label: 'Dive on single click'
]

{ #category : #transmission }
StInspector >> defaultInputPort [

	^ self inputModelPort
]

{ #category : #'api - focus' }
StInspector >> defaultKeyboardFocus [

	^ millerList presenters 
		ifNotEmpty: [ :list | list first ] 
		ifEmpty: [ self ]
]

{ #category : #accessing }
StInspector >> firstPage [

	^ millerList pages first
]

{ #category : #initialization }
StInspector >> initializePresenters [

	millerList := self instantiate: SpMillerPaginatorPresenter.
	millerList millerListPresenter
		spacing: self spacing;
		presenterBlock: [ :aModel | self newInspectorFor: aModel ];
		setRootModel: self model;
		whenColumnsWillChangeDo: [ self keepLastPageSelectedTabName ]
]

{ #category : #initialization }
StInspector >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self windowTitle;
		windowIcon: self windowIcon;
		initialExtent: self class preferredExtent;
		whenOpenedDo: [ self takeKeyboardFocus ];
		whenFocusReceivedDo: [ self startProcessing ];
		whenFocusLostDo: [ self stopProcessing ];
		whenClosedDo: [ self stopProcessing ];
		whenResizingDo: [ :ann | self preferredExtent: ann newSize ]
]

{ #category : #transmission }
StInspector >> inputModelPort [

	^ SpModelPort newPresenter: self
]

{ #category : #private }
StInspector >> keepLastPageSelectedTabName [
	
	lastPageSelectedTabName := millerList pages 
		ifNotEmpty: [ :pages | pages last selectedPageName ]
		ifEmpty: [ nil ]
]

{ #category : #accessing }
StInspector >> millerList [

	^ millerList
]

{ #category : #accessing }
StInspector >> model [

	^ model
]

{ #category : #'accessing - model' }
StInspector >> model: anInspectorModel [

	model := anInspectorModel.
	self updateTitle.
	self updateList
]

{ #category : #'private - factory' }
StInspector >> newInspectorFor: aModel [
	| newInspector |

	newInspector := self
		instantiate: aModel defaultObjectInspectorClass
		on: aModel asInspectorModel.
	self class inspectorDiveOnSingleClick 
		ifTrue: [ newInspector activateOnSingleClick ].
	
	millerList pages ifNotEmpty: [ :pages | 
		newInspector 
			"prepare to close"
			whenClosedDo: [ millerList removeAllFrom: newInspector  ];
			"select last shown page (or default)"
			trySelectAnyPageWithName: { 
				lastPageSelectedTabName. 
				pages last selectedPageName } ].
		
	^ newInspector
]

{ #category : #private }
StInspector >> preferredExtent: aSize [

	(self window isMaximized 
		or: [ self window isMinimized ])
		ifTrue: [ ^ self ].
	self class preferredExtent: aSize
]

{ #category : #private }
StInspector >> setModel: aModel [

	self model: aModel
]

{ #category : #'accessing - model' }
StInspector >> setModelBeforeInitialization: anInspectorModel [

	model := anInspectorModel
]

{ #category : #accessing }
StInspector >> spacing [
	
	^ self class defaultSpacing
]

{ #category : #'private - stepping' }
StInspector >> startProcessing [

	StInspectorRefreshService uniqueInstance register: self
]

{ #category : #'private - stepping' }
StInspector >> step [ 

	millerList pages
		do: [ :each | each step ]
]

{ #category : #'private - stepping' }
StInspector >> stopProcessing [

	StInspectorRefreshService uniqueInstance unregister: self
]

{ #category : #'private - updating' }
StInspector >> updateList [

	millerList millerListPresenter
		resetTo: 0;
		setRootModel: self model
]

{ #category : #'private - updating' }
StInspector >> updateTitle [
		
	self isRoot ifFalse: [ ^ self ].
	self withWindowDo: [ :window | 
		window title: self title ].
]

{ #category : #initialization }
StInspector >> windowIcon [
	
	^ self application iconNamed: #smallInspectIt
]

{ #category : #initialization }
StInspector >> windowTitle [

	^ self model windowTitle
]

{ #category : #accessing }
StInspector >> withHeaderBar [
	 ^withHeaderBar ifNil: [ withHeaderBar := true ]
]

{ #category : #accessing }
StInspector >> withHeaderBar: bool [
	withHeaderBar := bool
]
