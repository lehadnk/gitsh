 #!/bin/bash

declare -A paths
declare -A groups

#======================
# Config starts
#======================
directory='/home/lehadnk/'
paths=(
	[myproj]='myproject/source/' 
	[myproj_lib]='myproject/source/vendors/company/mylib/' 
	[awsmprj]='myawesomeproject/' 
)
groups=(
	[mygroup]='myproj myproj_lib'
)
#======================
# Config ends
#======================

commitFunction() {
	changes=$(git status -s)

	if [[ -z $changes ]]
		then echo "No changes made in this branch!"
		return
	fi

	clear
	echo "Good day commander!"
	echo "Path $1..."
	echo "Fetching tags..."
	git fetch --tags
	echo "Last known tag is:"
	git describe --abbrev=0 --tags

	read -p "Please enter new tag:" tag
	read -p "Enter commit description:" commit
	read -p "Enter hotfix description (or just hit enter to make it same as commit description):" tagmsg
	if [[ -z $tagmsg ]] 
		then tagmsg="$commit"
	fi

	modified=$(git ls-files -m)

	if [[ -n $modified ]]
		then
			echo "Stashing changes..."
			#git stash
	fi

	echo "Updating branches..."
	#git pull --all

	echo "Making a hotfix branch..."
	#git flow hotfix start $tag
	echo "Staging..."
	if [[ -n $modified ]]
		then
			echo "Stashing changes..."
			#git stash pop
	fi
	#git add .

	echo "Making commit..."
	#git commit -m "$commit"
	#git flow hotfix finish -m "$tagmsg" $tag

	if $push ;
		then echo "Pushing changes to server..."
		#git push
		#git push --tags
	fi
}

pullFunction() {
	path=$1

	echo "Path $path..."

	modified=$(git ls-files -m)

	if [[ -n $modified ]]
		then
			echo "Some files is modified, stashing changes..."
			git stash
	fi

	git pull --all

	if [[ -n $modified ]]
		then
			echo "Popping the stashed changes out..."
			git stash pop
	fi
}

helpFunction() {
	echo "Git bash tool r4 by lehadnk"
	echo ""
	echo "Available arguments:"
	echo "-c Makes a gitflow hotfix from a changes in this branch"
	echo "-u Updates all branches listed in the config of this script or in selected project group (see -g)"
	echo "-p Pushes commit and tag data to repo after making a hotfix"
	echo "-j Sets a project to work with. Current directory will be used by default"
	echo "-g Sets a project group to work with"
}

addToQueue() {
	project="$1";

	if [[ -z "${paths[${project}]}" ]]
		then echo "Unknown project: $project!"
		exit
	fi

	queue+=($directory${paths[$project]})
}

setProject() {
	project="$1"

	if [[ -z "${paths[${project}]}" ]]
		then echo "Unknown project: $project!"
		exit
	fi

	echo "Opening project $project..."
	addToQueue "$project";
}

setGroup() {
	group="$1"

	if [[ -z "${groups[${group}]}" ]]
		then echo "Unknown group: $group!"
		exit
	fi

	echo "Opening project group $group..."

	group=("${groups[${group}]}")
	for g in $group; do
		addToQueue "$g";
	done
}

addEveryDir() {
	for p in ${paths[*]}; do
			queue+=($directory$p)
	done
}

prepareQueue() {
	if [[ -z "$queue" ]]
		then
			case "$mode" in
				pull)
					addEveryDir;
					;;
				*)
					queue=('.')
					;;
			esac
	fi
}

mainFunction() {
	# Reset in case getopts has been used previously in the shell.
	OPTIND=1

	# Default values 
	push=false
	mode=help
	queue=()

	while getopts "pcuj:g:" opt; do
		case "$opt" in
			p)
				push=true
				;;
			c)
				mode=commit
				;;
			u)	
				mode=pull
				;;
			j)
				setProject "$OPTARG";
				;;
			g)
				setGroup "$OPTARG";
				;;
		esac
	done

	prepareQueue;

	for p in ${queue[*]}; do
		cd $p
		case "$mode" in
			commit)
				commitFunction "$p";
				;;
			pull)
				pullFunction "$p";
				;;
			*)
				helpFunction;
				exit
				;;
		esac
	done
}

mainFunction "$@";
