const auth = require("./auth");
const db = require("../models");
const { random, orderBy, upperFirst } = require("lodash");
const { Sequelize, sequelize } = db;
const { ValidationError, DatabaseError, Op } = Sequelize;
const { Student, Exam, Task } = db;

function getGrade(percentage) {
    if (percentage < 40)   return 1;
    if (percentage < 55)   return 2; 
    if (percentage < 70)   return 3; 
    if (percentage < 85)   return 4;
    return 5;
} 

module.exports = {
    Query: {
        // Elemi Hello World! példa:
        helloWorld: () => "Hello World!",

        // Példa paraméterezésre:
        helloName: (_, { name }) => `Hello ${name}!`,

        //1. feladat
        grade: () => random(1,5, false),

        //2. feladat
        grades: (_, {count}) => {
            const grades = [];
            for (let index = 0; index < count; index++) {
                grades.push(random(1,5, false));
            }
            return grades;
        },

        //3. feladat
        gradesFrom: (_, {percentages}) => {
            const grades = [];
            percentages.forEach(percentage => {
                grades.push(getGrade(percentage))
            });
            
            return grades;
        },

        //4. 
        students: async () =>   await Student.findAll(),
        exams: async () =>      await Exam.findAll(),

        //5.
        exam: async (_, {id}) => await Exam.findByPk(id),

        //6.
        studentByNeptun: async(_, {neptun : kod}) => await Student.findOne({ where: {neptun: kod}}),

        //11.
        closestExam: async() => {
            const exam = await Exam.findOne({
                where: {
                    startTime: {[Op.gt]: new Date()}
                },
                order: [
                    ['startTime', 'ASC'] //fordított sorrend
                ]
            })
            return exam;
        },

        //13
        mostBusyStudent: async() => {
            const students = await Student.findAll();
            let result = null;
            let maxExamCount = 0;

            for (const student of students){
                const curExamCount = await student.countExams();

                if(!result){
                    result = student;
                    maxExamCount = curExamCount;
                    continue;
                }
                
                if(curExamCount > maxExamCount){
                    result = student;
                    maxExamCount = curExamCount;
                }
            }

            return result;
        }
    },

    //7.
    Student: {
        exams: async (parent) => await parent.getExams(),
    },
    Exam: {
        tasks: async (parent) => await parent.getTasks(),
        
        //9.
        studentCount: async (parent) => {
            const students = await parent.getStudents();
            return students.length
        },

        //10.
        maxScore: async (parent) => {
            const tasks = await parent.getTasks();
            score = 0;
            for(const task of tasks){
                if(!task.extra){
                    score += task.points;
                }
            }
            return score;
        },
        perfectScore: async (parent) => {
            const tasks = await parent.getTasks();
            score = 0;
            for(const task of tasks){
                score += task.points;
            }
            return score;
        }
    },

    Mutation: {
        //8. 
        createStudent: async (_, { input }) => await Student.create(input),

        //12.
        registerStudents: async (_, { students: studentCodes, ExamId }) => {
            const exam = await Exam.findByPk(ExamId);
            
            const invalidNeptun = [];
            const alreadyRegistered = [];
            const justRegistered = [];

            for(const studentCode of studentCodes){
                const student = await Student.findOne({ where: {neptun: studentCode}});
                if(!student){
                    invalidNeptun.push(studentCode);
                    continue;
                }

                // console.log(exam);
                const hasStudent = await exam.hasStudent(student);
                if(hasStudent){
                    alreadyRegistered.push(studentCode);
                } else{
                    await exam.addStudent(student);
                    justRegistered.push(studentCode);
                }
            }

            return { invalidNeptun, alreadyRegistered, justRegistered};
        },

        //14.
        removePassiveStudents: async(_) => {
            const students = await Student.findAll();

            const output = []; // {Student, [Exam]}

            for (const student of students) {
                if(!student.active){
                    const removedFromExams = await student.getExams();

                    for (const exam of removedFromExams) {
                        await exam.removeStudent(student);
                    }

                    output.push({student, removedFromExams});
                }
            }

            return output;
        }
    },

};
