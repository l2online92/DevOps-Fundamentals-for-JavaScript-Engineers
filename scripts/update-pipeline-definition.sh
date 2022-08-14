#!/bin/bash

defaultPipeline="pipeline"
customPipelineChoice="custom"

# colors
red=$'\e[1;31m'
grn=$'\e[1;32m'
end=$'\e[0m'

checkJQ() {
    # jq test
    type jq >/dev/null 2>&1
    exitCode=$?

    if [ "$exitCode" -ne 0 ]; then
        printf "  ${red}'jq' not found! (json parser)\n${end}"
        printf "    MacOS Installation:  https://jira.amway.com:8444/display/CLOUD/Configure+PowerShell+for+AWS+Automation#ConfigurePowerShellforAWSAutomation-MacOSSetupforBashScript\n"
        printf "    Ubuntu Installation: sudo apt install jq\n"
        printf "    Redhat Installation: sudo yum install jq\n"
        jqDependency=0
    else
        if [ "$DEBUG" -eq 1 ]; then
            printf "  ${grn}'jq' found!\n${end}"
        fi
    fi

    if [ "$jqDependency" -eq 0 ]; then
        printf "${red}Missing 'jq' dependency, exiting.\n${end}"
        exit 1
    fi
}

# perform checks:
checkJQ

echo -n "Enter a CodePipeline name (or $customPipelineChoice)(default: $defaultPipeline): "
read -r pipelineName

pipelineName=$(checkPipelineName "$pipelineName")

if [ "$pipelineName" = "$customPipelineChoice" ]; then
    echo -n "Enter a CodePipeline name: "
    read -r pipelineName
fi

defaultBranchName="develop"

echo -n "Enter a source branch to use (default: $defaultBranchName): "
read -r branchName
branchName=${branchName:-$defaultBranchName}

pipelineJson="pipeline.json"

# upd source branch
jq --arg branchName "$branchName" '.pipeline.stages[0].actions[0].configuration.BranchName = $branchName' "$pipelineJson" >tmp.$$.json && mv tmp.$$.json "$pipelineJson"
# remove metadata
jq 'del(.metadata)' "$pipelineJson" >tmp.$$.json && mv tmp.$$.json "$pipelineJson"

exit 0
