#!/bin/bash

SCRIPT_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
AWS_PROFILE="develop"

cfn_stack_name="cfn-$(date "+%Y%m%d%H%M")"

echo ">>>>>> Start cloudformation create-stack"

exit_stat=0
aws --profile="${AWS_PROFILE}" \
    cloudformation create-stack  \
        --stack-name "${cfn_stack_name}" \
        --template-body file://${SCRIPT_PATH}/vpc_template.yml || exit_stat=$?

if [ "${exit_stat}" -ne 0 ]; then
    echo >&2 ">>>>>> ERROR: CloudFormation has exited with non-zero status code"
    exit 1
fi

echo ">>>>>> Wait until cloudformation stack-create-complete"

exit_stat=0
aws --profile="${AWS_PROFILE}" \
    cloudformation wait stack-create-complete --stack-name "${cfn_stack_name}" || exit_stat=$?

if [ "${exit_stat}" -ne 0 ]; then
    echo >&2 ">>>>>> ERROR: Something went wrong while cloudformation wait stack-create-complete"
    exit 1
fi

echo ">>>>>> Done"
