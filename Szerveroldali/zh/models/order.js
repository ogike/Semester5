'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Order extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      Order.belongsTo(model.User);
      Order.belongsToMany(model.Product, {
        through: "OrderProduct"
      });
    }
  }
  Order.init({
    address: DataTypes.STRING,
    UserId: DataTypes.INTEGER,
    shipped: DataTypes.BOOLEAN
  }, {
    sequelize,
    modelName: 'Order',
  });
  return Order;
};
