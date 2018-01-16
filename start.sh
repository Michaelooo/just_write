author='michael'
cmd='tree -I node_modules -L 2 -f -H https://github.com/Michaelooo/just_write/blob/master -T 主要是个人日常的学习笔记，持续更新... -o 'README.html' -t'
echo '=========================='
echo '初始化生成ReadMe'

if [ "$SHELL" = "/bin/zsh" -o "$SHELL" = "/bin/sh" ];then
echo "your login shell is the bash \n"
echo "SHELL is : $SHELL"
echo '=========================='

$cmd

echo "success"
elif [ "$autor" = "michael" ];then
echo "并不能执行"
fi