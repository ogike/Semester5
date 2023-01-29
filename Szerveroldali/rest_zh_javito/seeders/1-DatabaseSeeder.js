"use strict";

// Faker dokumentáció, API referencia: https://fakerjs.dev/guide/#node-js
const { faker } = require("@faker-js/faker");
const chalk = require("chalk");
const { File, Share, User } = require("../models");

module.exports = {
    up: async (queryInterface, Sequelize) => {
        try {
            const files = [];

            //Userek
            const usersCount = faker.datatype.number({
                min: 5,
                max: 10,
            });

            for (let i = 0; i < usersCount; i++) {
                const realname = (Math.random() < 0.6) ? 
                                        faker.name.fullName() :
                                        null;

                const user = await User.create({
                    email: `user${i+1}@szerveroldali.hu`,
                    realname,
                    isPremium: Math.random() < 0.3
                });


                //Fileok
                const fileCount = faker.datatype.number({
                    min: 0,
                    max: 5,
                });
                for (let j = 0; j < fileCount; j++) {
                    const file = await user.createFile({
                        filename: faker.lorem.word(),
                        filesize: faker.datatype.number({
                            min: 150,
                            max: 15000,
                        }),
                        downloads: faker.datatype.number({
                            min: 1,
                            max: 5000,
                        })
                    });

                    files.push(file);
                }
            }

            //Shares
            const shareCount = faker.datatype.number({
                min: 10,
                max: 20,
            });

            for (let i = 0; i < shareCount; i++) {
                const share = await Share.create({
                    link: `https://esku-google-drive-teso.hu/${i}`,
                    isEditable: Math.random() < 0.5
                });
                
                await share.setFiles(
                    faker.helpers.arrayElements(files)
                );
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
