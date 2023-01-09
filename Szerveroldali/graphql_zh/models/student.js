'use strict';
const {
    Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
    class Student extends Model {
        static associate(models) {
            this.belongsToMany(models.Exam, { through: 'ExamStudent' })
        }
    }
    Student.init({
        neptun: DataTypes.STRING,
        name: DataTypes.STRING,
        birthdate: DataTypes.DATE,
        birthplace: DataTypes.STRING,
        semester: DataTypes.INTEGER,
        active: DataTypes.BOOLEAN
    }, {
        sequelize,
        modelName: 'Student',
    });
    return Student;
};