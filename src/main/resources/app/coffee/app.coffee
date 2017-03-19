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
      '/practice': @beeController.practice
      '/problems': @beeController.problems
      '/exams': @beeController.exams
    @urlMappings()

  urlMappings: ->
    router = Router(@routes)
    router.init()

  @setRoute: ->
    router = Router(@routes)
    router.setRoute '/readEmailers'

class @.Verticle
  baseUrl = "http://localhost:8000"
  @init: ->
    eb = new EventBus('http://localhost:8000/eventbus')
    eb.onopen = ->
      eb.registerHandler 'com.makingdevs.email.success', (error, message) ->
        Materialize.toast 'Email Enviado\n ' + message.body, 4000


