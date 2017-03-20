class @.ViewResolver
  @mergeViewWithModel = (templateName, model) ->
    source = $(templateName).html()
    template = Handlebars.compile source
    template(model)

class @.Teacher

  constructor: ->
    @beeController = new BeeController()

  @evaluateExercise: ->
    $('#submitEval').on 'click', (e) ->
      e.preventDefault()
      if $('#result').val() == $('#response').val()
        console.log 'Son iguales'
        console.log 'pintando ando'
      else
        console.log 'errorz'
