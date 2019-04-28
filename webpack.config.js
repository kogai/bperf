const webpack = require("webpack");
const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const CleanWebpackPlugin = require("clean-webpack-plugin");

const output = path.resolve(__dirname, "public");

const { AUTH0_DOMAIN, AUTH0_CLIENT_ID } = process.env;

module.exports = {
  entry: {
    beacon: "./beacon/main.js",
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
      "process.env.AUTH0_DOMAIN": JSON.stringify(AUTH0_DOMAIN),
      "process.env.AUTH0_CLIENT_ID": JSON.stringify(AUTH0_CLIENT_ID)
    })
  ],
  resolve: {
    extensions: [".js", ".elm"]
  },
  output: {
    filename: chunkData => {
      return chunkData.chunk.name === "bperf"
        ? "[name].js"
        : "[name].[chunkhash].js";
    },
    chunkFilename: "[name].[chunkhash].js",
    path: output
  },
  devServer: {
    contentBase: output,
    historyApiFallback: true,
    port: 3000
  },
  optimization: {
    splitChunks: {
      chunks: "all",
      maxInitialRequests: Infinity,
      minSize: 2 ** 16, // 64KiB
      cacheGroups: {
        vendors: {
          test: /[\\/]node_modules[\\/]/,
          name(module) {
            const packageName = module.context.match(
              /[\\/]node_modules[\\/](.*?)([\\/]|$)/
            )[1];
            return `vendor.${packageName.replace("@", "")}`;
          }
        }
      }
    }
  }
};
