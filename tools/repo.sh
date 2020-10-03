#!/bin/sh

if [ $# = 0 ]; then
    echo "Params should be provided"
    echo "Available params: "
    echo "--DevToAcc -> Creates a develop sub-branch and merges it into an acceptance sub-branch"
    echo "--AccToMaster -> Creates a acceptance sub-branch and merges it into a master sub-branch" 
    echo "--push -> Pushes the branch to origin"
    exit 1
fi

MERGE=""
PUSH=0
TMPBRANCH=""

for arg in "$@"
do
    case $arg in 
        "--DevToAcc" | "--AccToMaster")
            MERGE=$arg
        ;;
        "--push")
            PUSH=1
        ;;
    esac
done

echo "Saving current workspace"
CURRENTBRANCH=$(git branch --show-current)
echo $CURRENTBRANCH
git stash #Stage current changes

if [ "$MERGE" = "--DevToAcc" ]; then
    TMPBRANCH="tmpTesting"
    git checkout testing
    git checkout -b $TMPBRANCH
    git merge develop
fi

if [ "$MERGE" = "--AccToMaster" ]; then
    TMPBRANCH="tmpMaster"
    git checkout master
    git checkout -b $TMPBRANCH
    git merge testing
fi

if [ $PUSH -eq 1 ]; then 
    git push origin $TMPBRANCH
fi

git checkout $CURRENTBRANCH
git stash pop

#echo $OPTION