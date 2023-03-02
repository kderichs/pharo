Extension { #name : #RBCodeSnippetTest }

{ #category : #'*OpalCompiler-Tests' }
RBCodeSnippetTest >> testCompile [

	| method |
	method := snippet compile.
	self assert: method isCompiledMethod
]

{ #category : #'*OpalCompiler-Tests' }
RBCodeSnippetTest >> testExecute [

	| method runBlock phonyArgs |
	self skipIf: #testExecute.
	method := snippet compile.
	self assert: method isCompiledMethod.

	phonyArgs := (1 to: method numArgs) asArray.

	"Executing a lone block will just return a block, we have to call value to have something more interesting"
	snippet parse isBlock
		ifTrue: [
			| block phonyBlockArgs |
			block := nil withArgs: phonyArgs executeMethod: method.
			phonyBlockArgs := (1 to: block numArgs) asArray.
			runBlock := [ block valueWithArguments: phonyBlockArgs ] ]
		ifFalse: [ runBlock := [ nil withArgs: phonyArgs executeMethod: method ] ].

	snippet messageNotUnderstood ifNotNil: [ :mnu |
		runBlock onDNU: mnu do: [ ^ self ].
		self signalFailure: 'Should have raised MNU ' , mnu ].

	snippet raise ifNotNil: [ :class | ^ self should: runBlock raise: class ].

	snippet hasValue
		ifFalse: [ self should: runBlock raise: RuntimeSyntaxError ]
		ifTrue: [ self assert: runBlock value equals: snippet value ]
]