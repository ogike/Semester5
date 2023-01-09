'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        await queryInterface.createTable('Students', {
            id: {
                allowNull: false,
                autoIncrement: true,
                primaryKey: true,
                type: Sequelize.INTEGER
            },
            neptun: {
                allowNull: false,
                unique: true,
                type: Sequelize.STRING
            },
            name: {
                allowNull: false,
                type: Sequelize.STRING
            },
            birthdate: {
                allowNull: false,
                type: Sequelize.DATE
            },
            birthplace: {
                allowNull: false,
                type: Sequelize.STRING
            },
            semester: {
                allowNull: false,
                defaultValue: 1,
                type: Sequelize.INTEGER
            },
            active: {
                allowNull: false,
                defaultValue: false,
                type: Sequelize.BOOLEAN
            },
            createdAt: {
                allowNull: false,
                type: Sequelize.DATE
            },
            updatedAt: {
                allowNull: false,
                type: Sequelize.DATE
            }
        });
    },
    async down(queryInterface, Sequelize) {
        await queryInterface.dropTable('Students');
    }
};