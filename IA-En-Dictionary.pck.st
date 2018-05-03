'From Cuis 5.0 of 7 November 2016 [latest update: #3293] on 3 May 2018 at 5:27:30 pm'!
'Description Enter a word in English and find... '!
!provides: 'IA-En-Dictionary' 1 8!
!requires: 'Morphic-Widgets-Extras' 1 15 nil!
SystemOrganization addCategory: #'IA-En-Dictionary'!


!classDefinition: #IEDictWindow category: #'IA-En-Dictionary'!
SystemWindow subclass: #IEDictWindow
	instanceVariableNames: 'entry TextMorph resultMorph promptMorph entryTextMorph'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IA-En-Dictionary'!
!classDefinition: 'IEDictWindow class' category: #'IA-En-Dictionary'!
IEDictWindow class
	instanceVariableNames: 'resultMorph promptMorph entryTextMorph model'!

!classDefinition: #IEDict category: #'IA-En-Dictionary'!
Object subclass: #IEDict
	instanceVariableNames: 'searchString searchResult resultIndex'
	classVariableNames: 'DictData'
	poolDictionaries: ''
	category: 'IA-En-Dictionary'!
!classDefinition: 'IEDict class' category: #'IA-En-Dictionary'!
IEDict class
	instanceVariableNames: ''!


!IEDictWindow commentStamp: '<historical>' prior: 0!
GUI

IEDictWindow open!

!IEDict commentStamp: '<historical>' prior: 0!
Gui for Lookup

IEDictWindow open!

!IEDictWindow methodsFor: 'geometry' stamp: 'ebi 5/3/2018 13:36:17'!
defaultSeparation
	"Answer the number of pixels between fields/layouts"
	
	^ 5 "pixels"! !

!IEDictWindow methodsFor: 'geometry' stamp: 'ebi 5/3/2018 13:36:33'!
textSizeUnit
	"Answer the scaling factor for sizing; note  method #fontPreferenceChanged"

	^ AbstractFont default height! !

!IEDictWindow methodsFor: 'accessing' stamp: 'ebi 5/3/2018 17:10:49'!
entryTextMorph
	^entryTextMorph! !

!IEDictWindow methodsFor: 'accessing' stamp: 'ebi 5/3/2018 17:11:44'!
promptMorph
	^ promptMorph ! !

!IEDictWindow methodsFor: 'accessing' stamp: 'ebi 5/3/2018 17:12:05'!
resultMorph
	^ resultMorph! !

!IEDictWindow methodsFor: 'accessing' stamp: 'ebi 5/3/2018 17:12:31'!
searchString

	^ entryTextMorph contents asString ! !

!IEDictWindow methodsFor: 'GUI building' stamp: 'ebi 5/3/2018 17:22:21'!
buildMorphicWindow
	"build and layout the window and answer it"
	self layoutMorph
		beColumn; "default"
		separation: self defaultSeparation;
		layoutSpec: LayoutSpec useAll;
		addMorph: self makeEntryArea;
		addMorph: self makeButtonArea;
		addMorph: self makeResultsArea.
	model when: #newSearchResult send: #searchResultsChanged to: self.
	model interlinguaContainsClick ."set initial text"
	
	^self! !

!IEDictWindow methodsFor: 'GUI building' stamp: 'ebi 5/3/2018 13:29:24'!
englishContainsClick

	self model searchString: self searchString; englishContainsClick
! !

!IEDictWindow methodsFor: 'GUI building' stamp: 'ebi 5/3/2018 13:29:40'!
englishStartsClick

	self model searchString: self searchString; englishStartsClick! !

!IEDictWindow methodsFor: 'GUI building' stamp: 'ebi 5/3/2018 13:28:44'!
interlinguaContainsClick

	self model searchString: self searchString; interlinguaContainsClick! !

!IEDictWindow methodsFor: 'GUI building' stamp: 'ebi 5/3/2018 13:29:00'!
interlinguaStartsClick

	self model searchString: self searchString; interlinguaStartsClick! !

