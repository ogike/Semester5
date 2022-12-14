const { StatusCodes } = require("http-status-codes");
const S = require('fluent-json-schema');
const { Sequelize, sequelize, Product, User, Order  } = require("../models");
const { array } = require("superstruct");
const { eq } = require("lodash");
const { ValidationError, DatabaseError, Op } = Sequelize;

module.exports = function (fastify, opts, next) {
    // http://127.0.0.1:4000/
    // feladat 3
    fastify.get("/products", async (request, reply) => {
        reply.send( await Product.findAll());
    });


    // feladat 4
    fastify.get("/products/:id", async (request, reply) => {
        const { id } = request.params;
        const product = await Product.findByPk(id);

        //TODO: check for error 400
        if (!product) {
            return reply.status(404).send();
        }

        reply.send(product);
    });


    // feladat 5
    fastify.post("/products", {
        schema: {
            body: {
                    type: 'object',
                    properties: {
                        description: {
                            type: 'string',
                            nullable: true
                        }
                    }
                }
        }
    }, async (request, reply) => {
        if(!request.body.description){
            request.body.description = null;
        }

        //TODO: redownload patched tester from canvas
        //TODO: test 400
        const product = await Product.create(request.body);

        reply.status(201).send(product);
    });

    // feladat 6
    fastify.patch("/products/:id", async (request, reply) => {
        const { id } = request.params;
        const product = await Product.findByPk(id);

        //TODO: check for error 400
        if (!product) {
            return reply.status(404).send();
        }

        await product.update(request.body);

        reply.send(product);
    });


    // feladat 7
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


    // feladat 8
    fastify.get("/my-orders", { onRequest: [fastify.auth] }, async (request, reply) => {

        const user = await User.findByPk(request.user.id);
        reply.send(await user.getOrders());
    });


    // feladat 9
    fastify.get("/my-orders/products", { onRequest: [fastify.auth] }, async (request, reply) => {
        const user = await User.findByPk(request.user.id);
        const orders = await user.getOrders();


        const ordersWithProducts = await getProductsForOrders(orders);

        reply.send( ordersWithProducts );
    });


    //feladat 10
    fastify.post("/my-orders", {
        onRequest: [fastify.auth],
        schema: {
            body: {
                type: 'object',
                required: ['products', 'address'],
                properties: {
                    address: {
                        type: 'string'
                    },
                    products: {
                        type: 'array'
                    }
                }
            }
        }
    }, async (request, reply) => {
        const user = await User.findByPk(request.user.id);

        const order = await Order.create({
            address: request.body.address,
            UserId: request.user.id,
            shipped: false
            // address: request.body.address
        });

        const invalidProducts = [], orderedProducts = [];

        for (const id of request.body.products) {
            const product = await Product.findByPk(id);

            if (!product) {
                invalidProducts.push(id);
            } else {
                orderedProducts.push(id);
            }
        }

        await order.addProducts(orderedProducts);

        reply.status(201).send({
            ...order.toJSON(),
            invalidProducts,
            orderedProducts
        });

    });


    //feladat 11
    fastify.post("/pack-order/:id", {
        onRequest: [fastify.auth],
    }, async (request, reply) => {
        const user = await User.findByPk(request.user.id);

        if(!user.isWorker){
            return reply.status(403).send();
        }

        const order = await Order.findByPk(request.params.id);

        const options = {joinTableAttributes: []};
        const products = await order.getProducts(options);

        const missingProducts = [], packedProducts = [];

        for (const product of products){
            const cnt = product.count;

            if(cnt >= 1){
                packedProducts.push(product.id);
                await product.update({count: cnt-1});
            } else{
                missingProducts.push(product.id);
            }
        }

        reply.send({missingProducts, packedProducts});

    });


    //feladat 12
    fastify.post("/ship-orders", {
        onRequest: [fastify.auth],
        schema: {
            body: S.object().prop('orders', S.array().required())
        }
    }, async (request, reply) => {
        const user = await User.findByPk(request.user.id);

        if(!user.isWorker){
            return reply.status(403).send();
        }

        const invalidOrder = [], alreadyShipped = [], justShipped = [];

        for(const orderId of request.body.orders){
            const order = await Order.findByPk(orderId);
            console.log(order);

            if(!order){
                invalidOrder.push(orderId);
            }
            else if(order.shipped){
                alreadyShipped.push(orderId);
            } else{
                justShipped.push(orderId);
                await order.update({shipped: true});
            }
        }

        reply.send({invalidOrder, alreadyShipped, justShipped});

    });

    // http://127.0.0.1:4000/auth-protected
    fastify.get("/auth-protected", { onRequest: [fastify.auth] }, async (request, reply) => {
        reply.send({ user: request.user });
    });

    fastify.addHook('onError', async (request, reply, error) => {
        // Ha valamilyen Sequelize-os validációs hiba történt, akkor rossz volt a request
        if (error instanceof ValidationError || error instanceof DatabaseError) {
            reply.status(400).send();
        }
    })

    next();
};

async function getProductsForOrders (orders) {
    const ordersWithProducts = [];
    const options = {
        joinTableAttributes: [],
    };

    for(const order of orders){
        const products = await order.getProducts(options);
        const orderJSON = order.toJSON();
        orderJSON.Products = products;

        ordersWithProducts.push(orderJSON);
    }

    // orders.map(order => {
    //     const products = await order.getProducts(options);
    //     order = order.toJSON();
    //     order.products = products;

    //     ordersWithProducts.push(order);
    // });

    return ordersWithProducts;
  }

module.exports.autoPrefix = "/";
