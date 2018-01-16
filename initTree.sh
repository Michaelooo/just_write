author='michael'

echo '=========================='
echo '初始化生成ReadMe'

if [ "$SHELL" = "/bin/sh" ];then
echo "your login shell is the bash \n"
echo "SHELL is : $SHELL"
echo '=========================='

tree -I node_modules -L 2
elif [ "$autor" = "michael" ];then
echo "不能执行"
fi

#[ -f "somefile" ] : 判断是否是一个文件
#[ -x "/bin/ls" ] : 判断/bin/ls是否存在并有可执行权限
#{ -n "$var" } : 判断$var变量是否有值
#[ "&a" = "$b" ] : 判断$a和$b是否相等