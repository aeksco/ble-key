
# RSSIView class definition
# Defines a Marionette.LayoutView that polls for RSSI
# changes at a set interval and renders that updated figure in the view.
class RSSIView extends Marionette.LayoutView
  template: require './templates/rssi'
  className: 'label label-primary'
  tagName: 'span'

  modelEvents:
    'change': 'render'

  onRender: ->
    return @startPolling() if @model.get('connected')
    @stopPolling()

  onDestroy: ->
    @stopPolling()

  startPolling: ->
    return if @interval
    @interval = setInterval( @model.readRSSI, 500 )

  stopPolling: ->
    return unless @interval
    clearInterval(@interval)
    delete @interval

# # # # #

# ControlsView class definition
# Defines a Marionette.LayoutView that acts as a control
# interface to a Bluetooth device.
class ControlsView extends Marionette.LayoutView
  template: require './templates/controls'
  # className: 'row'

  tagName: 'ons-list'

  ui:
    connect: '[data-click=connect]'
    disconnect: '[data-click=disconnect]'
    checkbox: 'input[type=checkbox]'

  events:
    'click @ui.connect':    'connect'
    'click @ui.disconnect': 'disconnect'
    'change @ui.checkbox':  'toggleKnown'
    'switchChange.bootstrapSwitch @ui.checkbox':  'toggleKnown'

  connect: ->
    @model.connect()
    .then (success) => @render()
    .catch (err) => console.log 'ERROR CONNECTING' # TODO - this erroneously fires, what the hell?

  disconnect: ->
    @model.disconnect()
    .then () => @render()
    .catch () -> console.log 'ERROR DISCONNECTING'

  onRender: ->
    return unless @model.get('connected')
    @ui.checkbox.bootstrapSwitch({ size: 'small', onText: 'Yes', offText: 'No' })

  toggleKnown: (e) ->
    e.stopPropagation()
    return @model.forget() if @model.get('known')
    return @model.remember()

# # # # #

# DetailsView class definition
# Defines a Marionette.LayoutView in which the device's
# RAW JSON structure is displayed
# This is a debug view and will be removed in a later build
class DetailsView extends Marionette.LayoutView
  template: require './templates/details'
  className: 'json-viewer'

  modelEvents:
    'change:connected': 'render'

  serializeData: ->
    data = super
    data.json = JSON.stringify(@model.toJSON(), null, 2).split("\n")
    data

# # # # #

# DeviceShowLayout class definition
# Defines a basic Marionette.Layoutview in which
# the RSSIView, ControlsView, and DetailsView are rendered
class DeviceShowLayout extends Marionette.LayoutView
  template: require './templates/layout'
  # className: 'container-fluid'

  tagName: 'ons-page'

  regions:
    # rssiRegion: '[data-region=rssi]'
    controlsRegion: '[data-region=controls]'
    # detailsRegion: '[data-region=details]'


  onRender: ->
    console.log @model
    # @rssiRegion.show new RSSIView({ model: @model })
    @controlsRegion.show new ControlsView({ model: @model })
    # @detailsRegion.show new DetailsView({ model: @model })

# # # # #

module.exports = DeviceShowLayout
