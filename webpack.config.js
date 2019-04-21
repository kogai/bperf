const webpack = require("webpack");
const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const CleanWebpackPlugin = require("clean-webpack-plugin");
const {
  default: createStyledComponentsTransformer
} = require("typescript-plugin-styled-components");

const output = path.resolve(__dirname, "public");
const styledComponentsTransformer = createStyledComponentsTransformer();

module.exports = {
  entry: {
    bperf: "./bperf/main.ts",
    main: "./client/main.tsx"
  },
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        loader: "ts-loader",
        exclude: /node_modules/,
        options: {
          getCustomTransformers: () => ({
            before: [styledComponentsTransformer]
          })
        }
      }
    ]
  },

  plugins: [
    new HtmlWebpackPlugin({ title: "bperf", template: "./client/index.html" }),
    new CleanWebpackPlugin()
  ],
  resolve: {
    extensions: [".tsx", ".ts", ".js"]
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
