const { StatusCodes } = require("http-status-codes");
const S = require('fluent-json-schema');
const { Sequelize, sequelize, User, File, Share } = require("../models");
const { faker } = require("@faker-js/faker");
const { ValidationError, DatabaseError, Op } = Sequelize;

module.exports = function (fastify, opts, next) {
    // http://127.0.0.1:4000/
    
    //3. feladat
    fastify.get("/generate-share-link", async (request, reply) => {
        const date = Math.floor(Date.now() / 1000);
        const str = faker.random.alphaNumeric(8);
        const num = faker.datatype.number({
            min: 0,
            max: 100,
        });
        
        const result = `${date}_${str}_${String(num).padStart(3, '0')}`;

    
        reply.status(200).send(result);
    });

    //4. feladat
    fastify.get("/validate-share-link/:link", async (request, reply) => {
        const link = request.params.link;

        if (!link || link == "") {
            return reply.status(400).send();
        }

        const parts = link.split("_");
        if (parts.length != 3) {
            return reply.status(418).send("wrong array len");
        }

        // 1673430159_kceqe4xy_023
        if (parts[0].length != 10 || parts[1].length != 8 || parts[2].length != 3) {
            console.log(parts[0].length);
            console.log(parts[1].length);
            console.log(parts[2].length);
            return reply.status(418).send("wrong str len");
        }

        if(Number.isInteger(Number(parts[0])) == false){
            return reply.status(418).send("0 not int");
        }
        
        
        // StackOverflow
        if( /^[a-z0-9]+$/gi.test(parts[1]) == false ){
            return reply.status(418).send("wrong regex");
        }
        
        if(Number.isInteger(Number(parts[2])) == false){
            return reply.status(418).send("2 not int");

        }
        
        reply.status(200).send({
            date: new Date( parts[0] * 1000),
            alpha: parts[1],
            number: Number(parts[2])
        });
    });

    //5. feladat
    fastify.get("/files", async (request, reply) => {
        reply.send( await File.findAll() );
    });

    //6. feladat
    fastify.get("/files/:id", async (request, reply) => {
        if (!request.params.id) {
            return reply.status(400).send();
        }

        const file = await File.findByPk(request.params.id);
        if (!file) {
            return reply.status(404).send();
        }
        
        reply.status(200).send(file);
    });

    //7. feladat
    fastify.post("/files", {
        schema: {
            body: {
                type: 'object',
                required: ['filename', 'filesize', 'UserId'],
                properties: {
                    filename: { type: 'string' },
                    filesize: { type: 'integer' },
                    UserId: { type: 'integer' },
                    downloads: { type: 'integer' }
                }
            }
        }
    }, async (request, reply) => {

        if(!request.body.downloads){
            request.body.downloads = 0;
        }

        const file = await File.create(request.body);
        reply.status(201).send(file);
    });

    //8. feladat
    fastify.patch("/files/:id", {
        schema: {
            params: {
                type: 'object',
                properties: {
                    id: {
                        type: 'integer',
                    }
                }
            },
            body: {
                type: 'object',
                properties: {
                    filename: { type: 'string' },
                    filesize: { type: 'integer' },
                    downloads: { type: 'integer' }
                }
            }
        }
    },  async (request, reply) => {
        const id = request.params.id;
        //TODO: reply 500?? 0.25 pont
        if (!id) {
            return reply.status(400).send();
        }
        
        const file = await File.findByPk(id);
        if (!file) {
            return reply.status(404).send();
        }

        await file.update(request.body);
    
        reply.send(file);
    });

    //9. feladat
    fastify.post("/login", {
        schema: {
            body: S.object().prop('email', S.string().format(S.FORMATS.EMAIL).required())
        }
    }, async (request, reply) => {
        const { email } = request.body;

        const user = await User.findOne({
            where: {
                email,
            }
        });


        if (!user) {
            return reply.status(404).send();
        }

        const token = fastify.jwt.sign(user.toJSON());

        reply.send({ token })
    });

    //10. feladat
    fastify.get("/my-files", { onRequest: [fastify.auth] }, async (request, reply) => {
        const user = await User.findByPk(request.user.id);
        const files = await user.getFiles();



        const result = [];

        //TODO:  A fájlokhoz hozzá vannak rendelve a megosztások (1 pont)
        for (const file of files) {
            const Shares = await file.getShares({
                attributes: { exclude: ['FileShare'] }
            });
            

            result.push({...file.dataValues, Shares});
        }

        reply.send(result);
    });

    //11. feladat
    fastify.get("/users", { onRequest: [fastify.auth], }, async (request, reply) => {
        const users = await User.findAll();
        const result = []
    
        for (const user of users) {
            const fileCount = await user.countFiles();
            let totalFileSize = 0;

            const files = await user.getFiles();
            for (const file of files) {
                totalFileSize += file.filesize;
            }

            //TODO: Ordering: 1.25 pont
            result.push({...user.dataValues, fileCount, totalFileSize});
        }

        reply.send(result);
    });

    // //12. feladat
    // fastify.post("/new-share", { 
    //     onRequest: [fastify.auth],
    //     schema: {
    //         body: {
    //                 type: 'object',
    //                 required: ['isEditable', 'fileIds'],
    //                 properties: {
    //                     isEditable: {
    //                         type: 'boolean'
    //                     },
    //                     fileIds: {
    //                         type: 'array',
    //                     }
    //                 }

    //             }
    //     }
    //  }, { onRequest: [fastify.auth] }, async (request, reply) => {
    
    //     reply.send("Sample response");
    // });

    // http://127.0.0.1:4000/auth-protected
    fastify.get("/auth-protected", { onRequest: [fastify.auth] }, async (request, reply) => {
        reply.send({ user: request.user });
    });

    next();
};

module.exports.autoPrefix = "/";
