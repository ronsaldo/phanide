Metacello new
  baseline: 'Phanide';
  repository: 'filetree://filetree';
  load.

"Save the image"
(Smalltalk saveAs: 'phanide')
    ifFalse: [ Smalltalk snapshot: false andQuit: true ].
