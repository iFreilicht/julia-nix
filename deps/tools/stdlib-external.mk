# Define a set of targets for downloading, caching, and building the source of
# a stdlib library. The commit and git branch should be defined in a file
# $stdlib_name.version in the current directory. See the git-external macro for
# additional documentation.
#
# Parameters to the stdlib-external macro:
#
#   $1 = stdlib_name
#   $2 = var_prefix (by convention, use upper cased stdlib_name)

include $(JULIAHOME)/deps/tools/git-external.mk

define stdlib-external

$$(eval $$(call git-external,$1,$2,,,$$(BUILDDIR)))
$$(BUILDDIR)/$$($2_SRC_DIR)/build-compiled: $$(BUILDDIR)/$$($2_SRC_DIR)/source-extracted
	@# no build steps
	echo 1 > $$@
$$(eval $$(call symlink_install,$$$$(VERSDIR)/$1,$$$$($2_SRC_DIR),$$$$(build_datarootdir)/julia/stdlib))
clean-$1:
	-rm -f $$(BUILDDIR)/$$($2_SRC_DIR)/build-compiled
get-$1: $$($2_SRC_FILE)
extract-$1: $$(BUILDDIR)/$$($2_SRC_DIR)/source-extracted
configure-$1: extract-$1
compile-$1: $$(BUILDDIR)/$$($2_SRC_DIR)/build-compiled
install-$1: install-$$(VERSDIR)/$1
uninstall-$1: uninstall-$$(VERSDIR)/$1
reinstall-$1: reinstall-$$(VERSDIR)/$1
version-check-$1: version-check-$$(VERSDIR)/$1
clean-$1: clean-$$(VERSDIR)/$1
.PHONY: $(addsuffix -$1,get extract configure compile install uninstall reinstall clean)
endef
