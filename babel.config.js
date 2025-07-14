module.exports = function(api) {
  api.cache(true);
  
  return {
    presets: [],
    plugins: [
      [
        '@babel/plugin-transform-react-jsx',
        {
          runtime: 'automatic'  // This is key for modern React
        }
      ]
    ]
  };
};
