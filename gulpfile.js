const gulp = require('gulp');
const markdown = require('gulp-markdown');
const del = require('del');
const breakdance = require('gulp-breakdance');
const hammerdown = require('gulp-hammerdown');

// 1. 执行 sh initTree.sh 生成目录文件.html

// 删除readme
gulp.task('clean:readme', () => {
	del('./README.md');
});

// 将html转化为md文件
gulp.task('html:=>md', () =>
	gulp.src('README.html')
	.pipe(hammerdown())
	.pipe(gulp.dest('./'))
);


// 将md转换为html
// gulp.task('Readme', () =>
// 	gulp.src('*.md')
// 		.pipe(markdown())
// 		.pipe(gulp.dest('dist'))
// );

gulp.task('default', [ 'clean:readme', 'html:=>md' ]);