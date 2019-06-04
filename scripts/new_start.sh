if [ "$SHELL" = "/bin/zsh" -o "$SHELL" = "/bin/sh" ];then
echo "your login shell is the bash \n"
echo "SHELL is : $SHELL"
echo '=========================='

author='michael'
CURDIR="`pwd`"/"`dirname $0`"
rm="`pwd`"/"README.md"
demo="`pwd`"/"`dirname $0`""/demo.md"

echo '=========================='
echo "初始化生成ReadMe $rm $demo"


if [ -f "$rm" ];then
echo "**** 删除旧md ****"
rm -rf $rm
if [ $? -ne 0 ]; then
    echo "删除旧md ❌";
    exit 1
else
    echo "删除旧md ✅"
fi

echo "**** 拷贝模板 ****"
cp "$demo" "$rm"
if [ $? -ne 0 ]; then
    echo "拷贝模板 ❌";
    exit 1
else
    echo "拷贝模板 ✅"
fi

echo "生成目录"
tree -L 2 -N >> $rm
if [ $? -ne 0 ]; then
    echo "生成目录 ❌";
    exit 1
else
    echo "完成 💐"
fi

fi

elif [ "$autor" = "michael" ];then
echo "并不能执行"
fi