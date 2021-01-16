const { environment } = require('@rails/webpacker')

const webpack = require('webpack')

environment.plugins.prepend('Provide',
new webpack.ProvidePlugin({
  $: 'jquery/src/jquery',
  jQuery: 'jquery/src/jquery',
  DataTable: 'datatables.net-dt/js/dataTables.dataTables',
  Popper: ['popper.js', 'default'],

})
)

module.exports = environment
