#!/bin/sh

set -e

if test "$1" = "-h" -o "$1" = "--help"; then
	echo "Use: $0 [<language>]"
	echo "Run without arguments to update all translation files."
	exit 0
fi

cd "$(readlink -f "$(dirname "$0")/..")"

DOMAIN=(phpIP)

POT_DIR="$PWD/translations"
test -d "$POT_DIR"

POT_FILE="$POT_DIR/$DOMAIN.pot"
itstool configs/navigation.xml.in --output="$POT_FILE"

/usr/bin/xgettext -j \
	--package-name "$DOMAIN" \
	--package-version "1.0" \
	--language=PHP --from-code=UTF-8 --keyword=_ \
	--no-escape --add-location --sort-by-file \
	--add-comments=I18N \
	--output="$POT_FILE" \
        controllers/AuthController.php \
        controllers/MatterController.php \
        controllers/ErrorController.php \
        controllers/RuleController.php \
        controllers/ActorController.php \
        controllers/EventController.php \
	forms/Actor/Add.php \
        forms/Actor/Changepwd.php \
        forms/Auth/Login.php \
        forms/Event/Add.php \
        forms/Rule/Add.php \
        layouts/scripts/content-inner-header.phtml \
        layouts/scripts/content-right.phtml \
        layouts/scripts/layout.phtml \
        views/scripts/pagination.phtml \
        views/scripts/actor/add.phtml \
        views/scripts/actor/filter.phtml \
        views/scripts/actor/index.phtml \
        views/scripts/actor/used-in.phtml \
        views/scripts/actor/view.phtml \
        views/scripts/actor/users.phtml \
        views/scripts/auth/logout.phtml \
        views/scripts/matter/add.phtml \
        views/scripts/index/index.phtml \
        views/scripts/matter/add-classifier.phtml \
        views/scripts/matter/add-title.phtml \
        views/scripts/matter/classifierlist.phtml \
        views/scripts/matter/edit.phtml \
        views/scripts/matter/eventlist.phtml \
        views/scripts/matter/index.phtml \
        views/scripts/matter/role-actors.phtml \
        views/scripts/matter/map-actor-role.phtml \
        views/scripts/matter/national.phtml \
        views/scripts/matter/tasklist.phtml \
        views/scripts/matter/view.phtml \

/bin/sed --in-place --expression="s/charset=CHARSET/charset=UTF-8/" "$POT_FILE"

update_po() {
	local LL_CC="$1"
	local PO_FILE="$POT_DIR/$LL_CC.po"

        echo "Update $(basename "$PO_FILE"):"
	/usr/bin/msgmerge \
		--update --no-fuzzy-matching \
		--no-escape --add-location --sort-by-file \
		--lang="$LL_CC" \
		"$PO_FILE" "$POT_FILE"
}

if test "$1"; then
	update_po "$1"
else
	for l in $(ls -1 "$POT_DIR"/*.po); do
		l="$(basename "$l")"
		update_po "${l%.po}"
	done
fi
