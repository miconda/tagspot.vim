# Tag Spot - Vim Module #

## Overview ##

Spot the tag nearby.

The purpose of this plugin is to enable searching tags nearby the location of
current edited file. To search, it uses the word under current cursor.

It is very similar to the built-in **:tag** command, but with next tag location
rules (by priority):

  * in the same file
  * in the same directory
  * elsewhere

This plugin was developed because (apparently) the default tag selection is
putting priority only to the same file, then it will select likely based on the
order in the tags file.

Example of behaviour:

  * a function named **x()** is defined in **modules/a/a.c**
  * another function named **x()** is defined in **modules/b/b.c**
  * a function **x()** is used in **modules/b/c.c** and triggering a tag select
  for it with vim default function is jumping to **modules/a/a.c**. With
  **tagspot**, it is jumping to **modules/b/b.c** .

## Installation ##

There are several ways to install the plugin. The recommended one is by using
pathogen (https://github.com/tpope/vim-pathogen). In
that case, you can clone the plugin's git repository like so:

```
    git clone https://github.com/miconda/tagspot.vim ~/.vim/bundle/tagspot
```

If your vim configuration is under git version control, you could also set up
the repository as a submodule, which would allow you to update more easily.
The command is (provided you're in ~/.vim):

```
    git submodule add https://github.com/miconda/tagspot.vim bundle/tagspot
```

Another way is to simply copy all the essential directories inside the ~/.vim
directory: autoload, doc, plugin.

## Usage ##

One way to use this plugin is to set a combination of keys to map the call of
TagSpot() function. For example -- to jump to the tag corresponding to the word
under the cursor by pressing CTRL+[ -- add to .vimrc:

``` vim
    nnoremap <C-[> :call TagSpot()<CR>
    vnoremap <C-[> :call TagSpot()<CR>
```

## Remarks ##

Suggestions, issues, pull requests can be submited to:

  * https://github.com/miconda/tagspot.vim
