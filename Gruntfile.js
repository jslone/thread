module.exports = function(grunt) {

  grunt.initConfig({
    inline: {
      dist: {
        src: ['src/index.html'],
        dest: ['build/']
      }
    }
  });

  grunt.loadNpmTasks('grunt-inline');

  grunt.registerTask('default',['inline:dist']);
}
