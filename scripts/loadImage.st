Metacello new
  baseline: 'Phanide';
  repository: 'gitlocal://.';
  load.

"Save the image"
(Smalltalk saveAs: 'phanide')
    ifFalse: [ Smalltalk snapshot: false andQuit: true ].
