(($) ->
  $.widget "salsita.scalebreaker",

    options:
      scaleDialog: true
      cssAnimated: true
      dialogContent: ''
      idNamespace: 'jq-scalebreaker'
      dialogPosition: 'bottom'
      closeOnBackdrop: true
      denyUserScroll: true
      debug: false

    _create: ->
      @rawElement =
        "<div id='#{@options.idNamespace}'><div id='#{@options.idNamespace}-dialog'></div></div>"
      @backdrop = null
      @dialog = null
      @scaleFactor = null
      @initialViewport = []
      @currentViewportOffset = []
      @_initWidget()

    _initWidget: ->
      # Append the basic wrapper to the DOM.
      $('body').append @rawElement
      # Cache DOM references.
      @backdrop = $('#' + @options.idNamespace)
      @dialog = @backdrop.find('#' + @options.idNamespace + '-dialog')
      @_logMessage 'wrapper reference created', @backdrop
      # Get common data.
      @_getInitialViewport()
      @_getScaleFactor()
      # Append HTML content.
      @addContentToDialog @options.dialogContent

    _triggerEvent: (name, data) ->
      @element.trigger name, [data]
      @_logMessage name, data

    _logMessage: (name, args) ->
      if @options.debug
        console.debug "#{@options.idNamespace}: #{name}", args

    _getScaleFactor: ->
      @scaleFactor = window.innerWidth/document.documentElement.clientWidth
      @_logMessage 'scale factor found', @scaleFactor
      return @scaleFactor

    _getInitialViewport: ->
      # Could there be cases where this is different from position fixed sizes?
      # Safer to always work with left anchor values due to scrollbars possibly being counted from the right.
      @initialViewport = [window.innerWidth, window.innerHeight]
      @_logMessage 'initial viewport', @initialViewport
      return @initialViewport

    _getCurrentViewportOffset: ->
      # This may be too iPhony (though nice), needs testing across browsers and devices.
      @currentViewportOffset = [window.pageXOffset, window.pageYOffset]
      @_logMessage 'current viewport offset', @currentViewportOffset
      return @currentViewportOffset

    addContentToDialog: (content) ->
      @dialog.html content
      @_logMessage 'adding content to dialog', content

    rescaleAndReposition: (el) ->
      _self = this
      # Cache and freeze the viewport values.
      oldViewport = @initialViewport
      newViewport = @_getCurrentViewportOffset()
      # Reposition the dialog to the current viewport.
      if @options.dialogPosition is 'top'
        el.css
          'top': newViewport[1]
          'left': 0
          'transform-origin': '0 0'
          '-webkit-transform-origin': '0 0'
      if @options.dialogPosition is 'bottom'
        el.css
          'bottom': oldViewport[1] - (newViewport[1] + window.innerHeight)
          'left': 0
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
      # Deny user scrolling while widget is visible.
      if @options.denyUserScroll
        $('body').on "touchmove.#{@options.idNamespace}", (e) ->
          e.preventDefault()
      # Rescale the element and reposition on screen.
      if @options.scaleDialog
        @rescaleAndReposition @dialog
      # Show the widget.
      @backdrop.addClass "#{@options.idNamespace}-show"
      # Add the animation class after element is displayed.
      if @options.cssAnimated
        @backdrop.addClass "#{@options.idNamespace}-animate-in"
        @backdrop.one 'animationend webkitAnimationEnd',(e) ->
          _self.backdrop.removeClass "#{_self.options.idNamespace}-animate-in"
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
        @backdrop.one 'animationend webkitAnimationEnd',(e) ->
          _self.backdrop.removeClass "#{_self.options.idNamespace}-animate-out"
          _self.backdrop.removeClass "#{_self.options.idNamespace}-show"
          # Remove inline CSS from the scaling.
          if _self.options.scaleDialog
            _self.dialog.removeAttr 'style'
      # Or just close.
      else if @options.closeOnBackdrop
        _self.backdrop.off "click.#{@options.idNamespace}"
        @backdrop.removeClass "#{@options.idNamespace}-show"
        # Remove inline CSS from the scaling.
        if @options.scaleDialog
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