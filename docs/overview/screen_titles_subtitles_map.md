Branch	Screen	AppBar Title (e.g.)	Subtitle (e.g.)	Source of AppBar Title	Source of Subtitle	Notes
Path	PathChapterScreen	Competent Crew	(None)	pathName (route param)	(None)	AppBar shows path name
Path	PathItemScreen	Competent Crew	1: Prepare in Advance	pathName	chapter.title from PathRepositoryIndex	Subtitle is chapter title beneath AppBar
Path	LessonDetailScreen	Competent Crew	1: Prepare in Advance → L1: Handling Dock Lines	backExtra['pathName']	chapterTitle + item.title	Breadcrumb for clarity inside path navigation
Path	PartDetailScreen	Competent Crew	1: Prepare in Advance → Winches	backExtra['pathName']	chapterTitle + item.title	
Path	ToolDetailScreen	Competent Crew	1: Prepare in Advance → Docking Checklist	backExtra['pathName']	chapterTitle + item.title	
Path	FlashcardDetailScreen	Competent Crew	1: Prepare in Advance → Bowline Card	backExtra['pathName']	chapterTitle + item.title	
Lesson	LessonModuleScreen	Courses	Select a course to embark upon:	Static	Static	Root of lesson branch
Lesson	LessonItemScreen	Docking	Choose a Lesson	module param	Static	Static instruction under module title
Lesson	LessonDetailScreen	Docking	Docking → L1: Handling Dock Lines	backExtra['module']	module + item.title	Module breadcrumb format
Part	PartZoneScreen	Parts	Select a part zone to explore	Static	Static	Root of part branch
Part	PartItemScreen	Deck	Choose a Part	zone param	Static	Mid-level drilldown
Part	PartDetailScreen	Deck	Deck → Winches	backExtra['zone']	zone + item.title	
Tool	ToolBagScreen	Tools	Select a toolbag to access	Static	Static	Root of tool branch
Tool	ToolItemScreen	Procedures	Choose a Tool	toolbag param	Static	
Tool	ToolDetailScreen	Procedures	Procedures → Docking Checklist	backExtra['toolbag']	toolbag + item.title	
Flashcard	FlashcardCategoryScreen	Flashcards	Choose a category	Static	Static	Root of flashcard branch
Flashcard	FlashcardItemScreen	Knots	Choose a Flashcard	category param	Static	
Flashcard	FlashcardDetailScreen	Knots	Knots → Bowline Card	backExtra['category']	category + item.title	