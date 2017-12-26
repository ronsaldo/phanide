# Phanide - Pharo Native IDE
----
## Loading
### Loading just the Phanide Browser

```smalltalk
Metacello new
  baseline: 'Phanide';
  repository: 'github://ronsaldo/phanide/filetree';
  load.
```

### Loading the Phanide browser and the Phanide library
The Phanide library provides an event based API for asynchronous external process IO (Used to communica with the GDB Machine Interface), and for monitoring the file system. This library is currently only supported on Linux, but there are plans to support it on OS X and Windows. For loading this, use the following script:

```bash
./newImage.sh
```

----
## Usage

### Browsing a directory

Do the following in a workspace:

```smalltalk
'.' browseDirectory
```

For browsing a directory in a external window, you can do the following (Note: currently there is a bug with the OS X version of OS Window, that will prevent you of receiving mouse events on the external window):

```smalltalk
'.' browseDirectoryInExternalWindow
```

### Inspecting a file with syntax highlighting

The Phanide syntax highlighters are also registered with FileReferences in the GTInspector, so for example you can just inspect C file for gettings syntax highlighting:

```smalltalk
'hello.c' asFileReference inspect
```

----
## Extending the syntax highlighting
### Regex based syntax highlighting

For an example of a Regex based syntax highlighter, check the method `PhanideStyler class >>> #c`

### Petit parser based syntax highlighting
For an example of a Petit Parser based syntax highlighter, check the method `PhanideStyler class >>> #json`, and the `PhanideJSONSyntaxHighlighter` class.
