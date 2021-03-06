## git2r, R bindings to the libgit2 library.
## Copyright (C) 2013-2015 The git2r contributors
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License, version 2,
## as published by the Free Software Foundation.
##
## git2r is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License along
## with this program; if not, write to the Free Software Foundation, Inc.,
## 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

library(git2r)

## Create a directory in tempdir
path <- tempfile(pattern="git2r-")
dir.create(path)

## Initialize a repository
repo <- init(path)
config(repo, user.name="Alice", user.email="alice@example.org")

## Create a file
writeLines("Hello world!", file.path(path, "test-1.txt"))

## add and commit
add(repo, 'test-1.txt')
commit(repo, "Commit message")

## Make one more commit
writeLines(c("Hello world!", "HELLO WORLD!"), file.path(path, "test-1.txt"))
add(repo, 'test-1.txt')
commit(repo, "Next commit message")

## Check that there are no stashes
stopifnot(identical(stash_list(repo), list()))

## Create one more file
writeLines("Hello world!", file.path(path, "test-2.txt"))

## Check that there are no stashes
stopifnot(identical(stash_list(repo), list()))

## Stash
stash(repo)
stopifnot(identical(stash_list(repo), list()))
stash(repo, untracked=TRUE)
stopifnot(identical(length(stash_list(repo)), 1L))

## Drop stash
stash_drop(repo, 0)
stopifnot(identical(stash_list(repo), list()))

## Check stash_drop argument
tools::assertError(stash_drop(repo))
tools::assertError(stash_drop(repo, -1))
tools::assertError(stash_drop(repo, 0.5))

## Create one more file
writeLines("Hello world!", file.path(path, "test-3.txt"))

## Create stash in repository
stash(repo, untracked=TRUE)
stopifnot(identical(length(stash_list(repo)), 1L))

## Drop git_stash object in repository
stash_drop(stash_list(repo)[[1]])

## Cleanup
unlink(path, recursive=TRUE)
