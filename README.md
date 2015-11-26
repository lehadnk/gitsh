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
This way you can call it from terminal in a much easier way.

# parameters
**-c** Makes a gitflow hotfix from changes in a current branch<br />
**-u** Updates all branches listed in the config of this script or in selected project group (see -g)<br />
**-p** Pushes commit and tag data to repo after making a hotfix<br />
**-j** Sets a project to work with. Current directory will be used by default<br />
**-g** Sets a project group to work with

# project groups
You may also specify the project groups to work with in the groups section of the config:
```
groups=(
	[mygroup]='project_name project_lib another_library'
)
```
This way you can easily handle things like making a hotfix including changes in both project and it's library with a single command:<br>
**gitsh -cpg mygroup** Will check projects "project_name", "project_lib" and "another_library" for changes, initiating a process of making a hotfix for ones you made changes to (aka *cd path/to/project/ && git stash && git tag && git flow hotfix start new_tag && git stash pop && git add . && git flow hotfix finish new_tag && git push && git push --tags && cd path/to/lib && git stash && git tag && git flow hotfix start new_tag && git stash pop && git add . && git flow hotOHMYGODPLEASESTOP*)

**gitsh -ug mygroup** is also useful macro which launches a process of updating every project the group.
