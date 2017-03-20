package com.makingdevs

import io.vertx.core.json.Json
import io.vertx.groovy.core.Vertx
import io.vertx.groovy.ext.mongo.MongoClient

//Configuration of Mongo
def config = Vertx.currentContext().config()
def mongoClient = MongoClient.createShared(vertx, config.mongo)

//Event Bus Born
def eb = vertx.eventBus()

//Add new User
eb.consumer("com.carlogilmar.test.user", { message ->
    mongoClient.save("aplicationUsers", message.body(), { id ->
      if (id.succeeded()) {
        message.reply("[ok]")
      } else {
        res.cause().printStackTrace()
      }
    })
})

//Add new Test Evaluation
eb.consumer("com.carlogilmar.test.new", { message ->
    mongoClient.save("evaluations", message.body(), { id ->
      if (id.succeeded()) {
        message.reply("[ok]")
      } else {
        res.cause().printStackTrace()
      }
    })
})

//Add new Test Evaluation
eb.consumer("com.carlogilmar.problem.new", { message ->
    mongoClient.save("problems", message.body(), { id ->
      if (id.succeeded()) {
        message.reply("[ok]")
      } else {
        res.cause().printStackTrace()
      }
    })
})

//Show all test by username
eb.consumer("com.carlogilmar.test.findAll") { message ->
    def query=[
      username:message.body().username
    ]
    mongoClient.find("evaluations", query) { res ->
      if (res.succeeded()) {
        message.reply(res.result())}
      else {
        res.cause().printStackTrace()}
    }
}
