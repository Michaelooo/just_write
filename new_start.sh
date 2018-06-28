author='michael'
echo '=========================='
echo '初始化生成ReadMe'

if [ "$SHELL" = "/bin/zsh" -o "$SHELL" = "/bin/sh" ];then
echo "your login shell is the bash \n"
echo "SHELL is : $SHELL"
echo '=========================='

if [ -f "README.md" ];then
echo "删除旧md"
rm -rf README.md
echo "拷贝模板"
cp demo.md README.md
echo "生成目录"
tree -L 2 -N >> README.md
echo "success"
fi

elif [ "$autor" = "michael" ];then
echo "并不能执行"
fi