!IEDictWindow methodsFor: 'GUI building' stamp: 'ebi 5/3/2018 13:25:27'!
makeButtonArea
	"Answer a LayoutMorph with our four buttons -- a column of two rows"
	
	|  buttonHeight buttonLayout interlinguaButtonLayout englishButtonLayout buttonArea |
	buttonHeight := self textSizeUnit * 2.
	buttonLayout := LayoutSpec proportionalWidth: 0.3 fixedHeight: buttonHeight.
	
	interlinguaButtonLayout := LayoutMorph newRow. "a row of two buttons"

	interlinguaButtonLayout 
		padding: #center; 
		separation: 2;
		addMorph: 
			(PluggableButtonMorph 
				model: self 
				action: #interlinguaContainsClick  
				label: 'Interlingua Contains')  layoutSpec: buttonLayout;
		addMorph: 
			(PluggableButtonMorph 
				model: self 
				action: #interlinguaStartsClick  
				label: 'Interlingua Starts') layoutSpec: buttonLayout.

	englishButtonLayout := LayoutMorph newRow. "a row of two buttons"
									.
	englishButtonLayout 
		padding: #center; 
		separation: 2;
		addMorph: 
			(PluggableButtonMorph 
				model: self 
				action: #englishContainsClick  
				label: 'English Contains') layoutSpec: buttonLayout;				
		addMorph: 
			(PluggableButtonMorph 
				model: self
				action: #englishStartsClick  
				label: 'English Starts') layoutSpec: buttonLayout.

	buttonArea := LayoutMorph newColumn.
	^ buttonArea 
			layoutSpec: (LayoutSpec proportionalWidth: 1; fixedHeight: 4 * self textSizeUnit);
			addMorph: interlinguaButtonLayout ;
			addMorph: englishButtonLayout ;
			yourself! !

!IEDictWindow methodsFor: 'GUI building' stamp: 'ebi 5/3/2018 13:23:58'!
makeEntryArea
	"Answer a LayoutMoph containing the prompt and text entry area"
	
	| entryLayout entryHeigth |
	entryHeigth := self defaultSeparation * 2 + self textSizeUnit.
	
	entryLayout := LayoutMorph newRow.
	
	promptMorph := (StringMorph contents: 'Enter Text: ') 
					emphasis: AbstractFont boldCode; 
					yourself.
	promptMorph  layoutSpec: 
		(LayoutSpec fixedWidth: (promptMorph measureContents x)).
			
	entryTextMorph := (OneLineEditorMorph contents: 'salute'). "initial text"
	entryTextMorph 
		crAction: [self interlinguaContainsClick]; "Same action as IA-Contains button"
		layoutSpec: 
			(LayoutSpec proportionalWidth: 0.9).
			
	^ entryLayout 
		separation: self defaultSeparation;
		layoutSpec: (LayoutSpec proportionalWidth: 1 fixedHeight: entryHeigth);
		addMorph: promptMorph;
		addMorph: entryTextMorph;
		padding: #left
		yourself! !

!IEDictWindow methodsFor: 'GUI building' stamp: 'ebi 5/3/2018 13:27:28'!
makeResultsArea
	"Answer a LayoutMoph containing the results of the query"
	
	resultMorph := (PluggableListMorph
		model: model 
		listGetter: #resultAsList
		indexGetter: #resultIndex
		indexSetter: #resultIndex:
		mainView: self
		menuGetter: nil
		keystrokeAction: nil).
		
	^ resultMorph 
		layoutSpec: (LayoutSpec proportionalWidth: 1.0 proportionalHeight: 0.98);  
		color: (Theme current textHighlight);
		yourself! !

!IEDictWindow methodsFor: 'GUI building' stamp: 'ebi 5/3/2018 17:23:42'!
searchResultsChanged
	"Display updated search results"
	
	resultMorph updateList ! !

!IEDictWindow class methodsFor: 'instance creation' stamp: 'ebi 5/3/2018 11:46:38'!
open
"
	IEDictWindow open
	
"
	^ self open: (IEDict new) label: 'Interlingua <--> Englisch'! !

!IEDictWindow class methodsFor: 'geometry' stamp: 'ebi 5/3/2018 13:33:51'!
defaultSeparation
	"Answer the number of pixels between fields/layouts"
	
	^ 5 "pixels"! !

!IEDictWindow class methodsFor: 'geometry' stamp: 'ebi 5/3/2018 13:34:09'!
textSizeUnit
	"Answer the scaling factor for sizing; note  method #fontPreferenceChanged"

	^ AbstractFont default height! !

!IEDict methodsFor: 'initialization' stamp: 'ebi 5/3/2018 13:44:57'!
initialize

	super initialize.
	searchString := 'salute'.
	searchResult := #().
	resultIndex  := 0.! !

!IEDict methodsFor: 'accessing' stamp: 'ebi 5/3/2018 17:03:31'!
resultIndex
	
	^resultIndex ! !

