import concat from 'rollup-plugin-concat';

const SOURCE_PATH = 'sources/javascripts';

export default [
  {
    input: `${SOURCE_PATH}/application.js`,
    output: {
      file: `${SOURCE_PATH}/temp.js`,
    },
    plugins: [
      concat({
        groupedFiles: [
          {
            files: [`${SOURCE_PATH}/libs/colorextract.js`, `${SOURCE_PATH}/application.js`],
            outputFile: `${SOURCE_PATH}/application.temp.js`,
          },
        ],
      }),
    ],
  },
  {
    input: `${SOURCE_PATH}/editmode.js`,
    output: {
      file: `${SOURCE_PATH}/temp.js`,
    },
    plugins: [
      concat({
        groupedFiles: [
          {
            files: [`${SOURCE_PATH}/editmode.js`],
            outputFile: `${SOURCE_PATH}/editmode.temp.js`,
          }
        ],
      }),
    ],
  }
]
