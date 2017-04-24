# Parent Class
AbstractAppRouter = require '../modules/base/abstractAppRouter'

# Routes
DeviceListRoute = require '../modules/device/list/route'
DeviceShowRoute = require '../modules/device/show/route'

InterfaceRoute = require '../modules/interface/show/route'
# # # # #

class AppRouter extends AbstractAppRouter

  radioEvents:
    'router device:list': 'deviceList'
    'router device:show': 'deviceShow'

  deviceList: ->
    @invokeRoute(new DeviceListRoute({ container: @container }))

  deviceShow: (id) ->
    @invokeRoute(new DeviceShowRoute({ container: @container }), id)

# # # # #

module.exports = AppRouter
