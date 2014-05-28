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
  denyUserScroll: true,  
  dialogContent : "<foo>foo right here</foo>"
});`

`cssAnimated` - Uses CSS keyframe animations for the entrée/departure. Default `true`.  
`dialogContent` - Initial HTML content to use for the dialog. Minimum and maximum height before scrollbar is enabled is configurable in CSS.  
`dialogPosition` - Screen position to which the dialog snaps, currently supports `top` and `bottom`.  
`closeOnBackdrop` - Closes the dialog when clicking the backdrop wrapper. Default `true`.  
`denyUserScroll` - Try to disable scrolling while the dialog is shown. Default `true`.  
`refreshOnScroll` - Refreshed the dialog position when scroll event is fired. Default `true`.  
`mobileFriendlyMaxWidth` - Maximum initial viewport width that identifies a device friendly website. Default `568`.  
`mobileFriendlyInitialWidth` - Device-width viewport emulation for websites that are not mobile friendly. Default `320`.  
`broadcastEvents` - Triggers events on the body element for dialog states - `dialogShown.jq-scalebreaker` `dialogHidden.jq-scalebreaker`. Default `true`.  
`debug` - Prints some info about it's internals into browser console. Default `false`


## Public methods
*Examples*  
`$('body').scalebreaker('show');`  
`$('body').scalebreaker('changeDialogContent', "<p>Hello world!</p>");`

`show` - [Bring the widgets in](https://www.youtube.com/watch?v=hkzl0zHIE2k).  
`hide` - Hides the widget.  
`changeDialogContent` - Replaces HTML in the dialog from the param and calls refresh.  
`getContentElement` - Return a jQuery reference to the content holding element.  
`getDialogState` - Returns a string with the dialog state, currently either `hidden` or `shown`.  
`refresh` - Recalculates the page sizes/offsets, repositions the widget on screen, manages scrollbar updates.  
`destroy` - Murders the instance.
