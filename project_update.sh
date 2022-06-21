
GIT_BRANCH=$DBSNOOP_SERVER_ENV
GIT_USER="rodrigodanieli"
GIT_KEY="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"
GIT_REPO="rodrigodanieli/DND_FE"
TELEGRAM_BOT_TOKEN="5187841078:AAG8GIGpWc53ygE2y5jAdFpPbPv4mMKvmiU"
WORKDIR="/app"
HTTP_DIR="/var/www/html"
NPM_BUILD="master"
TELEGRAM_CHAT="-751549156"

cd $WORKDIR

LAST_UPDATE=$(date)

if [ -f "$WORKDIR/last_update" ]
then
    echo $LAST_UPDATE > $WORKDIR/last_update
else
    touch $WORKDIR/last_update
    echo $LAST_UPDATE > $WORKDIR/last_update
fi;

HAS_NO_UPDATE=$(git pull https://$GIT_USER:$GIT_KEY@github.com/$GIT_REPO $GIT_BRANCH | grep "Already up-to-date." | wc -l)

if [ "1" -eq $HAS_NO_UPDATE ]
then
    echo "Already Update"
    exit;
fi;

LAST_COMMIT=$(git show `$GIT_BRANCH`  | grep -m1 'commit' | awk '{print $2}' )

if [ -f "$WORKDIR/last_commit" ]
then
    echo $LAST_COMMIT > $WORKDIR/last_commit
else
    touch $WORKDIR/last_commit
    echo $LAST_COMMIT > $WORKDIR/last_commit
fi;

npm update
BUILD_PROCESS=$(quasar build))
#BUILD_SUCCESS=$( echo $BUILD_PROCESS | grep "Build complete" | wc -l)

#if [ "1" -eq $BUILD_SUCCESS ]
#then
    cp -rf dist/spa/* $HTTP_DIR
    echo "BUILD Success!"
    exit
#fi;
exit;
ERROR_INFO=$(echo $BUILD_PROCESS | grep -A 20 'Failed to compile')


curl -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"chat_id\": $TELEGRAM_CHAT, \"text\": \"Failed Update! \n GIT-DEBUG: \n - $GIT_REPO \n - $GIT_BRANCH  \n - $GIT_USER \n - $SERVICE \", \"disable_notification\": true}" \
    https://api.telegram.org/bot5187841078:AAG8GIGpWc53ygE2y5jAdFpPbPv4mMKvmiU/sendMessage

curl -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"chat_id\": $TELEGRAM_CHAT, \"text\": \"DEBUG Build : \n $ERROR_INFO\", \"disable_notification\": true}" \
    https://api.telegram.org/bot5187841078:AAG8GIGpWc53ygE2y5jAdFpPbPv4mMKvmiU/sendMessage
