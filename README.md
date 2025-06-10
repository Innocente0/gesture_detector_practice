# gesturedetector_practice

My small project for GestureDetector widget

This project shows how flexible the GestureDetector widget is! I made a mini-app to test different gestures like taps, swipes, pinches, and more.

# Three Interactive Screens
*Home Page:*

Tap anywhere on the screen → changes background color 

Double-tap → "to like" the page (shows a heart icon) ❤️

Long-press → reveals hidden text (mostly used to hold status on WhatsApp or story on Instagram so that you can watch the video for a long time)

*Second Page:*

Drag the image → moves it around freely 

Pinch/zoom → resizes the image 

*Image Page:*

All gestures work together! Try rotating/zooming while dragging.

Gestures I Used
I implemented these gesture callbacks:

onTap: For basic taps ( tapping on the image will changes its color)

onDoubleTap: For double-clicks (you will get or see a like at the bottom of the page)

onLongPressStart/End: Shows text while pressing

onLongPress: Fires after holding down

onTapDown: Detects the moment you touch screen

onScaleUpdate: Handles pinching/zooming/dragging

Real-World Examples Shown
Tapping: Changes UI colors (like theme toggles)

Double-tap: "Likes" content (Instagram-style)

Dragging/Pinching: Moves/resizes images (photo editors)

# Images for the Demo

Images for the Demo app can be found in the Images folder.