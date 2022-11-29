const { StatusCodes } = require("http-status-codes");
const S = require('fluent-json-schema');
const { Sequelize, sequelize /* ... további modellek importálása itt */ } = require("../models");
const { ValidationError, DatabaseError, Op } = Sequelize;

module.exports = function (fastify, opts, next) {
    // http://127.0.0.1:4000/
    fastify.get("/", async (request, reply) => {
        reply.send({ message: "Gyökér végpont" });
        // * A send alapból 200 OK állapotkódot küld, vagyis az előző sor ugyanaz, mint a következő:
        // reply.status(StatusCodes.OK).send({ message: "Gyökér végpont" });
    });

    // http://127.0.0.1:4000/auth-protected
    fastify.get("/auth-protected", { onRequest: [fastify.auth] }, async (request, reply) => {
        reply.send({ user: request.user });
    });

    next();
};

module.exports.autoPrefix = "/";
