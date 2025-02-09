#!/bin/bash
echo "ciao"
# # 🚀 Configuration - Change these values
# NETLIFY_ACCESS_TOKEN=$NETLIFY_ACCESS_TOKEN
# GITHUB_REPO="yebosoftware/nile"
# BRANCH="main"
# SITE_NAME="anothernilesite"
# BUILD_COMMAND="npm run build"
# PUBLISH_DIR="dist"

# # ✅ Step 1: Create Netlify site linked to GitHub
# echo "🚀 Creating Netlify site..."
# SITE_RESPONSE=$(curl -s -X POST "https://api.netlify.com/api/v1/sites" \
#   -H "Authorization: Bearer $NETLIFY_ACCESS_TOKEN" \
#   -H "Content-Type: application/json" \
#   -d "{
#     \"name\": \"$SITE_NAME\",
#     \"repo\": {
#       \"provider\": \"github\",
#       \"repo\": \"$GITHUB_REPO\",
#       \"private\": false,
#       \"branch\": \"$BRANCH\",
#       \"deploy_on_push\": true
#     }
#   }")

# echo $SITE_RESPONSE
# SITE_ID=$(echo "$SITE_RESPONSE" | jq -r '.id')
# SITE_URL=$(echo "$SITE_RESPONSE" | jq -r '.ssl_url')

# if [ "$SITE_ID" == "null" ]; then
#   echo "❌ Failed to create Netlify site!"
#   echo "$SITE_RESPONSE"
#   exit 1
# fi

# # echo "✅ Netlify site created: $SITE_URL"

# # ✅ Step 2: Configure Build Settings
# echo "⚙️ Configuring build settings..."
# curl -s -X PUT "https://api.netlify.com/api/v1/sites/$SITE_ID" \
#   -H "Authorization: Bearer $NETLIFY_ACCESS_TOKEN" \
#   -H "Content-Type: application/json" \
#   -d "{
#     \"build_settings\": {
#       \"repo_url\": \"$GITHUB_REPO\",
#       \"repo_branch\": \"$BRANCH\",
#       \"cmd\": \"$BUILD_COMMAND\",
#       \"dir\": \"$PUBLISH_DIR\"
#     }
#   }"

# # echo "✅ Build settings updated."

# # Not sure this is needed?
# # ✅ Step 3: Trigger First Deployment
# # echo "🚀 Triggering deployment..."
# # DEPLOY_RESPONSE=$(curl -s -X POST "https://api.netlify.com/api/v1/sites/$SITE_ID/builds" \
# #   -H "Authorization: Bearer $NETLIFY_ACCESS_TOKEN")

# # DEPLOY_URL=$(echo "$DEPLOY_RESPONSE" | jq -r '.deploy_ssl_url')

# # echo "✅ Deployment triggered. Site will be live soon: $DEPLOY_URL"
