# Compose Keys [![GitHub Release](https://img.shields.io/github/v/release/asherber/compose-keys)](//github.com/asherber/compose-keys/releases/latest)

**compose-keys** is a Windows app which mimics the functionality of the "Compose" key on Linux systems, allowing you to type accented letters and special symbols by pressing a modifier key followed by intuitive 2-character combinations. It's provided as a compiled AutoHotKey executable.

This is a fork of the original [compose-keys](//github.com/MrBertie/compose-keys) by Hendry Badao.

## Installation

Grab the [latest release](//github.com/asherber/compose-keys/releases/latest), download, and run.

An icon for **compose-keys** will appear in your system tray, Right-click to access the menu to Enable/Disable, change Settings, Restart, or view the Help and Compose Key Table files.  At the top of the menu you can also see the currently active modifier key.

## How To Use

Press and **release** the modifier key, then type any of the [multi-character sequences](//asherber.github.io/compose-keys/keytable.html) to obtain the accent or symbol you need.

By default, the modifier is the right `Ctrl` key, but it can easily be changed in the Settings dialog.

**Example:**

To obtain `á` you would press and release the **modifier key**, then type `'` and then `a`. The order is important!

  - Generally for accented letters the key sequence is: **modifier &rarr; accent &rarr; letter**
  - For symbols it varies according to the list in the link above. The characters chosen are *usually* quite logical and easy to learn.

### Unicode and ASCII code sequences

You can also use compose-keys to directly enter Unicode code points and ASCII codes and have them replaced by the corresponding character.

- For Unicode, press and release the **modifier key**, then type `/u` and then the 4-character code point (for example, `03B5` or `03b5` for a lowercase epsilon `ε`). 
- For ASCII, press and release the **modifier key**, then type `/a` and then the 4-digit code (for example, `0167` for a section sign `§`).

## Settings

Using the tray icon menu (right click) you can access the configuration file, where the following can be changed:

1. **SoundOnReset** : plays a small blip sound to tell you that the modifier key has been reset (by pressing it twice)

2. **ModifierKey** : which key should be used as a modifier, e.g., Caps Lock, Right Alt, Left Alt, Right Ctrl, Left Ctrl, etc. 

3. **UseCapsLock** : also use the CapsLock key as a modifier; the normal CapsLock function can be accessed via Shift+CapsLock or Ctrl+CapsLock.

4. **ResetDelay** : delay in milliseconds before the modifier key is reset, to prevent unwanted key compositions 

## Custom Keys

You can add your own custom key sequences, if the included ones don't meet your needs. Create a file in `%APPDATA%\ComposeKeys` called `customkeys.txt`. (If you are running the app from source, this file should go in the same folder as the other source files.) 

Each definition line in this file should be an AutoHotKey hotstring definition matching the ones in [keys.ahk](keys.ahk). (Blank lines and comment lines are okay, too.) They have the following format:

```
::<keys>::cp("<repl>")  ; optional comment
```

`<keys>` is the sequence you want to type, and `<repl>` is the character or string you want to replace it with. For example, `::qq::cp("Foo")` can be used to replace `qq` with `Foo`.

- The key sequence follows the usual AutoHotKey rules, so if it contains any character with a special meaning to AutoHotKey, like `^`, that character needs to be escaped with a backtick. For example, the included sequence for `ĥ` (h with circumflex) is defined as `` `^h ``, but you would only need to type `^h` to trigger the replacement.
- Key sequences are not limited to two characters.
- The replacement must look exactly like the above, as an argument passed to the function `cp()`. 
- Do not add any hotstring modifiers between the first two colons.

## License

The modifications and updates in this fork are licensed under the MIT License.

Please note that the original base code was published without an explicit license and remains under the copyright of the original author.
