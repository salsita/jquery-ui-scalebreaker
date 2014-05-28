# jquery-ui-scalebreaker

- An ultra-lightweight modal dialog that repositions itself on the screen to the visible viewport and scales back to device-width element size while user is browser zooming into the page. It **stays the same size and in the same position as if the zoom wasn't happening** and for mobile unfriendly websites **as if they were friendly**. Features a click-to-close backdrop of pure industry standard. Needs more love.
- Uses native CSS3 keyframe animations for it's hide/show routine. Scrollable as needed with IScroll 5 lite.
- Built upon the jQuery UI widget factory, minimal design easily customizable in CSS. Potentially usable for other than dialog pattern designs.
- ???

A demo currently lives [here](http://mystrd.at/testing/jq-scalebreaker/demo/). Go mobile and pinch it.

## Options
*Example*  
`$('body').scalebreaker({  
  dialogPosition: 'bottom',  
  denyUserScroll: true  
});`

`cssAnimated` - Uses CSS keyframe animations for the entrée/departure. Default `true`.  
`dialogContent` - Initial HTML content to use for the dialog. Minimum and maximum height before scrollbar is enabled is configurable in CSS.  
`dialogPosition` - Screen position to which the dialog snaps, currently supports `top` and `bottom`.  
`closeOnBackdrop` - Closes the dialog when clicking the backdrop wrapper. Default `true`.  
`denyUserScroll` - Try to disable scrolling while the dialog is shown. Default `true`.  
`refreshOnScroll` - Refreshed the dialog position when scroll event is fired. Default `true`.  
`mobileFriendlyMaxWidth` - Maximum initial viewport width that identifies a device friendly website. Default `568`.  
`mobileFriendlyInitialWidth` - The device-width emulation for dialog content. Default `320`.  
`debug` - Prints some info about it's internals into browser console. Default `false`.


## Public methods
*Examples*  
`$('body').scalebreaker('show');`  
`$('body').scalebreaker('changeDialogContent', "<p>Hello world!</p>");`

`show` - Brings the dialog in.  
`hide` - Hides the dialog.  
`changeDialogContent` - Replaces HTML in the dialog from the param and calls refresh.  
`getContentElement` - Return a jQuery reference to the content holding element.  
`refresh` - Recalculates the page sizes/offsets, repositions the widget on screen, manages scrollbar updates.  
