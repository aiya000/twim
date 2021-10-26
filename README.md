# Twim

Twim is a management system for your twitter accounts.

**Currently WIP.**

## # :diamond_shape_with_a_dot_inside: Features :diamond_shape_with_a_dot_inside:

- **Following** users that is another user's follower or followee
    - But Twim avoids following the users twice or more
    - Meaning Twim follows the users only once

- **Unfollowing** users that is not following you
    - But never unfollowing users that is specified by you

## Requirements

- [t](http://sferik.github.io/t/)

```shell-session
$ t authorize
```

- ruby 2.7 (recommend: rbenv)

## Usage

```shell-session
# TODO
```

## Issues
### t: command not found

Did you forget adding `t` to `$PATH`?

### `authorize: uninitialized constant ...`

- [authorize: uninitialized constant Twitter::REST::Client::BASE\_URL (NameError) · Issue #402 · sferik/t · GitHub](https://github.com/sferik/t/issues/402)

```shell-session
$ t authorize
...:in authorize': uninitialized constant ...
```

Fix

```shell-session
$ gem install twitter -v 6.1.0
$ gem uninstall twitter -v 6.2.0
```

- More references
    - [twitter client 「t」でauthorizeできない場合 - クイックノート](https://clean-copy-of-onenote.hatenablog.com/entry/gem_t_authorize_error)
