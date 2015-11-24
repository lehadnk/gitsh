# gitsh
A lightweight bash script allowing to handle tons of different git repositories easy way.

# usage
alias gitsh="~/gitsh.sh"

**gitsh -u** to start a process of mass update of all projects listed in the configuration array in the beginning of the script. All uncomitted changes will be stashed, then popped back after branch update if possible.

**gitsh -c** to make an extra quick git flow hotfix out of the changes in the current branch. A last tag name will be shown to you, and you'll be posible to specify tag name, commit message, and tag description with tag description including commit message by default.
*Just like git stash && git tag && git flow hotfix start new_tag && git stash pop && git add . && git flow hotfix finish new_tag, but much easier to do*

**gitsh -cpj myproj_lib** will do the same but for another project with no need to navigate to it's directory, then push commit and tag data to repository. *Includes cd path/to/lib/hope/i/still/remember/it/ && git stash && git tag && git flow hotfix start new_tag && git stash pop && git add . && git flow hotfix finish new_tag && git push && git push --tags*

# configuration
Open *gitsh.sh*. Config section in the beginning is the only thing you need to touch. Enter your base dir, then specify the projects you're working on in the associative array:
```
directory='/home/lehadnk/'
paths=(
	[project_name]='path/to/project/'
	[another_project]='path/to/another/repository/'
)
```
You could also touch ~/.bashrc file to add an alias to the script:
```
alias gitsh="~/gitsh.sh"
```
This way you could call it from terminal much easier way.

# parameters
**-c** Makes a gitflow hotfix from a changes in a current branch<br />
**-u** Updates all branches listed in the config of this script<br />
**-p** Pushes commit and tag data to repo after making a hotfix<br />
**-j** Sets a project to work with. Current directory will be used by default<br />
