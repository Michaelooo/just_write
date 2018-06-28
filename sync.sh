# 同步内容到blog文件夹
!/bin/bash
author='michael'
echo "同步内容到blog文件夹"
from='.'
writePATH='../just_write/'
blogPath='../blog/'
draftPath='draft/'
postPath='./source/_posts/'

echo '=========================='
echo "读取文件路径： $1"

if [ ! -n $1 ];then
echo '不存在此文件，请输入完整的文件路径'
exit 1
else
echo '拿到文件名称不带后缀'
fileName=$(basename $1 .md)

echo '使用hexo生成文件'
cd $blogPath
hexo new $fileName

echo '拷贝文件至指定目录'

cat $writePATH$draftPath$fileName'.md' >> $postPath$fileName'.md'

echo '成功'

fi
