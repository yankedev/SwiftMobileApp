#taken and adapted from https://www.mapbox.com/help/ios-private-access-token/
token_file=huntlyToken.secret
token="$(cat $token_file)"
if [ "$token" ]; then
  plutil -replace HuntlyAccessToken -string $token "$TARGET_BUILD_DIR/$INFOPLIST_PATH"
else
  echo 'error: Missing Huntly token (should be in huntlyToken.secret)'
exit 1
fi
