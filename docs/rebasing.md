Rebasing
========

When a new version of Tor Browser or Thunderbird is tagged, we need to
rebase our patchsets.  This doc will help the unacquainted.

Maintaining a fork
------------------

This might be another approach. We're kind of waiting on,
https://bugzilla.mozilla.org/show_bug.cgi?id=1309045

so we can sync that here,
https://gitweb.torproject.org/tor-messenger.git/

Sync'ing mercurial to git
-------------------------

This isn't strictly necessary but the author of this document prefers working
in git.  You'll need to install [fast-export](https://github.com/frej/fast-export)

```
hg clone https://hg.mozilla.org/releases/comm-esr52/
mkdir tor-messenger
cd tor-messenger
git init
hg-fast-export -r ../comm-esr52 --force
```

Now you have a git repo sync'd w/ hg

You can rerun that as new commits come in (`hg pull && hg update`),
but ignore that for now.

Applying the Tor Messenger patches to a tag
-------------------------------------------

Let's checkout the right Thunderbird tag in git.  The specific tag below is
from the time this document was originally written.  Obviously, update it as
necessary.

```
export TAG=THUNDERBIRD_52_2_1_RELEASE

# We're still in "tor-messenger" from above
git checkout -b tm-base $TAG
git checkout -b tm
```

We created `tm-base` to ease rebasing and formatting patches below.  Now go
over to the `tor-messenger-build` repo and get our patches,

```
cd projects/instantbird
cp 00* ~/tor-messenger  # Assuming the above repo you created was in ~
```

And apply them,

```
cd ~/tor-messenger
git branch  # Should say "tm" from above
git am 00*.patch
rm 00*
```

Now you have a nice `tm` branch based on `$TAG` with all our patches.

Adding or updating a patch
--------------------------

Generally, you'll want just want to do some work and `git commit` it on top.
Occasionally though, you'll need to make some changes to the patches we're
already maintaining.  A good example of that is when Tor Browser updates,
you'll want to sync the preferences from `browser/app/profile/000-tor-browser.js`

```
git rebase -i tm-base
# Pick the first commit for editing, "Set Tor Messenger preferences"
```

Now copy the contents from the new `000-tor-browser.js` to `im/app/profile/all-instantbird.js`
being sure to lineup sections to produce a nice diff.  Mark any new changes
where we deviate with `// TM`.  (Note: This description is a little opaque
and can use some clarifying statements.)

```
git rebase --continue
```

Now, we're ready to export those changes and copy them back over to the
`tor-messenger-build` repo.

```
git format-patch tm-base
mv 00* ~/tor-messenger-build/projects/instantbird/
```

Be sure to add / update any modified `-filename:` in the `config`.
