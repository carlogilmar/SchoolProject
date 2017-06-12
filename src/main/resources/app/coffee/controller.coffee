class @.BeeController
  baseUrl = "http://localhost:8000"

  practice: ->
    PracticerHelper.practice()

  dashboard: ->
    context =
      name: "Practice"
    html = ViewResolver.mergeViewWithModel "#dashboard", context
    $("#handlebars").html(html)
    ConnectorManager.getRecords()

  problems: ->
    context =
      name: "Problmes"
    html = ViewResolver.mergeViewWithModel "#index-hb", context
    $("#handlebars").html(html)

  exams: ->
    PracticerHelper.exam()

  info: ->
    html = ViewResolver.mergeViewWithModel "#info-hb"
    $("#handlebars").html(html)

  plus: ->
    PracticerHelper.plus()

  minus: ->
    PracticerHelper.minus()

  multiply: ->
    PracticerHelper.multiply()

  division: ->
    PracticerHelper.division()

