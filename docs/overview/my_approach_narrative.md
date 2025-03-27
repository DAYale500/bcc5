Ok, glad I asked as your answer revealed a misalignment in our approaches. 

My approach:
user opens app, starts on a landing page that shows them where they left off in their learning path, perhaps recommends some flashcards to review, has various learningPath buttons, with a bnb to navigate directly deeper into the app to get specific if they choose. They basically have these options:
learningPath: pick one and navigate to pathChapterScreen and see the chapters in that learningPathRepository to choose a chapter (navigate to pathItemScreen) or pick up where they left off (navigate to contentDetailScreen where there are previous/next lesson buttons that follow the sequence as laid out in that learningPathRepository, likely various lessons/parts/flashcards)

or via the bnb:
lesson: tap the icon, navigate to lessonModuleScreen where they can choose a module they're interested in and navigate to lessonItemScreen to choose a specific lesson and navigate to contentDetailScreen (where there are previous/next lesson buttons that follow the sequence of lessons in that lessonModuleRepository)
part: tap the part icon, navigate to partZoneScreen where they can choose a zone they're interested in and navigate to partItemScreen to choose a specific part and navigate to contentDetailScreen (where there are previous/next lesson buttons that follow the sequence of parts in that partZoneRepository)
flashcard: part: tap the flashcard icon, navigate to flashcardCategoryScreen where they can choose a category they're interested in and navigate to flashcardItem Screen to choose a specific flashcard and navigate to contentDetailScreen (where there are previous/next lesson buttons that follow the sequence of flashcards in that flashcard category as gathered from the associated lesson/part repositories)
tools: these are checklists (I'd like them to be modifiable) and rules of thumb, radio channels, etc.
search: type a keyword in a text box, get results sorted by lesson/part/flashcard that are links that can be followed
settings: a hamburger for dealing with accounts, legal, profile, etc.

So, I don't think the filterButton and detailButton are very valuable. But maybe a "Group" button (for chapters/modules/zones/categories) and "Item" button (lesson/part/flashcard items) might be good.



there is no longer a "top area" and "bottom area" on the groupScreens, just the group buttons that navigate to the Item Screens where the item buttons are displayed. So lessonModuleScreen shows the Modules available (in separate repositories) and the lessonItemScreen shows the individual lessons available (their titles in a buttons) and the contentDetailScreen displays the lesson contents.

Also, let's arrange the bnb in this order, left to right:
Home, Modules, Parts, Flashcards, Tools



