.PHONY: changelog release

SEMTAG=semtag

CHANGELOG_FILE=CHANGELOG.md

scope ?= "minor"

changelog-unrelease:
	git-chglog --no-case -o $(CHANGELOG_FILE)

changelog:
	git-chglog --no-case -o $(CHANGELOG_FILE) --next-tag `$(SEMTAG) final -s $(scope) -o -f`

release:
	$(SEMTAG) final -s $(scope)
