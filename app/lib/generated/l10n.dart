import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_ar.dart';
import 'l10n_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @onBoardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onBoardingSkip;

  /// No description provided for @onBoardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Reduce Waste. Discover Style.'**
  String get onBoardingTitle;

  /// No description provided for @onBoardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reserve discounted Style Boxes of surplus clothes from local stores and refresh your wardrobe for a fraction of the price.'**
  String get onBoardingSubtitle;

  /// No description provided for @onBoardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Smart Fashion. Zero Waste.'**
  String get onBoardingTitle2;

  /// No description provided for @onBoardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Discover overstock and end-of-season clothes at lower prices, and get styling tips with StyleBox’s AI style scan.'**
  String get onBoardingSubtitle2;

  /// No description provided for @onBoardingButtomText.
  ///
  /// In en, this message translates to:
  /// **'Start now'**
  String get onBoardingButtomText;

  /// No description provided for @onLoginLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get onLoginLogin;

  /// No description provided for @onLoginEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get onLoginEmail;

  /// No description provided for @onLoginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get onLoginPassword;

  /// No description provided for @onLoginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get onLoginForgotPassword;

  /// No description provided for @onLoginCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get onLoginCreateAccount;

  /// No description provided for @onLoginCreateAccountText.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get onLoginCreateAccountText;

  /// No description provided for @onLoginLoginOrDivider.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get onLoginLoginOrDivider;

  /// No description provided for @onLoginLoginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get onLoginLoginWithGoogle;

  /// No description provided for @onLoginLoginWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Login with Facebook'**
  String get onLoginLoginWithFacebook;

  /// No description provided for @onLoginLoginWithApple.
  ///
  /// In en, this message translates to:
  /// **'Login with Apple'**
  String get onLoginLoginWithApple;

  /// No description provided for @onSignupSignup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get onSignupSignup;

  /// No description provided for @onSignupName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get onSignupName;

  /// No description provided for @onSignupEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get onSignupEmail;

  /// No description provided for @onSignupPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get onSignupPassword;

  /// No description provided for @onSignupTermsandConditions.
  ///
  /// In en, this message translates to:
  /// **'By creating an account, you agree to '**
  String get onSignupTermsandConditions;

  /// No description provided for @onSignupTermsandConditionsText.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get onSignupTermsandConditionsText;

  /// No description provided for @onSignupTermsandConditionsText2.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get onSignupTermsandConditionsText2;

  /// No description provided for @onSignupTermsandConditionsText3.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get onSignupTermsandConditionsText3;

  /// No description provided for @onSignupTermsandConditionsErrorBar.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms and Conditions and Privacy Policy'**
  String get onSignupTermsandConditionsErrorBar;

  /// No description provided for @onSignupCreateNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get onSignupCreateNewAccount;

  /// No description provided for @onSignupCreateNewAccountText.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get onSignupCreateNewAccountText;

  /// No description provided for @onSignupCreateNewAccountText2.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get onSignupCreateNewAccountText2;

  /// No description provided for @onSignupTextFeils.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get onSignupTextFeils;

  /// No description provided for @homeViewWelcomeAppbar.
  ///
  /// In en, this message translates to:
  /// **'Good Morning !..'**
  String get homeViewWelcomeAppbar;

  /// No description provided for @homeBestSellersTitle.
  ///
  /// In en, this message translates to:
  /// **'Best Sellers'**
  String get homeBestSellersTitle;

  /// No description provided for @homeBestSellersViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get homeBestSellersViewAll;

  /// No description provided for @homeFeaturedItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Featured Item'**
  String get homeFeaturedItemTitle;

  /// No description provided for @homeFeaturedItemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Special Offer'**
  String get homeFeaturedItemSubtitle;

  /// No description provided for @homeFeaturedItemShopNow.
  ///
  /// In en, this message translates to:
  /// **'Shop Now'**
  String get homeFeaturedItemShopNow;

  /// No description provided for @buttonNavigationBarEntityHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get buttonNavigationBarEntityHome;

  /// No description provided for @buttonNavigationBarEntityProducts.
  ///
  /// In en, this message translates to:
  /// **'products'**
  String get buttonNavigationBarEntityProducts;

  /// No description provided for @buttonNavigationBarEntityCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get buttonNavigationBarEntityCart;

  /// No description provided for @buttonNavigationBarEntityProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get buttonNavigationBarEntityProfile;

  /// No description provided for @cartViewHeader.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cartViewHeader;

  /// No description provided for @checkOutViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkOutViewTitle;

  /// No description provided for @checkOutViewAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get checkOutViewAddress;

  /// No description provided for @checkOutViewPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get checkOutViewPayment;

  /// No description provided for @checkOutViewShipingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Cash On Delivery'**
  String get checkOutViewShipingTitle1;

  /// No description provided for @checkOutViewShipingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Delivery From Location'**
  String get checkOutViewShipingSubtitle1;

  /// No description provided for @checkOutViewShipingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Online Payment'**
  String get checkOutViewShipingTitle2;

  /// No description provided for @checkOutViewShipingPrice.
  ///
  /// In en, this message translates to:
  /// **' EGP'**
  String get checkOutViewShipingPrice;

  /// No description provided for @checkOutViewShipingError.
  ///
  /// In en, this message translates to:
  /// **'Please Select Payment Method'**
  String get checkOutViewShipingError;

  /// No description provided for @checkOutViewShipingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get checkOutViewShipingSubtitle2;

  /// No description provided for @checkOutViewPaymentMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get checkOutViewPaymentMethodTitle;

  /// No description provided for @checkOutViewSavedCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved card'**
  String get checkOutViewSavedCardTitle;

  /// No description provided for @checkOutViewUseSavedCard.
  ///
  /// In en, this message translates to:
  /// **'Use saved card'**
  String get checkOutViewUseSavedCard;

  /// No description provided for @checkOutViewDeleteCard.
  ///
  /// In en, this message translates to:
  /// **'Delete card'**
  String get checkOutViewDeleteCard;

  /// No description provided for @checkOutViewCardHolderName.
  ///
  /// In en, this message translates to:
  /// **'Cardholder name'**
  String get checkOutViewCardHolderName;

  /// No description provided for @checkOutViewEnterCardHolderName.
  ///
  /// In en, this message translates to:
  /// **'Enter cardholder name'**
  String get checkOutViewEnterCardHolderName;

  /// No description provided for @checkOutViewCardNumberOrSaved.
  ///
  /// In en, this message translates to:
  /// **'Card number or saved card'**
  String get checkOutViewCardNumberOrSaved;

  /// No description provided for @checkOutViewCardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get checkOutViewCardNumber;

  /// No description provided for @checkOutViewInvalidCardNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid card number'**
  String get checkOutViewInvalidCardNumber;

  /// No description provided for @checkOutViewInvalidExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid expiry date'**
  String get checkOutViewInvalidExpiryDate;

  /// No description provided for @checkOutViewInvalidCvv.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid CVV'**
  String get checkOutViewInvalidCvv;

  /// No description provided for @checkOutViewOnlySaveLast4.
  ///
  /// In en, this message translates to:
  /// **'Only the last 4 digits are stored on this device.'**
  String get checkOutViewOnlySaveLast4;

  /// No description provided for @checkOutViewPayWithPayPal.
  ///
  /// In en, this message translates to:
  /// **'Pay with PayPal'**
  String get checkOutViewPayWithPayPal;

  /// No description provided for @checkOutViewPayWithVisa.
  ///
  /// In en, this message translates to:
  /// **'Pay with Visa'**
  String get checkOutViewPayWithVisa;

  /// No description provided for @checkOutViewPlaceOrder.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get checkOutViewPlaceOrder;

  /// No description provided for @checkOutViewNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get checkOutViewNext;

  /// No description provided for @checkOutViewShipingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Pay with Visa'**
  String get checkOutViewShipingTitle3;

  /// No description provided for @checkOutViewShipingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'Card saved on this device only'**
  String get checkOutViewShipingSubtitle3;

  /// No description provided for @checkOutViewConfirmPaymentVisa.
  ///
  /// In en, this message translates to:
  /// **'Confirm payment'**
  String get checkOutViewConfirmPaymentVisa;

  /// No description provided for @checkOutViewConfirmPaymentVisaMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to pay with Visa?'**
  String get checkOutViewConfirmPaymentVisaMessage;

  /// No description provided for @checkOutViewConfirmOrderCash.
  ///
  /// In en, this message translates to:
  /// **'Place order'**
  String get checkOutViewConfirmOrderCash;

  /// No description provided for @checkOutViewVisaMissing.
  ///
  /// In en, this message translates to:
  /// **'Save your Visa card before paying.'**
  String get checkOutViewVisaMissing;

  /// No description provided for @visaDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Visa details'**
  String get visaDetailsTitle;

  /// No description provided for @visaDetailsCardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get visaDetailsCardNumber;

  /// No description provided for @visaDetailsCardHolder.
  ///
  /// In en, this message translates to:
  /// **'Name on card'**
  String get visaDetailsCardHolder;

  /// No description provided for @visaDetailsExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry (MM/YY)'**
  String get visaDetailsExpiry;

  /// No description provided for @visaDetailsCvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get visaDetailsCvv;

  /// No description provided for @visaDetailsSave.
  ///
  /// In en, this message translates to:
  /// **'Save and continue'**
  String get visaDetailsSave;

  /// No description provided for @visaDetailsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get visaDetailsDelete;

  /// No description provided for @visaDetailsSavedLabel.
  ///
  /// In en, this message translates to:
  /// **'Saved card'**
  String get visaDetailsSavedLabel;

  /// No description provided for @visaDetailsEndsWith.
  ///
  /// In en, this message translates to:
  /// **'Ends with {last4}'**
  String visaDetailsEndsWith(String last4);

  /// No description provided for @paymentSectionVisaHint.
  ///
  /// In en, this message translates to:
  /// **'You will confirm with your saved Visa card (not PayPal).'**
  String get paymentSectionVisaHint;

  /// No description provided for @orderSummaryWidgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Summary :'**
  String get orderSummaryWidgetTitle;

  /// No description provided for @orderSummaryWidgetSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal :'**
  String get orderSummaryWidgetSubtotal;

  /// No description provided for @orderSummaryWidgetShipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping :'**
  String get orderSummaryWidgetShipping;

  /// No description provided for @orderSummaryWidgetTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get orderSummaryWidgetTotal;

  /// No description provided for @orderCashSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Cash on delivery order placed successfully'**
  String get orderCashSuccessMessage;

  /// No description provided for @orderVisaSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Visa payment completed successfully'**
  String get orderVisaSuccessMessage;

  /// No description provided for @addressSummaryWidgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address :'**
  String get addressSummaryWidgetTitle;

  /// No description provided for @addressSummaryWidgetChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get addressSummaryWidgetChange;

  /// No description provided for @addressInputSectionName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get addressInputSectionName;

  /// No description provided for @addressInputSectionEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get addressInputSectionEmail;

  /// No description provided for @addressInputSectionPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get addressInputSectionPhone;

  /// No description provided for @addressInputSectionAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressInputSectionAddress;

  /// No description provided for @addressInputSectionCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get addressInputSectionCity;

  /// No description provided for @addressInputSectionFloor.
  ///
  /// In en, this message translates to:
  /// **'Floor Number , Apartment Number ..'**
  String get addressInputSectionFloor;

  /// No description provided for @profileViewLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileViewLanguage;

  /// No description provided for @profileViewLanguageValueItem.
  ///
  /// In en, this message translates to:
  /// **'Arabic Language'**
  String get profileViewLanguageValueItem;

  /// No description provided for @profileViewLanguageValueItem2.
  ///
  /// In en, this message translates to:
  /// **'English Language'**
  String get profileViewLanguageValueItem2;

  /// No description provided for @profileViewProfileImage.
  ///
  /// In en, this message translates to:
  /// **'Profile Image'**
  String get profileViewProfileImage;

  /// No description provided for @profileViewTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get profileViewTheme;

  /// No description provided for @profileViewFavourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get profileViewFavourites;

  /// No description provided for @profileViewLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileViewLogout;

  /// No description provided for @profileViewLogoutText.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get profileViewLogoutText;

  /// No description provided for @profileViewLogoutText2.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileViewLogoutText2;

  /// No description provided for @profileViewLogoutText3.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileViewLogoutText3;

  /// No description provided for @profileViewPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get profileViewPoints;

  /// No description provided for @pointsPageYourPoints.
  ///
  /// In en, this message translates to:
  /// **'Your Points'**
  String get pointsPageYourPoints;

  /// No description provided for @pointsPagePts.
  ///
  /// In en, this message translates to:
  /// **'pts'**
  String get pointsPagePts;

  /// No description provided for @pointsPageRewardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Rewards & Discounts'**
  String get pointsPageRewardsTitle;

  /// No description provided for @pointsPageDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get pointsPageDiscount;

  /// No description provided for @pointsPagePointsRequired.
  ///
  /// In en, this message translates to:
  /// **'points required'**
  String get pointsPagePointsRequired;

  /// No description provided for @pointsPageUnlocked.
  ///
  /// In en, this message translates to:
  /// **'UNLOCKED'**
  String get pointsPageUnlocked;

  /// No description provided for @pointsPageProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get pointsPageProgress;

  /// No description provided for @pointsPagePointsToGo.
  ///
  /// In en, this message translates to:
  /// **'points to go!'**
  String get pointsPagePointsToGo;

  /// No description provided for @pointsPageAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get pointsPageAdd;

  /// No description provided for @pointsPageDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get pointsPageDelete;

  /// No description provided for @productGridViewPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get productGridViewPlaceholder;

  /// No description provided for @searchProductsHint.
  ///
  /// In en, this message translates to:
  /// **'Search products'**
  String get searchProductsHint;

  /// No description provided for @loadDemoDataButton.
  ///
  /// In en, this message translates to:
  /// **'Load Demo Data'**
  String get loadDemoDataButton;

  /// No description provided for @demoDataLoadedMessage.
  ///
  /// In en, this message translates to:
  /// **'Demo data loaded! Go to Cart to test checkout.'**
  String get demoDataLoadedMessage;

  /// No description provided for @homeViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeViewTitle;

  /// No description provided for @logoutErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error occurred during logout'**
  String get logoutErrorMessage;

  /// Message shown when coupon discount is successfully applied
  ///
  /// In en, this message translates to:
  /// **'Discount applied: {discount} EGP'**
  String couponDiscountApplied(String discount);

  /// No description provided for @invalidCouponError.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired coupon code'**
  String get invalidCouponError;

  /// No description provided for @couponCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Coupon code'**
  String get couponCodeHint;

  /// No description provided for @errorPageNotFound.
  ///
  /// In en, this message translates to:
  /// **'404 Not Found'**
  String get errorPageNotFound;

  /// No description provided for @paymentSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Payment successful'**
  String get paymentSuccessMessage;

  /// No description provided for @paymentErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Payment error'**
  String get paymentErrorMessage;

  /// No description provided for @weakPasswordError.
  ///
  /// In en, this message translates to:
  /// **'The password provided is too weak.'**
  String get weakPasswordError;

  /// No description provided for @emailAlreadyInUseError.
  ///
  /// In en, this message translates to:
  /// **'The email address is already in use by another account.'**
  String get emailAlreadyInUseError;

  /// No description provided for @networkRequestFailedError.
  ///
  /// In en, this message translates to:
  /// **'Network request failed, please check your internet connection.'**
  String get networkRequestFailedError;

  /// No description provided for @invalidEmailError.
  ///
  /// In en, this message translates to:
  /// **'The email address is not valid.'**
  String get invalidEmailError;

  /// No description provided for @unknownErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred please try again later.'**
  String get unknownErrorMessage;

  /// No description provided for @emailPasswordProblemError.
  ///
  /// In en, this message translates to:
  /// **'There is a problem in email or password'**
  String get emailPasswordProblemError;

  /// No description provided for @signInCancelledError.
  ///
  /// In en, this message translates to:
  /// **'Sign-in cancelled by user'**
  String get signInCancelledError;

  /// No description provided for @googleSignInFailedError.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In failed'**
  String get googleSignInFailedError;

  /// No description provided for @availableBagsSwipeHint.
  ///
  /// In en, this message translates to:
  /// **'Swipe →'**
  String get availableBagsSwipeHint;

  /// No description provided for @bagCurrencySuffix.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get bagCurrencySuffix;

  /// No description provided for @bagCardReserve.
  ///
  /// In en, this message translates to:
  /// **'Reserve'**
  String get bagCardReserve;

  /// Number of Style Boxes still available
  ///
  /// In en, this message translates to:
  /// **'{count} Boxes left'**
  String bagCardBagsLeft(String count);

  /// No description provided for @bagDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Denim Style Box'**
  String get bagDetailsTitle;

  /// No description provided for @bagDetailsPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get bagDetailsPriceLabel;

  /// No description provided for @bagDetailsCurrentPrice.
  ///
  /// In en, this message translates to:
  /// **'350 EGP'**
  String get bagDetailsCurrentPrice;

  /// No description provided for @bagDetailsOldPrice.
  ///
  /// In en, this message translates to:
  /// **'700 EGP'**
  String get bagDetailsOldPrice;

  /// No description provided for @bagDetailsWhatInsideTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s in the box?'**
  String get bagDetailsWhatInsideTitle;

  /// No description provided for @bagDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'A surprise mix of 3–4 denim pieces, like jeans, a denim jacket or a shirt, in new-with-tags or like-new condition.'**
  String get bagDetailsDescription;

  /// No description provided for @bagDetailsReservePickup.
  ///
  /// In en, this message translates to:
  /// **'Reserve for pickup'**
  String get bagDetailsReservePickup;

  /// No description provided for @productsViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsViewTitle;

  /// No description provided for @availableBagsTitle.
  ///
  /// In en, this message translates to:
  /// **'Available boxes'**
  String get availableBagsTitle;

  /// No description provided for @restaurantNameMadbinaZamalek.
  ///
  /// In en, this message translates to:
  /// **'Cotton Corner - Zamalek'**
  String get restaurantNameMadbinaZamalek;

  /// Store branch count label
  ///
  /// In en, this message translates to:
  /// **'{count} branch'**
  String restaurantBranchesCount(String count);

  /// Distance to store in kilometers
  ///
  /// In en, this message translates to:
  /// **'{distance} kilometers'**
  String restaurantDistanceKilometers(String distance);

  /// No description provided for @bagTitleAroussaSandwich.
  ///
  /// In en, this message translates to:
  /// **'Denim Box'**
  String get bagTitleAroussaSandwich;

  /// No description provided for @bagTitleMasrawy.
  ///
  /// In en, this message translates to:
  /// **'Casual Box'**
  String get bagTitleMasrawy;

  /// No description provided for @statusBadgeAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get statusBadgeAvailable;

  /// No description provided for @statusBadgeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get statusBadgeUnavailable;

  /// No description provided for @statusBadgeNow.
  ///
  /// In en, this message translates to:
  /// **'Open now'**
  String get statusBadgeNow;

  /// No description provided for @statusBadgeClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get statusBadgeClosed;

  /// Number of results displayed in product header
  ///
  /// In en, this message translates to:
  /// **'{count} results'**
  String productViewResults(String count);

  /// No description provided for @couponPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Coupon'**
  String get couponPageTitle;

  /// No description provided for @couponCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Coupon Code'**
  String get couponCodeLabel;

  /// No description provided for @couponPageDescription.
  ///
  /// In en, this message translates to:
  /// **'Use this code to redeem your points'**
  String get couponPageDescription;

  /// No description provided for @couponCopyButton.
  ///
  /// In en, this message translates to:
  /// **'Copy Code'**
  String get couponCopyButton;

  /// No description provided for @couponCopiedMessage.
  ///
  /// In en, this message translates to:
  /// **'Coupon code copied!'**
  String get couponCopiedMessage;

  /// No description provided for @couponUniqueText.
  ///
  /// In en, this message translates to:
  /// **'This code is unique to your account'**
  String get couponUniqueText;

  /// No description provided for @bagelMysteryBagPickupOnlyBadge.
  ///
  /// In en, this message translates to:
  /// **'🛍️  Pickup Only'**
  String get bagelMysteryBagPickupOnlyBadge;

  /// No description provided for @bagelMysteryBagStoreName.
  ///
  /// In en, this message translates to:
  /// **'Urban Threads - Sheikh Zayed'**
  String get bagelMysteryBagStoreName;

  /// No description provided for @bagelMysteryBagTitle.
  ///
  /// In en, this message translates to:
  /// **'Style Box'**
  String get bagelMysteryBagTitle;

  /// Availability label for the Style Box
  ///
  /// In en, this message translates to:
  /// **'{count} available'**
  String bagelMysteryBagAvailableCount(String count);

  /// No description provided for @bagelMysteryBagDescription.
  ///
  /// In en, this message translates to:
  /// **'Surplus and end-of-season pieces with a surprise twist! Each Style Box contains 3–5 items, such as tops, jeans and accessories, in new or like-new condition - perfect for refreshing your wardrobe for less.'**
  String get bagelMysteryBagDescription;

  /// No description provided for @bagelMysteryBagPickupTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Pickup Time'**
  String get bagelMysteryBagPickupTimeLabel;

  /// No description provided for @bagelMysteryBagPickupTimeValue.
  ///
  /// In en, this message translates to:
  /// **'4:00 PM - 11:00 PM'**
  String get bagelMysteryBagPickupTimeValue;

  /// No description provided for @bagelMysteryBagLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get bagelMysteryBagLocationLabel;

  /// No description provided for @bagelMysteryBagLocationValue.
  ///
  /// In en, this message translates to:
  /// **'Arkan Plaza, Sheikh Zayed, Giza'**
  String get bagelMysteryBagLocationValue;

  /// No description provided for @bagelMysteryBagContactLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get bagelMysteryBagContactLabel;

  /// No description provided for @bagelMysteryBagIngredientsAndAllergens.
  ///
  /// In en, this message translates to:
  /// **'What\'s Inside & Sizes'**
  String get bagelMysteryBagIngredientsAndAllergens;

  /// No description provided for @bagelMysteryBagAllergenNotice.
  ///
  /// In en, this message translates to:
  /// **'Items and sizes vary in each box. The store did not specify sizes, please contact them to make sure.'**
  String get bagelMysteryBagAllergenNotice;

  /// No description provided for @bagelMysteryBagCustomerReviews.
  ///
  /// In en, this message translates to:
  /// **'Customer Reviews'**
  String get bagelMysteryBagCustomerReviews;

  /// No description provided for @bagelMysteryBagComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get bagelMysteryBagComingSoon;

  /// No description provided for @bagelMysteryBagReviewsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Customer reviews will be available soon to help you make informed decisions.'**
  String get bagelMysteryBagReviewsComingSoon;

  /// No description provided for @bagelMysteryBagReservedState.
  ///
  /// In en, this message translates to:
  /// **'✓  Reserved! See you at pickup'**
  String get bagelMysteryBagReservedState;

  /// No description provided for @bagSizesLabel.
  ///
  /// In en, this message translates to:
  /// **'Sizes'**
  String get bagSizesLabel;

  /// No description provided for @bagCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get bagCategoryLabel;

  /// No description provided for @categoryMen.
  ///
  /// In en, this message translates to:
  /// **'Men'**
  String get categoryMen;

  /// No description provided for @categoryWomen.
  ///
  /// In en, this message translates to:
  /// **'Women'**
  String get categoryWomen;

  /// No description provided for @categoryKids.
  ///
  /// In en, this message translates to:
  /// **'Kids'**
  String get categoryKids;

  /// No description provided for @categoryUnisex.
  ///
  /// In en, this message translates to:
  /// **'Unisex'**
  String get categoryUnisex;

  /// No description provided for @bagSizesNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Sizes not specified — contact the store'**
  String get bagSizesNotSpecified;

  /// No description provided for @aiChatClearButton.
  ///
  /// In en, this message translates to:
  /// **'Clear Chat'**
  String get aiChatClearButton;

  /// No description provided for @aiChatClearDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear all chat?'**
  String get aiChatClearDialogTitle;

  /// No description provided for @aiChatClearDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove all chat messages for this account.'**
  String get aiChatClearDialogMessage;

  /// No description provided for @aiChatActionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get aiChatActionCancel;

  /// No description provided for @aiChatActionClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get aiChatActionClear;

  /// No description provided for @aiChatClearSuccess.
  ///
  /// In en, this message translates to:
  /// **'All chat messages were cleared.'**
  String get aiChatClearSuccess;

  /// No description provided for @aiChatClearFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not clear chat. Please try again.'**
  String get aiChatClearFailed;

  /// No description provided for @aiChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Style Assistant'**
  String get aiChatTitle;

  /// No description provided for @aiChatInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask about style & Style Boxes...'**
  String get aiChatInputHint;

  /// No description provided for @foodScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Style Scan'**
  String get foodScanTitle;

  /// No description provided for @foodScanCameraButton.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get foodScanCameraButton;

  /// No description provided for @foodScanGalleryButton.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get foodScanGalleryButton;

  /// No description provided for @foodScanHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of a clothing item to analyze'**
  String get foodScanHeroTitle;

  /// No description provided for @foodScanHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Camera or Gallery'**
  String get foodScanHeroSubtitle;

  /// No description provided for @foodScanTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tips for better results:'**
  String get foodScanTipsTitle;

  /// No description provided for @foodScanTipGoodLighting.
  ///
  /// In en, this message translates to:
  /// **'Good lighting'**
  String get foodScanTipGoodLighting;

  /// No description provided for @foodScanTipMoveCloser.
  ///
  /// In en, this message translates to:
  /// **'Move closer'**
  String get foodScanTipMoveCloser;

  /// No description provided for @foodScanTipSimpleBackground.
  ///
  /// In en, this message translates to:
  /// **'Simple background'**
  String get foodScanTipSimpleBackground;

  /// No description provided for @foodScanTipNoBlur.
  ///
  /// In en, this message translates to:
  /// **'No blur'**
  String get foodScanTipNoBlur;

  /// No description provided for @foodScanAfterPickHint.
  ///
  /// In en, this message translates to:
  /// **'After selecting an image you can:'**
  String get foodScanAfterPickHint;

  /// No description provided for @foodScanFeatureNutrition.
  ///
  /// In en, this message translates to:
  /// **'Styling Tips'**
  String get foodScanFeatureNutrition;

  /// No description provided for @foodScanFeatureFreshness.
  ///
  /// In en, this message translates to:
  /// **'Condition Check'**
  String get foodScanFeatureFreshness;

  /// No description provided for @foodScanDetectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Detected'**
  String get foodScanDetectedLabel;

  /// Confidence percentage for clothing item detection
  ///
  /// In en, this message translates to:
  /// **'Confidence: {value}'**
  String foodScanConfidenceLabel(String value);

  /// No description provided for @foodScanCheckingFreshness.
  ///
  /// In en, this message translates to:
  /// **'Checking condition…'**
  String get foodScanCheckingFreshness;

  /// No description provided for @foodScanFreshnessSpoilageCheck.
  ///
  /// In en, this message translates to:
  /// **'Condition / Quality Check'**
  String get foodScanFreshnessSpoilageCheck;

  /// No description provided for @foodScanLowConfidenceMessage.
  ///
  /// In en, this message translates to:
  /// **'Result is not confident enough. Try another photo with better lighting.'**
  String get foodScanLowConfidenceMessage;

  /// No description provided for @reviewComposerTitle.
  ///
  /// In en, this message translates to:
  /// **'Share your experience'**
  String get reviewComposerTitle;

  /// No description provided for @reviewComposerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell others what was in your Style Box and how the pickup went.'**
  String get reviewComposerSubtitle;

  /// No description provided for @reviewComposerEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Review'**
  String get reviewComposerEditTitle;

  /// No description provided for @reviewComposerEditSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your review'**
  String get reviewComposerEditSubtitle;

  /// No description provided for @reviewComposerRatingLabel.
  ///
  /// In en, this message translates to:
  /// **'Your rating'**
  String get reviewComposerRatingLabel;

  /// No description provided for @reviewComposerCommentLabel.
  ///
  /// In en, this message translates to:
  /// **'Your comment'**
  String get reviewComposerCommentLabel;

  /// No description provided for @reviewComposerCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Tell others what you thought...'**
  String get reviewComposerCommentHint;

  /// No description provided for @reviewComposerSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit review'**
  String get reviewComposerSubmitButton;

  /// No description provided for @reviewComposerUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get reviewComposerUpdateButton;

  /// No description provided for @reviewComposerSelectRatingError.
  ///
  /// In en, this message translates to:
  /// **'Please choose a star rating.'**
  String get reviewComposerSelectRatingError;

  /// No description provided for @reviewComposerCommentRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please write a comment before submitting.'**
  String get reviewComposerCommentRequiredError;

  /// No description provided for @reviewComposerSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your review was submitted.'**
  String get reviewComposerSuccessMessage;

  /// No description provided for @reviewComposerFailureMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not submit your review. Please try again.'**
  String get reviewComposerFailureMessage;

  /// No description provided for @reviewComposerEditButton.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get reviewComposerEditButton;

  /// No description provided for @reviewComposerDeleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get reviewComposerDeleteButton;

  /// No description provided for @reviewComposerDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Review?'**
  String get reviewComposerDeleteConfirmTitle;

  /// No description provided for @reviewComposerDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your review?'**
  String get reviewComposerDeleteConfirmMessage;

  /// No description provided for @reviewComposerDeleteConfirmCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get reviewComposerDeleteConfirmCancel;

  /// No description provided for @reviewComposerDeleteConfirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get reviewComposerDeleteConfirmDelete;

  /// No description provided for @reviewComposerDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Error deleting review'**
  String get reviewComposerDeleteError;

  /// No description provided for @reviewComposerDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Review deleted successfully'**
  String get reviewComposerDeleteSuccess;

  /// No description provided for @reviewComposerNoReviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get reviewComposerNoReviewsTitle;

  /// No description provided for @reviewComposerNoReviewsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Be the first to share your experience!'**
  String get reviewComposerNoReviewsSubtitle;

  /// No description provided for @navScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get navScan;

  /// No description provided for @emptyHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'No Style Boxes yet'**
  String get emptyHomeTitle;

  /// No description provided for @emptyHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stores near you will post their surprise boxes here soon.'**
  String get emptyHomeSubtitle;

  /// No description provided for @emptyCartTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get emptyCartTitle;

  /// No description provided for @emptyCartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reserve a Style Box and it will show up here.'**
  String get emptyCartSubtitle;

  /// No description provided for @profileViewSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileViewSettingsTitle;

  /// No description provided for @homeHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Style for less'**
  String get homeHeroTitle;

  /// No description provided for @homeHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Surprise clothing boxes from stores near you, up to 70% off.'**
  String get homeHeroSubtitle;

  /// No description provided for @homeStoresTitle.
  ///
  /// In en, this message translates to:
  /// **'Stores near you'**
  String get homeStoresTitle;

  /// No description provided for @bagCardOff.
  ///
  /// In en, this message translates to:
  /// **'{percent}% OFF'**
  String bagCardOff(String percent);

  /// No description provided for @demoBoxNotice.
  ///
  /// In en, this message translates to:
  /// **'This is a demo box. Real boxes show up once stores add them from the dashboard.'**
  String get demoBoxNotice;

  /// No description provided for @mapTitle.
  ///
  /// In en, this message translates to:
  /// **'Stores map'**
  String get mapTitle;

  /// No description provided for @mapPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Find stores on the map'**
  String get mapPreviewTitle;

  /// No description provided for @mapPreviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} stores · tap to get directions'**
  String mapPreviewSubtitle(String count);

  /// No description provided for @mapNoStoresTitle.
  ///
  /// In en, this message translates to:
  /// **'No stores on the map yet'**
  String get mapNoStoresTitle;

  /// No description provided for @mapNoStoresSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stores appear here once they pin their location from the dashboard.'**
  String get mapNoStoresSubtitle;

  /// No description provided for @mapDemoBanner.
  ///
  /// In en, this message translates to:
  /// **'Sample stores. Real ones appear once they\'re added from the dashboard.'**
  String get mapDemoBanner;

  /// No description provided for @mapDirections.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get mapDirections;

  /// No description provided for @mapGoogleMaps.
  ///
  /// In en, this message translates to:
  /// **'Google Maps'**
  String get mapGoogleMaps;

  /// No description provided for @mapOpenNow.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get mapOpenNow;

  /// No description provided for @mapClosedNow.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get mapClosedNow;

  /// No description provided for @mapBoxesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} boxes'**
  String mapBoxesCount(String count);

  /// No description provided for @mapDistanceKm.
  ///
  /// In en, this message translates to:
  /// **'{distance} km'**
  String mapDistanceKm(String distance);

  /// No description provided for @mapRouteMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String mapRouteMinutes(String minutes);

  /// No description provided for @mapRouteStraightLine.
  ///
  /// In en, this message translates to:
  /// **'straight line'**
  String get mapRouteStraightLine;

  /// No description provided for @mapRouteLoading.
  ///
  /// In en, this message translates to:
  /// **'Finding the best route...'**
  String get mapRouteLoading;

  /// No description provided for @mapLocationDenied.
  ///
  /// In en, this message translates to:
  /// **'Allow location access so we can show the route from where you are.'**
  String get mapLocationDenied;

  /// No description provided for @mapLocationServiceOff.
  ///
  /// In en, this message translates to:
  /// **'Turn on location (GPS) to see the route.'**
  String get mapLocationServiceOff;

  /// No description provided for @mapLocationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get your location. Try again or open Google Maps.'**
  String get mapLocationUnavailable;

  /// No description provided for @mapOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get mapOpenSettings;

  /// No description provided for @mapGoogleMapsFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open Google Maps.'**
  String get mapGoogleMapsFailed;

  /// No description provided for @mapShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show all stores'**
  String get mapShowAll;

  /// No description provided for @mapMyLocation.
  ///
  /// In en, this message translates to:
  /// **'My location'**
  String get mapMyLocation;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return SAr();
    case 'en':
      return SEn();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
