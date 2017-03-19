class @.BeeController
  baseUrl = "http://localhost:8000"

  dashboard: ->
    context =
      name: "Dashboard"
    html = ViewResolver.mergeViewWithModel "#index-hb", context
    $("#handlebars").html(html)

  practice: ->
    context =
      name: "Practice"
    html = ViewResolver.mergeViewWithModel "#index-hb", context
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

