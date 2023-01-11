"use strict";

// Faker dokumentáció, API referencia: https://fakerjs.dev/guide/#node-js
const { faker } = require("@faker-js/faker");
const chalk = require("chalk");
const { Order, Product, User } = require("../models");
const user = require("../models/user");

module.exports = {
    up: async (queryInterface, Sequelize) => {
        try {
            const products = [];

            //Products
            const productCount = faker.datatype.number({
                min: 10,
                max: 15,
            });

            for (let i = 0; i < productCount; i++) {
                const description = (Math.random() < 0.6) ? 
                                        faker.lorem.sentence() :
                                        null;
                products.push(
                    await Product.create({
                        name: faker.lorem.word(),
                        description,
                        price: faker.datatype.number({
                            min: 1000,
                            max: 9999,
                        }),
                        count: faker.datatype.number({
                            min: 1,
                            max: 10,
                        })
                    })
                )
            }

            // Userek
            const usersCount = faker.datatype.number({
                min: 5,
                max: 10,
            });

            for (let i = 0; i < usersCount; i++) {
                const user = await User.create({
                    email: `user${i+1}@szerveroldali.hu`,
                    isWorker: Math.random() < 0.3
                });

                const orderCount = faker.datatype.number({
                    min: 5,
                    max: 10,
                });
                for (let j = 0; j < orderCount; j++) {
                    //Orderek
                    const order = await user.createOrder({
                        address: faker.address.streetAddress(),
                        shipped: Math.random() < 0.3
                    })
                    
                    await order.setProducts(
                        faker.helpers.arrayElements(products)
                    )
                }
            }

            console.log(chalk.green("A DatabaseSeeder lefutott"));
        } catch (e) {
            // Ha a seederben valamilyen hiba van, akkor alapértelmezés szerint elég szegényesen írja
            // ki azokat a rendszer a seeder futtatásakor. Ezért ez Neked egy segítség, hogy láthasd a
            // hiba részletes kiírását.
            // Így ha valamit elrontasz a seederben, azt könnyebben tudod debug-olni.
            console.log(chalk.red("A DatabaseSeeder nem futott le teljesen, mivel az alábbi hiba történt:"));
            console.log(chalk.gray(e));
        }
    },

    // Erre alapvetően nincs szükséged, mivel a parancsok úgy vannak felépítve,
    // hogy tiszta adatbázist generálnak, vagyis a korábbi adatok enélkül is elvesznek
    down: async (queryInterface, Sequelize) => {},
};
