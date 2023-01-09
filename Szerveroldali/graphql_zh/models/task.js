'use strict';
const {
    Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
    class Task extends Model {
        static associate(models) {
            this.belongsTo(models.Exam)
        }
    }
    Task.init({
        ExamId: DataTypes.INTEGER,
        title: DataTypes.STRING,
        text: DataTypes.STRING,
        points: DataTypes.FLOAT,
        extra: DataTypes.BOOLEAN
    }, {
        sequelize,
        modelName: 'Task',
    });
    return Task;
};