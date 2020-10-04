#!/bin/sh

if [ $# = 0 ]; then
    echo "Params should be provided"
    echo "Available params: "
    echo "--DevToAcc -> Creates a develop sub-branch and merges it into an acceptance sub-branch"
    echo "--AccToMaster -> Creates a acceptance sub-branch and merges it into a master sub-branch" 
    echo "--push -> Pushes the branch to origin"
    echo "--noStash -> Skip stashing changes in the workspace DATA LOSS MAY HAPPEN"
    exit 1
fi

MERGE=""
PUSH=0
TMPBRANCH=""
STASH=1

for arg in "$@"
do
    case $arg in 
        "--DevToAcc" | "--AccToMaster")
            MERGE=$arg
        ;;
        "--push")
            PUSH=1
        ;;
        "--noStash")
            STASH=0
        ;;
    esac
done

CURRENTBRANCH=$(git branch --show-current)

if [ $STASH -eq 1 ]; then
    echo "Saving current workspace"
    git stash #Stage current changes
fi

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
    git push -u origin $TMPBRANCH
fi

git checkout $CURRENTBRANCH #Return to initial branch

if [ $STASH -eq 1 ]; then    
    echo "Restoring workspace"
    git stash pop #and apply stashed changes
fi
