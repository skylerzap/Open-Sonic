# Sonic-Joe-Engine
sonic engine im working on.

Engine is far from usable right now, check back on this project in a month and see if it's usable.

DO NOT WORRY, the engine is still being worked on. I just haven't posted the updates here in a while.

Simple Tiled Implementation by karai17
https://github.com/karai17/Simple-Tiled-Implementation

Thank you Sonic Retro for the Sonic Physics Guide, I've always wanted to make a Sonic Engine and this wouldn't be possible without this guide.
http://info.sonicretro.org/Sonic_Physics_Guide


Engine made with Lua framework: Love2D
https://love2d.org/

Made because of the complexity of other Sonic Engines. (they don't use lua (the only programming language i know is lua))

# Documentation

Open the engine folder with Love2D either with drag and drop or via command lines. Other methods work too, such as with Love2D MSVC extensions.

Currently the engine only has sensors A and B and while there is Sonic running implemented, it does not interact with the sensors, nor does it have gravity.

To view information from the sensors, press B for Sensor A and press N for Sensor B. You need the Love2D console enabled for this to work.

To enable the running currently, add a line that says "debug=true" to the love.load function in main.lua.

# Q&A

Q: What inspired the name of this engine?

A: Joe is a funny word.

note to self: to make the extension work, do this [Y POS WITHIN TILE] + 16 - [HEIGHT OF EXTENSION TILE]
