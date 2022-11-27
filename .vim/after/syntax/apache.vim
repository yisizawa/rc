syn keyword apacheDeclaration IncludeOptional
syn keyword apacheDeclaration Protocols
syn keyword apacheDeclaration RequestReadTimeout
syn keyword apacheDeclaration Use

syn match apacheSection "<\/\=\(If\|ElseIf\|Else\)[^>]*>" contains=apacheAnything
syn match apacheSection "<\/\=Macro[^>]*>" contains=apacheAnything
