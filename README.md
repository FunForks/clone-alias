# Creating a bash alias for cloning a GitHub repository #

When you clone a GitHub repository manually and open it in VS Code, you need to execute the following steps:

1. Visit the GitHub repository in your browser
2. Click on the green `Code ᐁ` button
3. Copy the URL in the pop-up pane (e.g.: git@github.com:funforks/clone-alias.git)
4. Open a Terminal window
5. `cd` to the directory into which you want to clone the repository
6. Type `git clone `
7. Paste (Ctrl-Shift-V) the URL that you copied in step 3
8. Press Enter
9. Type `cd `
10. Start typing the name of the newly created directory
11. Press the Tab key (or type the directory name in full)
12. Run `code -r .` to open the present working directory in VS Code.

This tutorial will show you how to create an alias that will allow you to reduce this to the following:

1. Visit the GitHub repository in your browser
2. Click on the green `Code ᐁ` button
3. Copy the URL in the pop-up pane (e.g.: git@github.com:funforks/clone-alias.git)
4. Open a Terminal window
5. `cd` to the directory into which you want to clone the repository
6. Type `gclone ` (the name of the "git clone" alias that you will create)
7. Paste (Ctrl-Shift-V) the URL that you copied in step 3
8. Press Enter

It will take you less than an hour to work through this tutorial and understand enough about `bash` to know what you are doing, and each time you clone a repository, you will save a few seconds. Over time, those saved seconds will add up to more than the time you spent working through the tutorial, and in front of a job interviewer who wants to watch you as you work, the effect can be spectacular.

## Getting Started with `bash`

Before creating an alias, you can create a simple `bash` script that you can execute and debug. First, you can create a file with the extension `.sh`, make it executable, and run it. I suggest that you call this file `gclone.sh`, and that later you call your alias `gclone` (short for `git clone`), but you can use your own name if you prefer.

1. Create a new directory
2.  `cd` into this new directory
3.  Create a file called gclone.sh: `touch gclone.sh`
4.  Make the file exectuable: `chmod 755 gclone.sh`
5.  Open the file in VS Code: `code gclone.sh`
6.  Enter the text
   ```bash
   echo $0
   echo $1
   echo $2
   ```
11. Save the file
12. Run it from the Terminal pane: `./gclone.sh one     and-two`
   (you can use as many spaces as you want between the words)

> *To execute an executable file in the Terminal, you simply need to type in the path to the file. Here, the file is in the present working directory, which Unix-like operating systems refer to as `.`, so the path to the file is `./gclone.sh`. This means: "the file named `gclone.sh` in the current directory".*

13. Here is the output you should see in the Terminal pane:
   ```bash
   ./gclone.sh
   one
   and-two
   ```
12. From this, you can deduce that:
   * `echo` means "print in the Terminal pane"
   * `$0` is a variable that contains the name of the script that is being executed
   * `$n` is the string value of the nth argument, where arguments are the space-delimited words that you type after the name of the file to execute.

## Using the URL of the GitHub repository as the argument

As you may have guessed, you can use the URL of a GitHub repository as the argument when execute the script. I'll use the URL of this repository as an example, but you can use the URL of any repository you want.

You can get the URL of a repository if you:
1. Visit a repository on GitHub
2. Click on the green [ Code ᐁ ] button
3. Copy the URL in the pop-up pane (e.g.: git@github.com:funforks/clone-alias.git)

## Testing with your `gclone.sh` script

In the Terminal window:
* Type `./gclone.sh ` (including the trailing space)
* Use Ctrl-**Shift**-V to paste the URL that you just copied
* Press Enter

You should see something like:
```bash
./gclone.sh
git@github.com:funforks/clone-alias.git

```
> *Notice that the value for `$2` is empty, so you just see an empty line at the end.*

## Getting the name of the folder

When you run `git clone git@github.com:<organization>/repo-name.git` in the Terminal, Git will create a directory named `repo-name` as a child of the present working directory.

