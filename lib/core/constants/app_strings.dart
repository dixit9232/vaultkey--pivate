/// App-wide string constants
class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'VaultKey';
  static const String appTagline = 'Secure Your Digital Identity';

  // Common
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String add = 'Add';
  static const String done = 'Done';
  static const String next = 'Next';
  static const String back = 'Back';
  static const String close = 'Close';
  static const String retry = 'Retry';
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String warning = 'Warning';
  static const String info = 'Info';

  // Authentication
  static const String signIn = 'Sign In';
  static const String signUp = 'Sign Up';
  static const String signOut = 'Sign Out';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String createAccount = 'Create Account';
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String dontHaveAccount = "Don't have an account?";

  // Biometric
  static const String biometricPromptTitle = 'Authenticate';
  static const String biometricPromptSubtitle =
      'Use biometric to access VaultKey';
  static const String biometricPromptCancel = 'Cancel';

  // OTP
  static const String copyCode = 'Copy Code';
  static const String codeCopied = 'Code copied to clipboard';
  static const String addAuthenticator = 'Add Authenticator';
  static const String scanQRCode = 'Scan QR Code';
  static const String enterManually = 'Enter Manually';

  // Settings
  static const String settings = 'Settings';
  static const String appearance = 'Appearance';
  static const String security = 'Security';
  static const String backup = 'Backup & Sync';
  static const String about = 'About';
  static const String darkMode = 'Dark Mode';
  static const String lightMode = 'Light Mode';
  static const String systemDefault = 'System Default';

  // Errors
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError =
      'No internet connection. Please check your network.';
  static const String sessionExpired = 'Session expired. Please sign in again.';
  static const String invalidCredentials = 'Invalid email or password.';
  static const String weakPassword = 'Password is too weak.';
  static const String emailAlreadyInUse = 'Email is already in use.';
  static const String userNotFound = 'User not found.';

  // Validation
  static const String requiredField = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String passwordTooShort =
      'Password must be at least 8 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
}