!IEDict methodsFor: 'accessing' stamp: 'ebi 5/3/2018 17:04:12'!
resultIndex: aRegularExpressionString
	
	resultIndex := aRegularExpressionString! !

!IEDict methodsFor: 'accessing' stamp: 'ebi 5/3/2018 17:02:41'!
searchResult
	
	^searchResult! !

!IEDict methodsFor: 'accessing' stamp: 'ebi 5/3/2018 17:18:35'!
searchResult: newResult
	
	searchResult := newResult .
	self triggerEvent: #newSearchResult! !

!IEDict methodsFor: 'accessing' stamp: 'ebi 5/3/2018 13:42:15'!
searchString
	
	^ searchString! !

!IEDict methodsFor: 'accessing' stamp: 'ebi 5/3/2018 13:43:01'!
searchString: aRegularExpressionString
	
	searchString := aRegularExpressionString! !

!IEDict methodsFor: 'ui support' stamp: 'ebi 5/3/2018 17:06:00'!
englishContainsClick
	
	self searchResult:  (IEDict englishContains: (self searchString)).
	self resultIndex: 0.! !

!IEDict methodsFor: 'ui support' stamp: 'ebi 5/3/2018 17:06:20'!
englishStartsClick
	
	self searchResult:  (IEDict englishStarts: (self searchString)).
	self resultIndex: 0.! !

!IEDict methodsFor: 'ui support' stamp: 'ebi 5/3/2018 17:05:18'!
interlinguaContainsClick
	
	self searchResult:  (IEDict interlinguaContains: (self searchString)).
	self resultIndex: 0.! !

!IEDict methodsFor: 'ui support' stamp: 'ebi 5/3/2018 17:05:41'!
interlinguaStartsClick
	
	self searchResult:  (IEDict interlinguaStarts: (self searchString)).
	self resultIndex: 0.! !

!IEDict methodsFor: 'ui support' stamp: 'ebi 5/3/2018 17:06:40'!
resultAsList
	"Answer a list of form 'this <---> that' "
	
	^ self searchResult collect:[ :elt | (elt at: 1) , ' <---> ', (elt at: 2) ]
! !

!IEDict class methodsFor: 'class initialization' stamp: 'ebi 5/2/2018 18:17:42'!
initialize
	"Read in my data"
"
	IEDict initialize.
"
	| curIndex aLine |
	DictData := Array new: 30811. "We know the exact size (wc -l iedict.txt) less 1"

	(self package fullFileName asFileEntry parent  // 'iedict.txt') readStreamDo: [ :fileStream |
		fileStream nextLine. "Skip initial comment line"
		curIndex := 1.
		aLine := fileStream nextLine. 
		[aLine isNil] whileFalse: [
			DictData at: curIndex 
				  put: ((aLine findBetweenSubStrs: ':') 
						collect: [:str| str withBlanksTrimmed]). 
			aLine := fileStream nextLine. 
			curIndex := 1 + curIndex.
		]
	] ! !

!IEDict class methodsFor: 'lookup' stamp: 'ebi 5/3/2018 11:13:52'!
englishContains: aString
	"Answer all definition pairs which contain aString looking in the English side"

	| matchStr |
	matchStr :=  ('*' , aString , '*' ) .
	
	^DictData select: [ :pairArray | matchStr match: (pairArray at: 2) ]
! !

!IEDict class methodsFor: 'lookup' stamp: 'ebi 5/3/2018 11:14:25'!
englishStarts: aString
	"Answer all definition pairs which starts with aString looking in the English side"

	| matchStr |
	matchStr :=  aString , '*'  .
	
	^DictData select: [ :pairArray | matchStr match: (pairArray at: 2) ]! !

!IEDict class methodsFor: 'lookup' stamp: 'ebi 5/3/2018 11:12:15'!
interlinguaContains: aString
	"Answer all definition pairs which contain aString looking in the Interlingua side"

	| matchStr |
	matchStr :=  ('*' , aString , '*' ) .
	
	^DictData select: [ :pairArray | matchStr match: (pairArray at: 1) ]
! !

!IEDict class methodsFor: 'lookup' stamp: 'ebi 5/3/2018 11:13:30'!
interlinguaStarts: aString
	"Answer all definition pairs which starts with aString looking in the Interlingua side"

	| matchStr |
	matchStr :=  aString , '*'  .
	
	^DictData select: [ :pairArray | matchStr match: (pairArray at: 1) ]! !
IEDict initialize!