Before you can `cd` into that directory, you'll need to extract the repository name from the URL. Here's the Google Search that I used to find out how to do this:

[bash get filename from path](https://www.google.com/search?q=bash+get+filename+from+path)

I tested a few of the proposed solutions in the first suggested link, and this is the one that makes most sense to me: `$(basename -- $1 .git)`.

> * The `basename` command returns the name of a file without the path leading to the file
> * The `--` directive says "There aren't any more flags for the `basename` command. Flags are always preceded by a hyphen (`-`). GitHub does allow you to create a repository with a name that starts with a hypen, so using `--` says: "If the value of `$1` starts with a hyphen, treat it as an argument, not as a flag. Because there are no more flags".
> * `$1` will be the string first argument to your `./gclone.sh` command
> * `.git` says: "If the basename ends with the extension `.git` then ignore the extension.
> * Using double quote marks (`"` around commands in `bash` that manipulate variables as strings is good practice. Without the quote marks, unexpected things can happen. You can read more about this [here](https://linuxconfig.org/bash-script-quotation-explained-with-examples).
  
You can change your `gclone.sh` script to this:
```bash
echo $1
echo "$(basename -- $1 .git)"
```

When you run the command...

`./gclone.sh git@github.com:funforks/clone-alias.git`

.... you should now see something like:
```bash
git@github.com:funforks/clone-alias.git
clone-alias
```

## Three steps in one

You now have enough information to create a script that:
1. Clones from the GitHub repository
2. `cd`s into the newly created directory
3. Opens VS Code in this directory

You can change your `gclone.sh` script to this:
```bash
git clone "$1"
cd "$(basename -- $1 .git)"
code -r .
```

If you run this with the URL of your GitHub repo as the argument, you should find that all three steps are completed with one command:

* The GitHub repository is cloned into the same folder that contains the `gclone.sh` script
* The Terminal window moves its focus to the repository directory
* VS Code will open (if it is currently closed), or the most recently active VS Code window will switch, to show the repository director in its Explorer pane.

Try it and see:

`./gclone.sh git@github.com:funforks/clone-alias.git`

Does the script work for you?

## Anticipating errors

The command above worked because `git@github.com:funforks/clone-alias.git` is a valid URL for a GitHub repository. But what would happen if the repository did not exist, or if you forgot to paste its URL as an argument?

The code as it stands contains three commands. All three commands _will be executed, even if an earlier command has failed_.

Try it. See what happens if you use a deliberately wrong URL for the repository:

```bash
./gclone.sh try_using_a/missing_repository
```
```bash
fatal: repository 'try_using_a/missing_repository' does not exist
./gclone.sh: line 9: cd: missing_repository: No such file or directory
```

The command `git clone` fails, so no new directory is created, so the `cd` command also fails.

## Stopping execution if there is an error

The `&&` operator is a logical `AND` that uses short-circuit evaluation. That's a lot of information in one sentence.

"Logical `AND`" means that it will return `true` if all both the expression before it and the expression after it evaluate to true. This is relevant here, because when you execute a `bash` command, the command will return `true` if it is successful, and `false` if it fails.

"Short-circuit evaluation" means that if the first expression evaluates to false, it will not even bother evaluating the second one. In the current context, the second command will not be executed if the first command fails.

Question: What do you imagine will happen if you use the `&&` operate between your commands, like this...?

```bash
git clone "$1" && cd "$(basename -- $1 .git)" && code -r .
```
Answer: If the `git clone` command fails, it will return a falsy value, and the `cd` command will not be executed.

You might prefer to split this single line into three, so that it is easier to see that there are three commands, and that each one is dependent on the success of the previous one.

```bash
git clone "$1" &&
cd "$(basename -- $1 .git)" &&
code -r .
```
Try using the deliberately wrong URL again:

```bash
./gclone.sh try_using_a/missing_repository
```
```bash
fatal: repository 'try_using_a/missing_repository' does not exist
```
This time, all potential damage is avoided. The script simply stops if an error occurs.

## Creating an alias

Now that you have got your bash script working, you can create a function from it and make it available in the Terminal pane at any time.

There is a hidden file in your Home directory called `.bashrc`. The `rc` stands for `run commands` or `run control`, depending on who you ask. This file is executed each time you launch your computer, and it provides a place to define variables, aliases and functions that will be available in every Terminal window.

---
> **WARNING: Treat the `.bashrc` file with respect. If it contained fatal errors, and you shut down your computer, then you might not be able to restart your computer normally. If this happened, you would need to restore an uncorrupted backup of the file. It would be good to create such a backup now. Just in case.**
>
>**Run this command:**
>
>`mkdir ~/Backup && cp ~/.bashrc ~/Backup/bashrc`
>
>**Now you will have a visible copy of the `.bashrc` file in a director named Backup. Now it is safe to continue.**
---

To edit the `.bashrc` file in VS Code, run the command: `code ~/.bashrc`.

Scroll to the end of the file and add the following function:

```bash
### CUSTOM CODE // CUSTOM CODE // CUSTOM CODE ###

## Use...
#
#   gclone <URL of a repository on GitHub>
# 
# ... to:
# 1. Clone the remote repository into the current
#    directory
# 2. cd into the newly cloned directory
# 3. Open this directory in VS Code.
##
gclone() {
  git clone "$1" &&
  cd "$(basename -- $1 .git)" &&
  code -r .
}
```
Save the changes to the `.bashrc` file.

This is exactly the same code that you wrote in the `gclone.sh` script, wrapped in a function called `gclone`. 

Try using the `gclone` function in the Terminal window:

```bash
gclone git@github.com:funforks/clone-alias.git
```
The command should fail. **This is normal.** You should see something like this:
```bash
Command 'gclone' not found, did you mean:
  command 'rclone' from snap rclone (1.36)
  command 'rclone' from deb rclone (1.53.3-4ubuntu1)
  command 'gclose' from deb gnustep-gui-runtime (0.29.0-2build1)
See 'snap info <snapname>' for additional versions.
```
Here's the reason: You have changed the `.bashrc` file, but your Terminal window is still using the old version. You need to tell the Terminal to reload the `.bashrc` file before you can use any new functions.

Run the following command:

`source ~/.bashrc`

Now run the `gclone` command again:

```bash
gclone git@github.com:funforks/clone-alias.git
```
And this time it should work:
```bash
gclone git@github.com:FunForks/clone-alias.git
Cloning into 'clone-alias'...
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.
remote: Compressing objects: 100% (5/5), done.
Receiving objects: 100% (5/5), 5.49 KiB | 5.49 MiB/s, done.
remote: Total 5 (delta 0), reused 5 (delta 0), pack-reused 0
clone-alias $ |
```
## Conclusion

Congratulations! You have successfully created a bash alias. You started by creating an executable `.sh` file, and exploring some simple concepts:

* `echo` will print a string to the console
* `$1` gives access to the first argument to a command
* You create a variable with the `=` operator (and no spaces between the variable name and its value)
* You access a variable by adding the suffix `$` to its name
* You can use the `basename` function to get the name of a file or directory
* The directive `--` says: "There are no more flags. Even if the next argument starts with a hyphen (`-`), it is an _argument_ not a flag."
* `basename` allows you to remove the extension from a file name, if you know the extension
* `code -r .` tells VS Code to open the current directory in its active window
* Even if a script works the way you expect it to when you first test it, there may be input errors that you had not planned for that can lead it to fail
* Using the `&&` operator between commands will stop a script from executing as soon as one of the commands fails
* The `~/.bashrc` file is very powerful and it deserves to be treated carefully
* Any function that you add to the `~/.bashrc` file is available to the Terminal
* Comments in a `bash` script start with a `#` character 
* If you edit the `~/.bashrc` file, then you must reload it using `source ~/.bashrc` before you can use the edited variables, aliases or functions.

And most of all, you have learned that, if you invest a little time in creating and mastering shortcuts, you can work more efficiently in the future.