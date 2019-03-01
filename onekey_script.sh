#!/bin/bash
#admin:spirits

#***********CPU检测*************
echo "$(date '+%Y年%m月%d日 %H:%M:%S') 数据库服务器硬件情况开始巡检。。。"

top -bn 6 >>top

grep -n "%id" top >> newtop

grep -n "zombie" top >> insisttop

top1=`cat  newtop   | awk '{print $5}' | sed -n 4p | sed 's/%//g' |sed 's/id,//g'`
top2=`cat  newtop   | awk '{print $5}' | sed -n 5p | sed 's/%//g' |sed 's/id,//g'`
top3=`cat  newtop   | awk '{print $5}' | sed -n 6p | sed 's/%//g' |sed 's/id,//g'`
top4=`cat insisttop | awk '{print $10}'| sed -n 2p | sed 's/%//g' |sed 's/id,//g'`

#echo "top4:$top4"

if [ $top4 -gt 0 ]

then 
    echo "`date '+%Y年%m月%d日 %H:%M:%S'` 采集处理服务器上出现僵尸进程，巡检程序将自动kill该进程，如需人工确认请执行命令top后再执行ps -A -ostat,ppid,pid,cmd | grep -e '^[Zz]'来确认是否将僵尸进程杀死"  >> ./newreport.txt

    ps -A -o stat,ppid,pid,cmd | grep -e '^[Zz]' | awk '{print $2}' | xargs kill -9

else 
    echo "`date '+%Y年%m月%d日 %H:%M:%S'` 采集处理服务器上无僵尸进程正常运行！"
fi

a=${top1:0:2}
b=${top2:0:2}
c=${top3:0:2}

echo "top1: $a"
echo "top2: $b"
echo "top3: $c"


 if [  $a    -lt  20  ]&&[  $b    -lt  20  ]&&[  $c    -lt  20  ]    ; then

    echo  "`date '+%Y年%m月%d日 %H:%M:%S'` 数据库服务器CPU占用率不正常，top取到的值是$top1,$top2,$top3,小于参考值20，请及时处理！" >> ./newreport.txt

else

  echo "CPU占用率正常!" 

fi

rm -rf top

rm -rf newtop

rm -rf insisttop

#***************内存检测***********
free1=`free -g | awk '{print $4}' | sed -n 3p | sed 's/%//g' |sed 's/t//g'`

total=`free -g | awk '{print $2}' | sed -n 2p | sed 's/%//g' |sed 's/t//g'`

canshu=0.2

tempd=`echo $total $canshu |awk '{print $1*$2}'`

biaozhun=${tempd%.*}

if [ $free1  -le  $biaozhun  ]  ;  then 
echo "`date '+%Y年%m月%d日 %H:%M:%S'`  数据库服务器内存占用率过高，free -g取到的值是$free1,小于等于参考值$biaozhun，请及时处理！" >> ./newreport.txt

else

echo "内存占用率正常！"

fi

#**************文件系统巡检**********
df1=`df -h | awk '{print $5}' | sed -n 2p | sed 's/%//g'`
df2=`df -h | awk '{print $5}' | sed -n 3p | sed 's/%//g'`
df3=`df -h | awk '{print $5}' | sed -n 4p | sed 's/%//g'`
df4=`df -h | awk '{print $5}' | sed -n 5p | sed 's/%//g'`
df5=`df -h | awk '{print $5}' | sed -n 6p | sed 's/%//g'`

 if [ $df1 -gt  90 ]||[ $df2  -gt  90 ]||[ $df3 -gt  90 ]||[ $df4 -gt  90 ]||[ $df5 -gt  90 ] ; then

    echo "`date '+%Y年%m月%d日 %H:%M:%S'` 数据库服务器磁盘占用率过高！df -h取到的值是$df1,$df2,$df3,$df4,$df5,参考值是90，若其中一个或一个以上大于参考值，请及时处理！" >> ./newreport.txt

else

    echo "磁盘占用率正常！"

fi

#*********************磁盘IO性能巡检***************
iostat -x 2 5 >>iostat.txt

scvtm1=" `cat  iostat.txt  | awk '{print $11}' | sed -n 16p | sed 's/%//g' `"

scvtm2="` cat  iostat.txt  | awk '{print $11}' | sed -n 17p | sed 's/%//g'`"

scvtm3="` cat  iostat.txt  | awk '{print $11}' | sed -n 18p | sed 's/%//g'`"

scvtm4="` cat  iostat.txt  | awk '{print $11}' | sed -n 19p | sed 's/%//g'`"

scvtm13="` cat  iostat.txt  | awk '{print $11}' | sed -n 25p | sed 's/%//g'`"

scvtm6=" `cat  iostat.txt  | awk '{print $11}' | sed -n 26p | sed 's/%//g' `"

