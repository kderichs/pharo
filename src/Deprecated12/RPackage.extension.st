Extension { #name : #RPackage }

{ #category : #'*Deprecated12' }
RPackage >> definedClassesDo: aBlock [

	self deprecated:
		'Use #definedClasses and a do instead because the name of this method is not explicit since it iterates over the *name* of the classes and not the classes themselves.'.
	^ self definedClassNames do: aBlock
]