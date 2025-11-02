# Privacy Policy Setup Instructions

## For Google Play Console

The privacy policy cannot be set in the Android manifest file. It must be configured in the Google Play Console.

### Steps to Add Privacy Policy:

1. Go to [Google Play Console](https://play.google.com/console)
2. Select your app: **Code & Cocktails**
3. Navigate to: **Store presence** → **App content**
4. Scroll down to **Privacy Policy** section
5. Click **Manage** or the edit icon
6. Enter the following URL:

```
https://raw.githubusercontent.com/ekyeremeh7/CodeAndCocktails/main/README.md
```

7. Click **Save**

### Alternative URLs:

If the above doesn't work, try:
- `https://github.com/ekyeremeh7/CodeAndCocktails/blob/main/README.md#privacy-policy`

### What's Already Done:

✅ Camera permission declared in AndroidManifest.xml  
✅ Privacy policy content added to README.md  
✅ Privacy policy pushed to GitHub  
✅ Privacy policy URL is accessible

### Next Steps:

After adding the URL in Play Console, it may take a few minutes for Google to verify the privacy policy.

## Current App Status:

- **App Version**: 1.0.0+6
- **Build Number**: 6
- **Permissions**: CAMERA, INTERNET, ACCESS_NETWORK_STATE, READ_PHONE_STATE
- **Privacy Policy**: Ready at GitHub

