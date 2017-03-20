package com.makingdevs

import io.vertx.groovy.ext.web.handler.StaticHandler
import io.vertx.groovy.ext.web.Router
import io.vertx.groovy.ext.web.handler.BodyHandler
import io.vertx.core.json.Json
import io.vertx.core.json.JsonObject
import io.vertx.groovy.core.Vertx
import io.vertx.core.http.HttpHeaders
import io.vertx.groovy.ext.web.handler.sockjs.SockJSHandler
import io.vertx.groovy.ext.web.handler.StaticHandler
import io.vertx.groovy.ext.web.handler.CookieHandler
import io.vertx.groovy.ext.web.handler.SessionHandler
import io.vertx.groovy.ext.web.handler.UserSessionHandler
import io.vertx.groovy.ext.web.handler.RedirectAuthHandler
import io.vertx.groovy.ext.web.handler.FormLoginHandler
import io.vertx.groovy.ext.web.sstore.LocalSessionStore
import io.vertx.ext.auth.shiro.ShiroAuthRealmType
import io.vertx.groovy.ext.auth.shiro.ShiroAuth
import io.vertx.groovy.ext.mongo.MongoClient
import io.vertx.groovy.ext.auth.mongo.MongoAuth

def config = Vertx.currentContext().config()

//Configuration of Mongo
def mongoClient = MongoClient.createShared(vertx, config.mongo)

//configuracion externalizada
options = [ "config":config ]

//Configuración para hacer el worker
def senderOptions=options
senderOptions.worker=true

//Config for permissons
def opts = [
  outboundPermitteds:[
    [ address:"com.makingdevs.email.success" ]
  ]
]

//routers
def server = vertx.createHttpServer()
def router = Router.router(vertx)
router.route().handler(BodyHandler.create())

router.route().handler(CookieHandler.create())
router.route().handler(BodyHandler.create())
router.route().handler(SessionHandler.create(LocalSessionStore.create(vertx)))

//def authProvider = ShiroAuth.create(vertx, ShiroAuthRealmType.PROPERTIES, [:])
def authProvider = MongoAuth.create(mongoClient, [:])

/*
authProvider.insertUser("carlo","carlo", [],[]){ res ->
  println "*"*100
  println res.dump()
}*/

router.route().handler(UserSessionHandler.create(authProvider))

router.route("/app/*").handler(RedirectAuthHandler.create(authProvider, "/static/"))

router.route("/app/*").handler(StaticHandler.create().setCachingEnabled(false).setWebRoot("app"))

//Verticle de autentificacion
router.post("/loginhandler").handler { routingContext ->
  def params = routingContext.request().params()
  def authInfo = [
    username:params.username,
    password:params.password
   ]

  authProvider.authenticate(authInfo, { res ->
    if (!res.failed()) {
      routingContext.setUser(res.result())
    }

    routingContext.response()
      .setStatusCode(302)
      .putHeader("location", "/app/")
      .end()
  })
}

//Verticle de registro
router.post("/registerhandler").handler { routingContext ->
  def params = routingContext.request().params()
  def authInfo = [
    username:params.username,
    password:params.password
   ]
  //Registrando en mongo
  authProvider.insertUser(authInfo.username,authInfo.password, [],[]){ res ->
  println "Registrando usuario--------->"
  println res.dump()
  }
  //TODO:Registrando otros datos en mongo

  //TODO: Enviar correo de confirmación

  //Redireccioando al main
    routingContext.response()
      .setStatusCode(302)
      .putHeader("location", "/app/")
      .end()
}

router.route("/logout").handler({ contextResponse ->
    contextResponse.clearUser()
    contextResponse.response().putHeader("location", "/app/").setStatusCode(302).end()
})

// Create the event bus bridge and add it to the router.
def ebHandler = SockJSHandler.create(vertx).bridge(opts)
router.route("/eventbus/*").handler(ebHandler)

//Route to Index
router.route("/static/*").handler(
  StaticHandler.create().setCachingEnabled(false)
)

//Add new test evaluation
router.post("/registerTest").handler { routingContext ->
  def params = routingContext.request().params()
  def username = routingContext.user().delegate.principal.map.username
  def testEvaluation= [
    username: username,
    date: new Date().time,
    evaluation: params.evaluation,
    type: params.evaluationType
  ]
  vertx.eventBus().send("com.carlogilmar.test.new", testEvaluation, { reply ->
    if (reply.succeeded()) {
      routingContext.response()
      .setStatusCode(201)
      .putHeader("content-type", "application/json; charset=utf-8")
      .end(Json.encodePrettily([msg:"Calificación Agregado Correctamente."]))
    }
  })
}

//find all records for a specific username
router.route("/findRecord").handler{ routingContext ->
  def user= [username: routingContext.user().delegate.principal.map.username]
  vertx.eventBus().send("com.carlogilmar.test.findAll", user, { reply ->
    if (reply.succeeded())
      routingContext.response()
      .setStatusCode(201)
      .putHeader("content-type", "application/json; charset=utf-8")
      .end(Json.encodePrettily(reply.result().body()))
  })
}//main

//Register a problem
router.post("/registerProblem").handler { routingContext ->
  def params = routingContext.request().params()
  def problemRegister= [
    description: params.description,
    result: 10,
    dateCreated: new Date().time
  ]
  println "...............>"
  println params.dump()
  println "----------------"
  println problemRegister

  vertx.eventBus().send("com.carlogilmar.problem.new", problemRegister, { reply ->
    if (reply.succeeded()) {
      routingContext.response()
      .setStatusCode(201)
      .putHeader("content-type", "application/json; charset=utf-8")
      .end(Json.encodePrettily([msg:"Problema Agregado Correctamente."]))
    }
  })
}

server.requestHandler(router.&accept).listen(8000)

//deploy verticles
vertx.deployVerticle("com/makingdevs/EmailerVerticle.groovy", options)
vertx.deployVerticle("com/makingdevs/SenderVerticle.groovy", senderOptions)
vertx.deployVerticle("com/makingdevs/HelperVerticle.groovy")
