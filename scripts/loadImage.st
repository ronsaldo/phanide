Metacello new
  baseline: 'Phanide';
  repository: 'tonel://tonel';
  load.

"Save the image"
(Smalltalk saveAs: 'phanide')
    ifFalse: [ Smalltalk snapshot: false andQuit: true ].
