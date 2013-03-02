# “Trivia Knesset” for IOS #

## About ##
This app is a trivia game based on information about the Israeli Knesset, and it’s members in particular.
Trivia Knesset was written by Stav Ashuri and Leron Fliess 

## Internal folders ##
**Artwork**

This folder contains backgrounds, button designs etc.

**Audio**

Contains different sounds for the game, such as a sound for when a correct answer is chosen

**DACircularProgress**

A progress bar for updating the database, has an API for setting design parameters and progress.

**Google**

Part of the Google Analytics SDK, for more reading refer to https://developers.google.com/analytics/devguides/collection/ios/

**Resources**

Data about the Knesset, updated periodically by the game. Member images folder holds pictures of all Knesset Members. bills, member, party files are Json files in their original format, as found on server.

**SBJson**

Source code for parsing Json files.

**Social/SocialManager**

Provides API for Facebook operations such as login, posting to wall, etc…

**YLProgressBar**

A progress bar that shows time left In the game.

## Selected Internal source files ##

**AboutViewController**

Loads the “About” screen, contains high score, sound switch, links to “Open Knesset” and “Sadna Leyeda Ziburi” links, and logout button.

**AppDelegate**

Handles app launch, minimize, restore, close, and internal timer (the timer needs to be aware of these other actions so time will freeze when app is minimized...

**DataManager**

Handles parsing the data from Json, caching this data on device, and periodical updates.

**DebugFlags**

Flags for activating certain debug modes, such as setting game for only 1 question type for debugging it.

**EndOfGameViewController**

Loads the end of game screen. Contains score, and options to share or start again.

**GameFlowDelegateProtocol**

Provides api for starting a new game or load main screen.

**GeneralTriviaViewController**

Handles general Trivia screen, shows score, time bar, and help button. Implements GameFlowDelegateProtocol API, end of game animation, updates progress bar, and starts request for next question.

**GoogleAnalyticsLogger**

Implements functions for logging specific statistics of the game, using GoogleAnalyticsManager

**GoogleAnalyticsManager**

Provides API for logging different information into google analytics

**ImageTriviaViewController**

Handles objects specific for 4-picture type of questions, including four clickable pictures which can be chosen for the right answer.
Loads questions of this types, Responds to user actions (touch), checks correctness of answer and calls the next question, if needed.

**KTParser**

Implements logic for parsing needed data from JSon tree
ImageTriviaViewController
Handles the back side of each Knesset member picture. Handles display and actions on different links provided as buttons.

**MemberCellViewController**

Handles the front side of each Knesset member picture. Handles display such as right/wrong indication on user guess.

**NewGameViewController**

Loads the new game screen, allowing for game start, facebook sign in etc…

**RightWrongTriviaViewController**

Handles objects specific for right/wring type of questions.
Loads questions of this types, Responds to user actions (touch), checks correctness of answer and calls the next question, if needed.

**ScoreManager**

Implements score logic. Counts score during the game and checks if high score was reached.
DataUpdateViewController
Loads a screen for data update from web. Shows user progress using the circular bar and updates on errors.
