'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Share extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      Share.belongsToMany(models.File, {
        through: "FileShare"
      });
    }
  }
  Share.init({
    link: DataTypes.STRING,
    isEditable: DataTypes.BOOLEAN
  }, {
    sequelize,
    modelName: 'Share',
  });
  return Share;
};