Compose Keys
============

**compose-keys** mimics the functionality of the "Compose" key on Linux computers, and allows you to type accented letters and special symbols by pressing a modifier key followed by intuitive 2-letter combinations.

This is a fork of the original [compose-keys](//github.com/MrBertie/compose-keys) by Hendry Badao.

Installation
------------

Grab the [latest release](//github.com/asherber/compose-keys/releases/latest), download, and run.

An icon for **compose-keys** will appear in your system tray, Right-click to access the menu to Enable/Disable, change Settings, to Restart, and to view the Help and Compose Key Table files.  At the top of the menu you can also see the currently active "modifier key".

How To Use
----------

Press and **release** the modifier key, then type any of the [2-character sequences](//asherber.github.io/compose-keys/keytable.html) to obtain the accent or symbol you need.

By default, the modifier is the [ **Right Ctrl** ] key, but it can easily be changed in the Settings dialog.

**Example:**

To obtain [ **á** ] you would press [ **Right Ctrl** ] then [ **'** ] then [ **a** ].  The order is important!

  - Generally for accented letters the key sequence is: **modifier &rarr; accent &rarr; letter**
  - For symbols it varies according to the list in the link above. The 2 characters chosen are *usually* quite logical and easy to learn.

Settings
--------

Using the tray icon menu (right click) you can access this help file, and the configuration file, where the following can be changed:

1. **SoundOnReset** : plays a small blip sound to tell you that the modifier key has been reset (by pressing it twice)

2. **ModifierKey** : which key should be used as a modifier, e.g., Caps Lock, Right Alt, Left Alt, Right Ctrl, Left Ctrl, Right Shift, Left Shift, etc. 

3. **UseCapsLock** : Also use the CapsLock key as a modifier.  The normal CapsLock function can be accessed via Shift+CapsLock or Ctrl+CapsLock.

4. **ResetDelay** : delay (in milliseconds: 1000 = 1 sec) before the modifier key is reset, to prevent unwanted key compositions.  Default = 2000ms
