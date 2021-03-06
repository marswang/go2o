#!/bin/bash

# 生成服务代码
# author : liuming
# data   : 2017-11-26 11:00

thrift_path="./core/service/thrift/idl/service.thrift"
go_target_path="./gen-code/thrift"
java_target_path="./tmp/java"
cs_target_path="./tmp/csharp"

cmd=$1

if [[ ${cmd} = "csharp" || ${cmd} = "all" ]];then
	rm -rf ${cs_target_path}/*
	thrift -r -gen csharp -out ${cs_target_path} ${thrift_path}
fi

if [[ ${cmd} == "java" || ${cmd} = "all" ]];then
	rm -rf ${java_target_path}/proto/*
	thrift -r -gen java -out ${java_target_path} ${thrift_path}
fi

#if [[ ${cmd} = "go" || ${cmd} = "all" ]];then
    mkdir -p ${go_target_path}
	rm -rf ${go_target_path}/*
	thrift -r -gen go -out ${go_target_path} ${thrift_path}
#fi

if [[ ${cmd} = "all" ]] || [[ ${cmd} = "format" ]];then

	if [ ! -f "${go_target_path}" ];then
   	  mkdir -p ${go_target_path}
	fi

	cd ${go_target_path}
	find ./ -name *.go |xargs sed -i \
		 's/"ttype"/"api\/gen-code\/thrift\/ttype"/g'
	find ./ -name *.go |xargs sed -i \
		 's/"\(.\{3,\}\)_service"/"api\/gen-code\/thrift\/\1_service"/g'

	cd - >/dev/null

fi
