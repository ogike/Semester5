'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class File extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      File.belongsTo(models.User);
      File.belongsToMany(models.Share, {
        through: "FileShare"
      });
    }
  }
  File.init({
    filename: DataTypes.STRING,
    filesize: DataTypes.INTEGER,
    downloads: DataTypes.INTEGER,
    UserId: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'File',
  });
  return File;
};