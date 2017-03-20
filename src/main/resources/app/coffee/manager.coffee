class @.ViewResolver
  @mergeViewWithModel = (templateName, model) ->
    source = $(templateName).html()
    template = Handlebars.compile source
    template(model)

class @.Teacher

  @evaluate: ->
    $('#nextEval').on 'click', (e) ->
      if $('#result').val() == $('#response').val()
        console.log 'Son iguales'
        record = parseInt($("#record").html())
        $('#record').html(record+1)
      else
        console.log 'errorz'
      counter = parseInt($("#iteration").html())
      $('#iteration').html(counter+1)

      iteration = parseInt($('#iteration').html())
      if iteration < 11
        PracticerHelper.practice()
      else
        e.preventDefault()
        console.log "Haz concluido una prueba"
        calification = parseInt($("#record").html())
        alert "tu calificación de la prueba fue de #{calification}. Guardando dato"
        $('#record').html(0)
        $('#iteration').html(0)
        UrlManager.setRoute()

class @.RandomHelper

  @numbers: ->
    numberOne = parseInt Math.random() * (10 - 1) + 1
    numberTwo = parseInt Math.random() * (numberOne - 1) + 1
    random = parseInt Math.random() * (5 - 1) + 1
    operator = switch
      when random == 1 then '+'
      when random == 2 then '-'
      when random == 3  then '*'
      when random == 4 then '%'
    result = switch
      when operator == '+' then numberOne + numberTwo
      when operator == '-' then numberOne - numberTwo
      when operator == '*' then numberOne * numberTwo
      when operator == '%' then numberTwo % numberOne

    tuple =
      num1: numberOne
      num2: numberTwo
      operator: operator
      result: result

    tuple

  @drawNumbers:(size, divName)->
    counter = 1
    while counter <= size
      $(divName).after("<span class='glyphicon glyphicon-star' ></span>")
      counter++

class @.PracticerHelper
  @practice: ->
    numbers = RandomHelper.numbers()
    context =
      num1: numbers.num1
      num2: numbers.num2
      operator: numbers.operator
      result: numbers.result
    html = ViewResolver.mergeViewWithModel "#practice-hb", context
    $("#handlebars").html(html)
    Teacher.evaluateExercise()
    Teacher.evaluate()
    RandomHelper.drawNumbers numbers.num1, "#numberOne"
    RandomHelper.drawNumbers numbers.num2, "#numberTwo"


