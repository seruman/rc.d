#!/usr/bin/env bash

set -e

# JS field injection code from https://github.com/qutebrowser/qutebrowser/blob/master/misc/userscripts/password_fill
javascript_escape() {
    # print the first argument in an escaped way, such that it can safely
    # be used within javascripts double quotes
    # shellcheck disable=SC2001
    sed "s,[\\\\'\"],\\\\&,g" <<<"$1"
}

js() {
    cat <<EOF
    function isVisible(elem) {
        var style = elem.ownerDocument.defaultView.getComputedStyle(elem, null);
        if (style.getPropertyValue("visibility") !== "visible" ||
            style.getPropertyValue("display") === "none" ||
            style.getPropertyValue("opacity") === "0") {
            return false;
        }
        return elem.offsetWidth > 0 && elem.offsetHeight > 0;
    };
    function hasPasswordField(form) {
        var inputs = form.getElementsByTagName("input");
        for (var j = 0; j < inputs.length; j++) {
            var input = inputs[j];
            if (input.type == "password") {
                return true;
            }
        }
        return false;
    };
    function loadData2Form (form) {
        var inputs = form.getElementsByTagName("input");
        for (var j = 0; j < inputs.length; j++) {
            var input = inputs[j];
            if (isVisible(input) && (input.type == "text" || input.type == "email")) {
                input.focus();
                input.value = "$(javascript_escape "${USERNAME}")";
                input.dispatchEvent(new Event('change'));
                input.blur();
            }
            if (input.type == "password") {
                input.focus();
                input.value = "$(javascript_escape "${PASSWORD}")";
                input.dispatchEvent(new Event('change'));
                input.blur();
            }
        }
    };
    var forms = document.getElementsByTagName("form");
    for (i = 0; i < forms.length; i++) {
        if (hasPasswordField(forms[i])) {
            loadData2Form(forms[i]);
        }
    }
EOF
}

URL=$(echo "$QUTE_URL" | awk -F/ '{print $3}' | sed 's/www.//g')
echo "message-info 'Looking for password for $URL...'" >>$QUTE_FIFO

UUID_URL=$(op item list --format=json | jq -r '.[] | "\(.id):\(.urls[]?.href)" ' | grep "$URL") || $(echo "message-error 'No entry found for $URL'" >>$QUTE_FIFO)

IFS=: read -r UUID var2 <<<"$UUID_URL"
ITEM=$(op item get --reveal --format=json "$UUID")

PASSWORD=$(echo "$ITEM" | jq -r '.fields[]? | select(.purpose=="PASSWORD") | .value')

if [ -n "$PASSWORD" ]; then
    TITLE=$(echo "$ITEM" | jq -r '.title')
    USERNAME=$(echo "$ITEM" | jq -r '.fields[]? | select(.purpose=="USERNAME") | .value')

    printjs() {
        js | sed 's,//.*$,,' | tr '\n' ' '
    }
    echo "jseval -q $(printjs)" >>"$QUTE_FIFO"

    # TOTP=$(echo "$ITEM" | op get totp --session="$TOKEN" "$UUID")
    # if [ -n "$TOTP" ]; then
    #     echo "$TOTP" | pbcopy
    #     echo "One time password for $TITLE: $TOTP in clipboard" | terminal-notifier -title "Qutebrowser 1Password" -sound default
    # fi
else
    echo "No password found for $URL" | terminal-notifier -title "Qutebrowser 1Password" -sound default
fi