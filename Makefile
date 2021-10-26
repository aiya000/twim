RUBY_WARNING_PATTERN = ".*ruby.*: warning:"

IGNORE_RUBY_WARNING = grep -v ': warning:'

switch-account:
	t set active senka_ai_vrchat 2>&1 | tee -a switch-account.log | $(IGNORE_RUBY_WARNING)

# Unfollows users that doesn't follow me excluding 'trusted-users'
unfollowing: switch-account
	./scripts/unfollowing.sh 2>&1 | tee -a unfollowing.log | $(IGNORE_RUBY_WARNING)

# A range `from ~ to`. e.g.
#
# $ make copy-following aiya000 from=100 to=100
#     to follow users between 100th and 200th of aiya000's all following.
#     (to avoid the API rate limit.)
#
#   100   100     rest
# |-----|-----|----------|
#        \   /
#  `from=100 to=100` unfollows this range
from ?=
to ?=
source-user ?=

# Follows `source-user`'s follower users excluding users that has been followed by me
copy-follower: switch-account
	./scripts/copy.sh follower $(source-user) $(from) $(to) 2>&1 | tee -a copy-follower.log | $(IGNORE_RUBY_WARNING)

# Simular to 'copy-follower', but the targets are following users
copy-following: switch-account
	./scripts/copy.sh following $(source-user) $(from) $(to) 2>&1 | tee -a copy-following.log | $(IGNORE_RUBY_WARNING)
