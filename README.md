# gitsh
Lightweight bash script allowing you to handle tons of different git repositories in a simple way.

# usage
alias gitsh="~/gitsh.sh"

**gitsh -u** to start a process of mass update of all projects listed in the configuration array in the beginning of the script. All uncommitted changes will be stashed, then, if possible, popped back after branch update.

**gitsh -c** to make an extra quick git flow hotfix from changes in the current branch. The last tag name will be shown to you, and you'll be able to specify tag name, commit message, and tag description with commit message by default.
*Just like git stash && git tag && git flow hotfix start new_tag && git stash pop && git add . && git flow hotfix finish new_tag, but much easier to do*

**gitsh -cpj myproj_lib** will do the same, but for another project with no need to navigate to it's directory, then push commit and tag data to repository. *Includes cd path/to/lib/hope/i/still/remember/it/ && git stash && git tag && git flow hotfix start new_tag && git stash pop && git add . && git flow hotfix finish new_tag && git push && git push --tags*

# configuration
Open *gitsh.sh*. Config section in the beginning is the only thing you need to edit. Enter your base dir, then specify the projects you're working on in the associative array:
```
directory='/home/lehadnk/'
paths=(
	[project_name]='path/to/project/'
	[another_project]='path/to/another/repository/'
)
```
You could also edit ~/.bashrc file to add an alias to the script:
```
alias gitsh="~/gitsh.sh"
```
This way you could call it from terminal in a much easier way.

# parameters
**-c** Makes a gitflow hotfix from changes in a current branch<br />
**-u** Updates all branches listed in the config of this script<br />
**-p** Pushes commit and tag data to repo after making a hotfix<br />
**-j** Sets a project to work with. Current directory will be used by default<br />
