(($) ->
  $.widget "salsita.scalebreaker",

    # TODO:
    # Refresh method, onresize it breaks (default bind to refresh)
    # Clean up real world cases
    # fix the scrollbar counted in innerWidth
    # deny double tap in iOS
    # add scale to center

    options:
      cssAnimated: true
      dialogContent: ''
      # Namespace only affects the HTML currently, not CSS rules.
      idNamespace: 'jq-scalebreaker'
      dialogPosition: 'bottom'
      closeOnBackdrop: true
      denyUserScroll: true
      debug: false

    _create: ->
      @rawElement =
        "<div id='#{@options.idNamespace}'>
           <div id='#{@options.idNamespace}-dialog'>
             <div id='#{@options.idNamespace}-dialog-content'></div>
           </div>
         </div>"
      @backdrop = null
      @dialog = null
      @dialogContent = null
      @scaleFactor = null
      @fullPageHeight = null
      @currentViewportOffset = []
      @_initWidget()

    _initWidget: ->
      # Append the basic wrapper to the DOM.
      $('body').append @rawElement
      # Cache DOM references.
      @backdrop = $('#' + @options.idNamespace)
      @dialog = $('#' + @options.idNamespace + '-dialog')
      @dialogContent = $('#' + @options.idNamespace + '-dialog-content')
      @_logMessage 'wrapper reference created', @backdrop
      # Sets height of the backdrop, important step prone to potential issues.
      # Position fixed cannot be used due to iPhone post-process moving elements relative to page edge during user scaling.
      @_setBackdropHeight()
      # Append initial HTML content.
      # The widget stays in the DOM so any 3rd party manipulation of it's content is A-okay at any time.
      @addContentToDialog @options.dialogContent

    _logMessage: (name, args) ->
      if @options.debug
        console.debug "#{@options.idNamespace}: #{name}", args

    _getScaleFactor: ->
      @scaleFactor = window.innerWidth/document.documentElement.clientWidth
      @_logMessage 'scale factor', @scaleFactor
      return @scaleFactor

    _getCurrentViewportOffset: ->
      # This may be too iPhony (though nice), needs testing across browsers and devices.
      @currentViewportOffset = [window.pageXOffset, window.pageYOffset]
      @_logMessage 'current viewport offset', @currentViewportOffset
      return @currentViewportOffset

    _setBackdropHeight: ->
      @fullPageHeight = Math.max(document.body.offsetHeight,
        document.documentElement.clientHeight,
        document.documentElement.scrollHeight,
        document.documentElement.offsetHeight)
      @backdrop.css
        'height': @fullPageHeight

    addContentToDialog: (content) ->
      @dialogContent.html content
      @_logMessage 'adding content to dialog', content

    rescaleAndReposition: (el) ->
      _self = this
      # Cache and freeze the viewport values.
      newViewport = @_getCurrentViewportOffset()
      # Reposition the dialog to the current viewport.
      if @options.dialogPosition is 'top'
        el.css
          'top': newViewport[1]
          'left': newViewport[0]
          'transform-origin': '0 0'
          '-webkit-transform-origin': '0 0'
      if @options.dialogPosition is 'bottom'
        el.css
          'bottom': _self.fullPageHeight - (newViewport[1] + window.innerHeight)
          'left': newViewport[0]
          'transform-origin': '0 100%'
          '-webkit-transform-origin': '0 100%'
      # Apply scale.
      el.css
        'transform': "scale(#{_self._getScaleFactor()})"
        '-webkit-transform': "scale(#{_self._getScaleFactor()})"

    show: ->
      _self = this
      # Close on backdrop click bind.
      if @options.closeOnBackdrop
        _self.backdrop.on "click.#{@options.idNamespace}", (e) ->
          if e.target is _self.backdrop.get(0)
            _self.hide()
      # Deny user touch scrolling while widget is visible.
      # This solves a lot of proxy UX monstrosities, visual browser imperfection prolapses and code complexity issues for the moment.
      if @options.denyUserScroll
        $('body').on "touchmove.#{@options.idNamespace}", (e) ->
          e.preventDefault()

      # Show the widget.
      @backdrop.addClass "#{@options.idNamespace}-show"
      # Rescale the element and reposition on screen.
      @rescaleAndReposition @dialog
      # Add the animation class after element is displayed.
      if @options.cssAnimated
        @backdrop.addClass "#{@options.idNamespace}-animate-in"
        @backdrop.on 'animationend webkitAnimationEnd',(e) ->
          if e.target is _self.dialogContent.get(0)
            _self.backdrop.removeClass "#{_self.options.idNamespace}-animate-in"
            _self.backdrop.off 'animationend webkitAnimationEnd'
      @_logMessage 'showing widget'

    hide: ->
      _self = this
      # Remove the user scrolling bind.
      if @options.denyUserScroll
        $('body').off "touchmove.#{@options.idNamespace}"
      # Animate out and hide on click.
      if @options.closeOnBackdrop and @options.cssAnimated
        _self.backdrop.off "click.#{@options.idNamespace}"
        @backdrop.addClass "#{@options.idNamespace}-animate-out"
        @backdrop.on 'animationend webkitAnimationEnd',(e) ->
          if e.target is _self.dialogContent.get(0)
            _self.backdrop.removeClass "#{_self.options.idNamespace}-animate-out"
            _self.backdrop.removeClass "#{_self.options.idNamespace}-show"
            # Remove inline CSS from the scaling.
            _self.dialog.removeAttr 'style'
            _self.backdrop.off 'animationend webkitAnimationEnd'
      # Or just close.
      else if @options.closeOnBackdrop
        _self.backdrop.off "click.#{@options.idNamespace}"
        @backdrop.removeClass "#{@options.idNamespace}-show"
        # Remove inline CSS from the scaling.
        @dialog.removeAttr 'style'
      @_logMessage 'hiding widget'

    destroy: ->
      @backdrop.remove()
      @rawElement = null
      @backdrop = null
      @dialog = null
      @scaleFactor = null
      @initialViewport = null
      @currentViewportOffset = null
      @_destroy()

    _destroy: $.noop

) jQuery
