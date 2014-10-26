# credentials for mongodb
module.exports.prod =
  database: 'infinite'
  username: 'infinite'
  password: 'sm<hC3Jjz86&Q68'
  connection: 'dbh36.mongolab.com:27367'

module.exports.devel =
  database: 'devel'
  username: 'infinite'
  password: 'sm<hC3Jjz86&Q68'
  connection: 'ds047940.mongolab.com:47940'


module.exports.test =
  database: 'infinite'
  username: null
  password: null
  connection: 'localhost:12345'