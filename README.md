# MakeMacro iOS App

## Project setup
Project is setup using [tuist](https://docs.tuist.io/tutorial/get-started).
-   This means, you won't find xcodeproj or xcworkspace files.
-   To generate the project files you have to run `tuist generate` in the root of the folder.

## Setps to get the project working
- Run `tuist generate`
- Select the development team for `MakeMacro` app target.
- Select a device / Sim and run the app.

## Features
- Can add multiple text, image layers.
- Includes support for zooming and moving text / image.
- Can change the background for the macro to a bunch of default colors or pick one from the color picker. The first option in the picker is a "clear" color meaning there will be a transparent background.
- On tapping on the text, you can edit it. Add more text or change the color of the text.
- Once you're done editing the macro, you may tap on next where you will notice an option to add a b/w filter.
- After tapping next on the first screen, you will notice an "Export" button. This opens up a share sheet which will allow you to export your macro to files, share it on iMessages, etc.
- Tapping on an image or text layer will bring that layer "up". So, it is possible to rearrange the level of the layers.

## Knwon issues
- "Saving Image" to photos is not working. Tested on iOS 16. However "Save to Files" works and you can share the macro from there.
- Sharing the macro to some messaging apps results in a cropped image. Again the workaround is to "Save to Files" and then share it to the apps.
- On first launch, granting the permission doesn't show a thumbnail preview. This is an easy fix, however it isn't a blocker for the functioning of the app.

## Features that I would've loved to add
- Allow more text editing options - font, size, formatting etc. This is easy to add and should not change the macro generation implementation.
- Add a button to clear the canvas - right now you've to quit the app to start afresh.
- Option to resize the canvas to the desired size - it is a fixed size for now.
- More filters on the second screen.
- Undo / Redo stack.