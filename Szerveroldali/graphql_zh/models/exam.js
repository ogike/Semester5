'use strict';
const {
    Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
    class Exam extends Model {
        static associate(models) {
            this.hasMany(models.Task)
            this.belongsToMany(models.Student, { through: 'ExamStudent' })
        }
    }
    Exam.init({
        startTime: DataTypes.DATE,
        endTime: DataTypes.DATE,
        location: DataTypes.STRING,
        maxStudents: DataTypes.INTEGER
    }, {
        sequelize,
        modelName: 'Exam',
    });
    return Exam;
};