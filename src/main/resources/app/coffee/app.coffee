class @.App
  constructor: ->
    @manager= new UrlManager()
    Verticle.init()

class @.UrlManager

  constructor: ->
    @emailerController = new EmailerController()
    @start()

  start: ->
    @routes =
      '/': @emailerController.new
      '/practice': @emailerController.new
      '/problems': @emailerController.new
      '/exams': @emailerController.new
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


