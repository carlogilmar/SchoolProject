class @.BeeController
  baseUrl = "http://localhost:8000"

  dashboard: ->
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
      when operator == '%' then numberOne % numberTwo

    context =
      num1: numberOne
      num2: numberTwo
      operator: operator
      result: result

    html = ViewResolver.mergeViewWithModel "#practice-hb", context
    $("#handlebars").html(html)

    counter = 1
    while counter <= numberOne
      console.log "iterando ando"
      $("#numberOne").after("<span class='glyphicon glyphicon-star' ></span>")
      counter++

    counter = 1
    while counter <= numberTwo
      $("#numberTwo").after("<span class='glyphicon glyphicon-star' ></span>")
      counter++

  practice: ->
    context =
      name: "Practice"
    html = ViewResolver.mergeViewWithModel "#practice-hb", context
    $("#handlebars").html(html)

  problems: ->
    context =
      name: "Problmes"
    html = ViewResolver.mergeViewWithModel "#index-hb", context
    $("#handlebars").html(html)

  exams: ->
    context =
      name: "Exams"
    html = ViewResolver.mergeViewWithModel "#index-hb", context
    $("#handlebars").html(html)

