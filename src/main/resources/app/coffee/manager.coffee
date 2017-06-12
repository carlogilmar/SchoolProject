class @.ViewResolver
  @mergeViewWithModel = (templateName, model) ->
    source = $(templateName).html()
    template = Handlebars.compile source
    template(model)

class @.Teacher

  @evaluate:(type)->
    $('#nextEval').on 'click', (e) ->
      if $('#resultInput').val() == $('#responseInput').val()
        swal 'Respuesta Correcta', '¡Acierto!', 'success'
        record = parseInt($("#record").html())
        $('#record').html(record+1)
      else
        res = parseInt($("resultInput").val())
        console.log res
        swal 'Respuesta equivocada', "Sigue practicando", 'error'

      counter = parseInt($("#iteration").html())
      $('#iteration').html(counter+1)
      progress = "#{counter+1}0%"
      console.log progress

      iteration = parseInt($('#iteration').html())
      if iteration < 10
        if type == "practice_type"
          PracticerHelper.practice()
          document.getElementById("progressBar").style["width"] = progress
        else if type == "exam_type"
          PracticerHelper.exam()
          document.getElementById("progressBar").style["width"] = progress
        else if type == "plus_type"
          PracticerHelper.plus()
          document.getElementById("progressBar").style["width"] = progress
        else if type == "minus_type"
          PracticerHelper.minus()
          document.getElementById("progressBar").style["width"] = progress
        else if type == "multiply_type"
          PracticerHelper.multiply()
          document.getElementById("progressBar").style["width"] = progress
        else if type == "division_type"
          PracticerHelper.division()
          document.getElementById("progressBar").style["width"] = progress
      else
        e.preventDefault()
        swal "¡Haz concluido esta prueba, ve al dashboard!"
        calification = parseInt($("#record").html())
        console.log "tu calificación de la prueba fue de #{calification}. Guardando dato"
        swal 'Terminaste una prueba', 'Tu calificación es de #{calificacion}', 'success'
        $('#record').html(0)
        $('#iteration').html(0)
        ConnectorManager.addTest calification, type
        UrlManager.setRoute()

