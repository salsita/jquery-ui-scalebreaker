# jquery-ui-scalebreaker

- An ultra-lightweight modal dialog that repositions itself on the screen to the visible viewport and scales back to device-width element size while user is browser zooming into the page. It **stays the same size and in the same position as if the zoom wasn't happening**. Features a click-to-close backdrop of pure industry standard. Needs more love.
- Uses native CSS3 keyframe animations for it's hide/show routine. Scrollable with IScroll 5 lite.
- Built upon the jQuery UI widget factory, minimal design easily customizable in CSS.
- ???

A demo currently lives [here](http://mystrd.at/testing/jq-scalebreaker/demo/). Go mobile and pinch it.

## Options

`cssAnimated`: Use CSS keyframe animations for the entrée/departure? Default `true`.
`dialogContent`: Initial HTML content to use for the dialog.
`dialogPosition`: Screen position to which the dialog snaps, currently supports `top` and `bottom`.
`closeOnBackdrop`: Close the dialog when clicking the backdrop wrapper? Default `true`.
`denyUserScroll`: Try to disable scrolling while the dialog is shown. Default `true`.
`refreshOnScroll`: Refreshed the dialog position when scroll event is fired. Default `true`.
`debug`: Prints some info into console. Default `false`.

## Public methods

`show`: Brings the widget in.
`hide`: Hides the widget.
`changeDialogContent`: Replaces HTML in the dialog from the param and calls refresh.
`refresh`: Recalculates the page sizes/offsets, repositions the widget on screen, manages scrollbar updates.