const gulp = require('gulp');
const markdown = require('gulp-markdown');
const del = require('del');

gulp.task('dist:delete', () =>
	del('./dist')
);



// gulp.task('Readme', () =>
// 	gulp.src('*.md')
// 		.pipe(markdown())
// 		.pipe(gulp.dest('dist'))
// );