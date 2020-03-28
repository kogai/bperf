const webpack = require("webpack");
const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const CleanWebpackPlugin = require("clean-webpack-plugin");

const output = path.resolve(__dirname, "public");

const { AUTH0_DOMAIN, AUTH0_CLIENT_ID, API_ROOT } = process.env;

module.exports = {
  entry: {
    beacon: "./beacon/agent.js",
    main: "./web/index.js"
  },
  module: {
    rules: [
      {
        test: /\.elm$/,
        loader: "elm-webpack-loader",
        exclude: [/elm-stuff/, /node_modules/],
        options: {}
      }
    ]
  },

  plugins: [
    new HtmlWebpackPlugin({ title: "bperf", template: "./web/index.html" }),
    new CleanWebpackPlugin(),
    new webpack.DefinePlugin({
      "process.env": {
        API_ROOT: JSON.stringify(API_ROOT),
        AUTH0_DOMAIN: JSON.stringify(AUTH0_DOMAIN),
        AUTH0_CLIENT_ID: JSON.stringify(AUTH0_CLIENT_ID)
      }
    })
  ],
  resolve: {
    extensions: [".js", ".elm"]
  },
  output: {
    filename: chunkData => {
      return chunkData.chunk.name === "beacon"
        ? "[name].js"
        : "[name].[chunkhash].js";
    },
    chunkFilename: "[name].[chunkhash].js",
    path: output,
    publicPath: "/"
  },
  devServer: {
    contentBase: output,
    historyApiFallback: true,
    port: 3000
  }
};
