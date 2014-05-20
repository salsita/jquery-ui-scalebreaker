(($) ->
  $.widget "salsita.scalebreaker",

    options:
      scaleDialog: true
      cssAnimated: true
      dialogContent: ''
      idNamespace: 'jq-scalebreaker'
      dialogPosition: 'bottom'
      scaleOrigin: '0 100%'
      closeOnBackdrop: true
      denyUserScroll: true
      debug: true

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

    _getCurrentViewportOffset: ->
      # This may be too iPhony only, needs testing across browsers and devices.
      @currentViewportOffset = [window.pageXOffset, window.pageYOffset]
      @_logMessage 'current viewport offset', @currentViewportOffset

    addContentToDialog: (content) ->
      @dialog.html content
      @_logMessage 'adding content to dialog', content

    rescaleAndReposition: (el) ->
      _self = this
      # Get fresh data.
      scale = @_getScaleFactor()
      @_getCurrentViewportOffset()

      # Apply initial page scaling to the dialog.
      el.css
        'transform': "scale(#{scale})"
        '-webkit-transform': "scale(#{scale})"


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
          if _self.options.scaleDialog
            _self.dialog.removeAttr 'style'
      # Or just close.
      else if @options.closeOnBackdrop
        _self.backdrop.off "click.#{@options.idNamespace}"
        @backdrop.removeClass "#{@options.idNamespace}-show"
        if @options.scaleDialog
          @dialog.removeAttr 'style'
      # Remove inline CSS from the scaling.

      @_logMessage 'hiding widget'

    destroy: ->
      $(window).off "resize.#{@options.dataAttribute} scroll.#{@options.dataAttribute}"
      @element.off()
      clearInterval @autoUpdateTimer
      @element.css
        'clip': 'auto auto auto auto'
      @allClones.remove()
      @allBlocks = null
      @allClones = null
      @overlayOffset = null
      @collisionTarget = null
      @collisionTargetOffset = null
      @collidingBlocks = null
      @collidingBlocksOld = null
      @_destroy()

    _destroy: $.noop

) jQuery