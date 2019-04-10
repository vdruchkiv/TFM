Some github basics

Workflow Summary
Syncing Central Repo with Local Repo
Setting It Up (only do this the initial time)

Find & copy Central Repo URL

`git remote add upstream https://github.com/vdruchkiv/TFM.git`

After Initial Set Up
Update your Local Repo & Push Changes

`git pull upstream master` - pull down any changes and sync the local repo with the central repo

make changes, git add and git commit

`git push origin master` - push your changes up to your fork

Repeat

Update Local Repository and push it

``

`git commit -m "My comment"`

`git push origin master`

When pulling directory the following error may occure:

`The following untracked working tree files would be overwritten by checkout`

Deal with it by cleaning:

`git clean -f`

Or with promt:

`git clean -i`