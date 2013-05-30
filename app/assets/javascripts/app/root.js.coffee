Controller = App.Controller

getDefaultController = ->
  # Load empty test controller when running jasmine
  if jasmine? then 'test' else 'splash'

class Controller.Root extends Spine.Stack
  controllers:
    test:           Controller.Test
    splash:         Controller.Splash
    neighborhoods:   Controller.Neighborhoods
    regionsShow:     Controller.Regions.Show
    regionsIndex:    Controller.Regions.Index

  routes:
    '/':                getDefaultController()
    '/neighborhoods/:id':    'neighborhoods'
    '/neighborhoods':        'neighborhoods'
    '/regions':         'regionsIndex'
    '/regions/:id':     'regionsShow'

  default: getDefaultController()
  className: 'stack root'
