 #!/bin/bash

declare -A paths

#Config
directory='/home/lehadnk/'
paths=(
	[myproj]='myproject/source/' 
	[myproj_lib]='myproject/source/vendors/company/mylib/' 
	[awsmprj]='myawesomeproject/' 
)

commitFunction() {
	changes=$(git status -s)

	if [[ -z $changes ]]
		then echo "No changes made in this branch!"
		exit
	fi

	clear
	echo "Good day commander!"
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
			git stash
	fi

	echo "Updating branches..."
	git pull --all

	echo "Making a hotfix branch..."
	git flow hotfix start $tag
	echo "Staging..."
	if [[ -n $modified ]]
		then
			echo "Stashing changes..."
			git stash pop
	fi
	git add .

	echo "Making commit..."
	git commit -m "$commit"
	git flow hotfix finish -m "$tagmsg" $tag

	if $push ;
		then echo "Pushing changes to server..."
		git push
		git push --tags
	fi
}

pullFunction() {
	for item in ${paths[*]}
	do
		path="$directory$item"
		cd $path
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
	done
}

helpFunction() {
	echo "Git Shell r3 by lehadnk"
	echo ""
	echo "Available arguments:"
	echo "-c Makes a gitflow hotfix from a changes in this branch"
	echo "-u Updates all branches listed in the config of this script"
	echo "-p Pushes commit and tag data to repo after making a hotfix"
	echo "-j Sets a project to work with. Current directory will be used by default"
}

setProject() {
	project="$1"

	if [[ -z "${paths[${project}]}" ]]
		then echo "Unknown project: $project!"
		exit
	fi

	echo "Opening project $project..."
	cd $directory${paths[$project]}
}

mainFunction() {
	# Reset in case getopts has been used previously in the shell.
	OPTIND=1

	# Default values 
	push=false
	mode=help

	while getopts "pcuj:" opt; do
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
		esac
	done

	case "$mode" in
		commit)
			commitFunction;
			;;
		pull)
			pullFunction;
			;;
		*)
			helpFunction;
			;;
	esac
}



mainFunction "$@";