class @.RandomHelper

  @numbers: ->
    numberOne = parseInt Math.random() * (10 - 1) + 1
    numberTwo = parseInt Math.random() * (numberOne - 1) + 1
    random = parseInt Math.random() * (4 - 1) + 1
    operator = switch
      when random == 1 then '+'
      when random == 2 then '-'
      when random == 3  then '*'
    result = switch
      when operator == '+' then numberOne + numberTwo
      when operator == '-' then numberOne - numberTwo
      when operator == '*' then numberOne * numberTwo

    tuple =
      num1: numberOne
      num2: numberTwo
      operator: operator
      result: result

    tuple

  @drawNumbers:(size, divName)->
    counter = 1
    while counter <= size
      console.log "Poniendo abeja"
      $(divName).after("<img src='resources/abeja.png' />")
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
    Teacher.evaluate "practice_type"
    RandomHelper.drawNumbers numbers.num1, "#numberOne"
    RandomHelper.drawNumbers numbers.num2, "#numberTwo"

  @multiply: ->
    numbers = RandomHelper.numbers()
    context =
      num1: numbers.num1
      num2: numbers.num2
      operator:'x'
      result: numbers.num1 * numbers.num2
    html = ViewResolver.mergeViewWithModel "#multiply-hb", context
    $("#handlebars").html(html)
    Teacher.evaluate "multiply_type"
    RandomHelper.drawNumbers numbers.num1, "#numberOne"
    RandomHelper.drawNumbers numbers.num2, "#numberTwo"

  @plus: ->
    numbers = RandomHelper.numbers()
    context =
      num1: numbers.num1
      num2: numbers.num2
      operator:'+'
      result: numbers.num1 + numbers.num2
    html = ViewResolver.mergeViewWithModel "#plus-hb", context
    $("#handlebars").html(html)
    Teacher.evaluate "plus_type"
    RandomHelper.drawNumbers numbers.num1, "#numberOne"
    RandomHelper.drawNumbers numbers.num2, "#numberTwo"

  @minus: ->
      numbers = RandomHelper.numbers()
    #if(numbers.num1 > numbers.num2)
      context =
        num1: numbers.num1
        num2: numbers.num2
        operator:'-'
        result: numbers.num1 - numbers.num2
      html = ViewResolver.mergeViewWithModel "#minus-hb", context
      $("#handlebars").html(html)
      Teacher.evaluate "minus_type"
      RandomHelper.drawNumbers numbers.num1, "#numberOne"
      RandomHelper.drawNumbers numbers.num2, "#numberTwo"
    #else
    #  context =
    #    num1: numbers.num2
    #    num2: numbers.num1
    #    operator:'-'
    #    result: numbers.num1 - numbers.num2
    #  html = ViewResolver.mergeViewWithModel "#minus-hb", context
    #  $("#handlebars").html(html)
    #  Teacher.evaluate "minus_type"
    #  RandomHelper.drawNumbers context.num1, "#numberOne"
    #  RandomHelper.drawNumbers context.num2, "#numberTwo"

  @division: ->
    numbers = RandomHelper.numbers()
    console.log "Obteniendo numeros"
    if(numbers.num1 < numbers.num2)
      context =
        num1: numbers.num2
        num2: numbers.num1
        operator:'%'
        result: numbers.num2 / numbers.num1
    else
      context =
        num1: numbers.num1
        num2: numbers.num2
        operator:'%'
        result: numbers.num1 / numbers.num2
    html = ViewResolver.mergeViewWithModel "#division-hb", context
    $("#handlebars").html(html)
    Teacher.evaluate "division_type"
    console.log context
    RandomHelper.drawNumbers context.num1, "#numberOne"
    RandomHelper.drawNumbers context.num2, "#numberTwo"

  @exam: ->
    numbers = RandomHelper.numbers()
    context =
      num1: numbers.num1
      num2: numbers.num2
      operator: numbers.operator
      result: numbers.result
    html = ViewResolver.mergeViewWithModel "#exam-hb", context
    $("#handlebars").html(html)
    Teacher.evaluate "exam_type"


class @.ConnectorManager

  baseUrl = "http://localhost:8000"

  @addTest:(evaluation, evalType)->
    data =
     evaluation: evaluation
     evaluationType: evalType
    $.ajax
      data: data
      type: 'post'
      url: baseUrl + '/registerTest'
      success: ->
        console.log "Exito al agregar"
      error: ->
        console.log "Error al agregar"

  @getRecords:->
    $.get('http://localhost:8000/findRecord').done((response)->
      new (Chartist.Line)('.exam-chart', {
        series: [response.examEval]
      },
          width: 1000
          height: 500)

      new (Chartist.Line)('.practice-chart', {
        series: [response.evaluations]
      },
          width: 1000
          height: 500)

      new (Chartist.Line)('.plus-chart', {
        series: [response.plusEval]
      },
          width: 1000
          height: 500)

      new (Chartist.Line)('.minus-chart', {
        series: [response.minusEval]
      },
          width: 1000
          height: 500)

      new (Chartist.Line)('.multiply-chart', {
        series: [response.multiplyEval]
      },
          width: 1000
          height: 500)

      new (Chartist.Line)('.division-chart', {
        series: [response.divisionEval]
      },
          width: 1000
          height: 500)

      $("#examCounter").html("#{response.examCounter}")
      $("#practiceCounter").html("#{response.practiceCounter}")
      $("#plusCounter").html("#{response.plusCounter}")
      $("#minusCounter").html("#{response.minusCounter}")
      $("#multiplyCounter").html("#{response.multiplyCounter}")
      $("#divisionCounter").html("#{response.divisionCounter}")

    ).fail ->
      console.log "Error al consultar el record"

