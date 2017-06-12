class @.App
  constructor: ->
    @manager= new UrlManager()
    Verticle.init()

class @.UrlManager

  constructor: ->
    @beeController = new BeeController()
    @start()

  start: ->
    @routes =
      '/': @beeController.dashboard
      '/plus': @beeController.plus
      '/minus': @beeController.minus
      '/multiply': @beeController.multiply
      '/division': @beeController.division
      '/practice': @beeController.practice
      '/problems': @beeController.problems
      '/exams': @beeController.exams
      '/info': @beeController.info
      '/status': @beeController.sstatuss
    @urlMappings()

  urlMappings: ->
    router = Router(@routes)
    router.init()

  @setRoute: ->
    router = Router(@routes)
    router.setRoute '/'

class @.Verticle
  baseUrl = "http://localhost:8000"
  @init: ->
    eb = new EventBus('http://localhost:8000/eventbus')
    eb.onopen = ->
      eb.registerHandler 'com.makingdevs.email.success', (error, message) ->
        Materialize.toast 'Email Enviado\n ' + message.body, 4000


