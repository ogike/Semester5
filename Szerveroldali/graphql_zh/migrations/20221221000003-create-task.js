'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        await queryInterface.createTable('Tasks', {
            id: {
                allowNull: false,
                autoIncrement: true,
                primaryKey: true,
                type: Sequelize.INTEGER
            },
            ExamId: {
                type: Sequelize.INTEGER,
                allowNull: false,
                references: {
                    model: "Exams",
                    key: "id",
                },
                onDelete: "cascade"
            },
            title: {
                allowNull: false,
                type: Sequelize.STRING
            },
            text: {
                allowNull: false,
                type: Sequelize.STRING
            },
            points: {
                allowNull: false,
                type: Sequelize.FLOAT
            },
            extra: {
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
        await queryInterface.dropTable('Tasks');
    }
};