scvtm7="` cat  iostat.txt  | awk '{print $11}' | sed -n 27p | sed 's/%//g'`"

scvtm8="` cat  iostat.txt  | awk '{print $11}' | sed -n 28p | sed 's/%//g'`"

scvtm9="` cat  iostat.txt  | awk '{print $11}' | sed -n 34p | sed 's/%//g'`"

scvtm10="` cat  iostat.txt  | awk '{print $11}' | sed -n 35p | sed 's/%//g'`"

scvtm11="` cat  iostat.txt  | awk '{print $11}' | sed -n 36p | sed 's/%//g'`"

scvtm12="` cat  iostat.txt  | awk '{print $11}' | sed -n 37p | sed 's/%//g'`"



util1="`cat  iostat.txt  | awk '{print $12}' | sed -n 16p | sed 's/%//g'`"

util2="` cat  iostat.txt  | awk '{print $12}' | sed -n 17p | sed 's/%//g'`"

util3="` cat  iostat.txt  | awk '{print $12}' | sed -n 18p | sed 's/%//g'`"

util4="` cat  iostat.txt  | awk '{print $12}' | sed -n 19p | sed 's/%//g'`"

util5="` cat  iostat.txt  | awk '{print $12}' | sed -n 25p | sed 's/%//g'`"

util6=" `cat  iostat.txt  | awk '{print $12}' | sed -n 26p | sed 's/%//g' `"

util7="` cat  iostat.txt  | awk '{print $12}' | sed -n 27p | sed 's/%//g'`"

util8="` cat  iostat.txt  | awk '{print $12}' | sed -n 28p | sed 's/%//g'`"

util9="` cat  iostat.txt  | awk '{print $12}' | sed -n 34p | sed 's/%//g'`"

util10="` cat  iostat.txt  | awk '{print $12}' | sed -n 35p | sed 's/%//g'`"

util11="` cat  iostat.txt  | awk '{print $12}' | sed -n 36p | sed 's/%//g'`"

util12="` cat  iostat.txt  | awk '{print $12}' | sed -n 37p | sed 's/%//g'`"

#***********1/2/3/4****************

maxa=`echo "$scvtm1 $scvtm2 $scvtm3 $scvtm4" | awk '{for(i=1;i<=NF;i++)$i>a?a=$i:a}END{print a}'`

#*************13/6/7/8/**************

maxb=`echo "$scvtm13 $scvtm6 $scvtm7 $scvtm8" | awk '{for(i=1;i<=NF;i++)$i>a?a=$i:a}END{print a}'`

#*************************9/10/11/12******************

maxc=`echo "$scvtm9 $scvtm10 $scvtm11 $scvtm12" | awk '{for(i=1;i<=NF;i++)$i>a?a=$i:a}END{print a}'`

#********************util1/2/3/4**********************

maxd=`echo "$util1 $util2 $util3 $util4" | awk '{for(i=1;i<=NF;i++)$i>a?a=$i:a}END{print a}'`


#**********************util5/6/7/8*******************

maxe=`echo "$util5 $util6 $util7 $util8" | awk '{for(i=1;i<=NF;i++)$i>a?a=$i:a}END{print a}'`

#***********************util9/10/11/12***************

maxf=`echo "$util9 $util10 $util11 $util12" | awk '{for(i=1;i<=NF;i++)$i>a?a=$i:a}END{print a}'`

#******************做判断************************
m=${maxa:0:1}

n=${maxb:0:1}

h=${maxc:0:1}

k=${maxd:0:1}

l=${maxe:0:1}

o=${maxf:0:1}


if [  $m -ge 15 ]&&[ $k -ge 99 ]&&[ $k -lt 100 ]$$[  $n -ge 15 ]&&[ $l -ge  99 ]&&[ $l -lt 100 ]&&[  $h -ge 15]&&[ $o -ge 99 ]&&[ $o -lt 100 ]

then

    echo "`date '+%Y年%m月%d日 %H:%M:%S'`  数据库服务器磁盘IO存在瓶颈，请及时处理！" >> ./newreport.txt

else

   echo "磁盘IO正常！"

fi

rm -rf ./iostat.txt

#*********************************网络连通性检测**********************

network1=`ping -s 4096 -c 5  135.0.51.15 | awk '{print $6}' | sed -n 9p | sed 's/%//g' |sed 's/t//g'`

if [ $network1 -gt 0 ]

then 

   echo "`date '+%Y年%m月%d日 %H:%M:%S'` 数据库服务器到该目标IP之间的网络不稳定，ping取到的值是$network1,大于参考值是0，系统存在风险，请及时处理！"  >> ./newreport.txt

else 

   echo "网络连通性正常！"

fi

echo "`date '+%Y年%m月%d日 %H:%M:%S'` 数据库服务器硬件情况巡检结束！"