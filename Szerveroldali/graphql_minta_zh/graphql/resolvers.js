const auth = require("./auth");
const db = require("../models");
const { Sequelize, sequelize } = db;
const { ValidationError, DatabaseError, Op } = Sequelize;
// TODO: Importáld a modelleket
const { Recipe, Ingredient, Appliance, Storage } = db;

module.exports = {
    Query: {
        recipes: async () => await Recipe.findAll(),
        ingredient: async (_, { id }) => await Ingredient.findByPk(id),

        smallestStorage: async () =>
            await Storage.findOne({
                order: [["capacity", "ASC"]],
            }),
    },

    Recipe: {
        ingredients: async (parent) => await parent.getIngredients(),
        appliance: async (parent) => await parent.getAppliance(),
    },

    Ingredient: {
        isInBigStorage: async (parent) => {
            const myStorage = await parent.getStorage();

            if (!myStorage) {
                throw new Error("Storage not found!");
            }

            if (myStorage.capacity <= 30) {
                return false;
            }
            return true;
        },
    },

    Storage: {
        ingredients: async (parent) => parent.getIngredients(),
    },

    Mutation: {
        updateIngredient: async (_, { ingredientId, input }) => {
            const ingredient = await Ingredient.findByPk(ingredientId);

            if (!ingredient) {
                throw new Error("Ingredient not found!");
            }

            await ingredient.update(input);

            return ingredient;
        },

        storeIngredients: async (_, { storageId, ingredients: inputs }) => {
            const storage = await Storage.findByPk(storageId);

            if (!storage) {
                throw new Error("Storage not found!");
            }

            const ingredients = [];
            for (const input of inputs) {
                console.log(input);
                ingredients.push(await Ingredient.create(input));
            }

            await storage.addIngredients(ingredients);

            const result = await storage.getIngredients();
            return result;
        },
    },
};
