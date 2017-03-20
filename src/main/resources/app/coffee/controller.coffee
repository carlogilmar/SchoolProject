class @.BeeController
  baseUrl = "http://localhost:8000"

  practice: ->
    PracticerHelper.practice()

  dashboard: ->
    context =
      name: "Practice"
    html = ViewResolver.mergeViewWithModel "#index-hb", context
    $("#handlebars").html(html)
    ConnectorManager.getRecords()

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

