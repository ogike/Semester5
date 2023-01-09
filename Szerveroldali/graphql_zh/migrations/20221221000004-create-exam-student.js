"use strict";

module.exports = {
    up: async (queryInterface, Sequelize) => {
        await queryInterface.createTable("ExamStudent", {
            id: {
                allowNull: false,
                autoIncrement: true,
                primaryKey: true,
                type: Sequelize.INTEGER,
            },
            ExamId: {
                type: Sequelize.INTEGER,
                allowNull: false,
                references: {
                    model: "Exams",
                    key: "id",
                },
                onDelete: "cascade",
            },
            StudentId: {
                type: Sequelize.INTEGER,
                allowNull: false,
                references: {
                    model: "Students",
                    key: "id",
                },
                onDelete: "cascade",
            },
            createdAt: {
                allowNull: false,
                type: Sequelize.DATE,
            },
            updatedAt: {
                allowNull: false,
                type: Sequelize.DATE,
            },
        });
        await queryInterface.addConstraint("ExamStudent", {
            fields: ["ExamId", "StudentId"],
            type: "unique",
        });
    },
    down: async (queryInterface, Sequelize) => {
        await queryInterface.dropTable("ExamStudent");
    },
};