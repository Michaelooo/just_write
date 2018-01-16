const gulp = require('gulp');
const del = require('del');
const hammerdown = require('gulp-hammerdown');
// const breakdance = require('gulp-breakdance');
// const markdown = require('gulp-markdown');

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

// 删除Readme.html文件
gulp.task('clean:readme.html', ['html:=>md'], () =>
	del('./README.html')
);

// 'clean:readme.html'
gulp.task('default', [ 'clean:readme', 'html:=>md', 'clean:readme.html' ]);