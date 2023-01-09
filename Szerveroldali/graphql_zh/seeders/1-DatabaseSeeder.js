"use strict";

const { faker } = require("@faker-js/faker");
const chalk = require("chalk");
const { Student, Exam, Task} = require("../models");

function* nextTaskNumber() {
    let majorTaskCounter = 1;
    for (;;){
        let minorTaskCounter = 1;
        let minorTaskMaximum = Math.random() < 0.7 ? 1 : faker.datatype.number({ min: 2, max: 6 });
        while (minorTaskCounter <= minorTaskMaximum){
            yield `${majorTaskCounter}${minorTaskMaximum == 1 ? '' : '/' + String.fromCharCode(64 + minorTaskCounter)}. feladat`
            minorTaskCounter++
        }
        majorTaskCounter++
    }
} 

module.exports = {
    up: async (queryInterface, Sequelize) => {
        const students = []
        const studentCount = faker.datatype.number({ min: 10, max: 20 })
        for (let i = 0; i < studentCount; i++){
            students.push(await Student.create({
                neptun: faker.helpers.unique(() => faker.random.alphaNumeric(6, { casing: 'upper' })),
                name: faker.name.fullName(),
                birthdate: faker.date.birthdate({ min: 20, max: 60, mode: 'age' }),
                birthplace: faker.address.cityName(),
                semester: faker.datatype.number({ min: 1, max: 12 }),
                active: Math.random() < 0.7
            }))
        }

        const examCount = faker.datatype.number({ min: 5, max: 10 })
        for (let i = 0; i < examCount; i++){
            const startTime = faker.date.between('2022-12-01', '2023-02-10')
            startTime.setUTCHours(faker.datatype.number({min: 8, max: 16}), faker.helpers.arrayElement([0, 15, 30, 45]), 0, 0)
            const endTime = startTime.getTime() + faker.helpers.arrayElement([60, 90, 120, 180, 240])*60*1000
            
            const locationType = Math.random()
            let location = 'Online'
            if (locationType >= 0.4 && locationType <= 0.8)
                location = 'Déli Tömb ' + faker.datatype.number({min: 0, max: 7}) + '.' + faker.datatype.number({min: 100, max: 899})
            else if (locationType > 0.8)
                location = 'Északi Tömb ' + faker.datatype.number({min: 0, max: 7}) + '.' + faker.datatype.number({min: 10, max: 99})
            
            const exam = (await Exam.create({
                startTime, endTime, location,
                maxStudents: faker.datatype.number({ min: 2, max: 15 }) * 10
            }))

            const tasksOnExam = faker.datatype.number({ min: 5, max: 10 })
            const extraTasks = faker.datatype.number({ min: 1, max: tasksOnExam / 4 })
            const taskNumberGen = nextTaskNumber()
            for (let j = 0; j < tasksOnExam; j++){
                await Task.create({
                    ExamId: exam.id,
                    title: taskNumberGen.next().value,
                    text: faker.lorem.paragraph(),
                    points: faker.datatype.number( { min: 2, max: 20 }) / 2,
                    extra: j >= tasksOnExam - extraTasks
                })
            }

            await exam.setStudents(faker.helpers.arrayElements(students))
        }

        console.log(chalk.green("A DatabaseSeeder lefutott"));
    },

    // Erre alapvetően nincs szükséged, mivel a parancsok úgy vannak felépítve,
    // hogy tiszta adatbázist generálnak, vagyis a korábbi adatok enélkül is elvesznek
    down: async (queryInterface, Sequelize) => {},
};
