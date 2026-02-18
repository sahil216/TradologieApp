enum UserType { supplier, buyer }

class EndPoints {
  static const String baseUrlWithoutApi = 'https://tradologie.com/';

  static const String supplierWebsiteurl =
      'https://supplier.tradologie.com/supplier';

  static const String supplierImageurl = 'https://supplier.tradologie.com';

  static const String baseUrlSupplier = 'https://api.tradologie.com/supplier';
  static const String baseUrlBuyer = 'https://api.tradologie.com/buyer';
  static const String baseUrl = 'https://api.tradologie.com';

  static const String buyerUrlWeb = 'https://buyer.tradologie.com';

  static const String termsUrl = 'https://www.tradologie.com/terms-of-use';

  static const String privacyUrl = 'https://www.tradologie.com/privacy-policy';

  // Register
  static String register = '$baseUrlSupplier/Register';

  // Force Update
  static String checkForceUpdate = '$baseUrlSupplier/AppForceUpdate';

  // Get Image
  static String getImage(String url) {
    return '$supplierImageurl/images/Auction/$url.webp';
  }

  // Login
  static String signIn(UserType userType) {
    return '$baseUrl/${userType.name}/login';
  }

  static String countryCodeList = '$baseUrlSupplier/GetOTPCountry';

  // Verify
  static String verifyOtp(UserType userType) {
    return '$baseUrl/${userType.name}/VerifyOTPForLogin';
  }

  static String verifyOtpBuyer(UserType userType) {
    return '$baseUrl/${userType.name}/VerifyOTPForLogin';
  }

  static String signOut(UserType userType) {
    return '$baseUrl/${userType.name}/Logout';
  }

  static String deleteAccount(UserType userType) {
    return userType == UserType.buyer
        ? '$baseUrl/${userType.name}/DeleteCustomerActive'
        : '$baseUrl/${userType.name}/DeleteVendorActive';
  }

  // Send OTP
  static String sendOtp(UserType userType) {
    return '$baseUrl/${userType.name}/SendOTPForLoginV1';
  }

  static String sendOtpBuyer(UserType userType) {
    return '$baseUrl/${userType.name}/SendOTPForCustomerLoginV1';
  }

  // Dashboard Data
  static String getLiveAuctionDashboard = '$baseUrlSupplier/GetLiveAuctionList';

  static String getCommodityList = '$baseUrlBuyer/CategoryForBuyer';
  // static String getAllList = '$baseUrlBuyer/AuctionItemddl';
  static String getAllList(UserType userType) {
    return userType == UserType.buyer
        ? '$baseUrl/${userType.name}/AuctionItemddl'
        : '$baseUrl/${userType.name}/AuctionItemddl';
  }

  static String addCustomerRequirement = '$baseUrlBuyer/AddCustomerRequirement';

  static String postVendorStockRequirement =
      '$baseUrlSupplier/AddVendorStockListing';

  // Negotiation
  static String getNegotiation(UserType userType) {
    return '$baseUrl/${userType.name}/auctionlist';
  }

  // Add Negotiation
  static String getCategoryList = '$baseUrlBuyer/category';
  static String addSupplierShortList = '$baseUrlBuyer/AddSupplierShortlist';
  static String deleteSupplierShortList =
      '$baseUrlBuyer/RemoveSupplierShortlist';
  static String supplierList = '$baseUrlBuyer/SupplierList';
  static String supplierShortListed = '$baseUrlBuyer/SupplierShortlisted';
  static String createAuction = '$baseUrlBuyer/CreateAuction';

  // My Account apis
  // Information
  static String getInformation = '$baseUrlSupplier/getinformation';
  static String saveInformation = '$baseUrlSupplier/saveinformation';

  //login control
  static String uploadVendorImage = '$baseUrlSupplier/uploadvendorimage';
  static String saveLoginControl = '$baseUrlSupplier/savelogincontrol';

  //company details
  static String getCompanyDetails = '$baseUrlSupplier/CompanyDetails';
  static String updateCompanyDetails = '$baseUrlSupplier/UpdateCompanyDetails';
  static String getCompanyType = '$baseUrlSupplier/Commonddl';
  static String getStateList = '$baseUrlSupplier/StateList';
  static String getCityList = '$baseUrlSupplier/citylist';
  static String getAreaList = '$baseUrlSupplier/arealist';
  static String getZipCode = '$baseUrlSupplier/zipcode';

  //Documents
  static String vendorDocumentDetail = '$baseUrlSupplier/VendorDocumentDetail';
  static String updateVendorDocument = '$baseUrlSupplier/UpdateVendorDocument';

  //Authorized person
  static String getAuthorizePersonList =
      '$baseUrlSupplier/GetAuthorizePersonList';
  static String saveAuthorizePersonDetail =
      '$baseUrlSupplier/SaveAuthorizePersonDetail';
  static String updateAuthorizeDocument =
      '$baseUrlSupplier/UpdateAuthorizeDocument';

  //legal documents
  static String getAgreementFileDetail =
      '$baseUrlSupplier/GetAgreementFileDetail';
  static String updateAgreementDetail =
      '$baseUrlSupplier/UpdateAgreementDetail';
  static String updateAgreementDocument =
      '$baseUrlSupplier/UpdateAgreementDocument';

  //Bank Details
  static String getBankDetail = '$baseUrlSupplier/GetBankDetail';
  static String saveBankDetail = '$baseUrlSupplier/UpdateBankDetail';
  static String updateBankDocument = '$baseUrlSupplier/UpdateBankDocument';

  //Selling Location
  static String getSellingLocationState =
      '$baseUrlSupplier/GetSellingLocationState';
  static String getSellingLocationCity =
      '$baseUrlSupplier/GetSellingLocationCity';
  static String getVendorSellingLocationDetail =
      '$baseUrlSupplier/GetVendorSellingLocationDetail';
  static String saveUpdateVendorSellingLocation =
      '$baseUrlSupplier/SaveUpdateVendorSellingLocation';
  static String deleteVendorSellingLocation =
      '$baseUrlSupplier/DeleteVendorSellingLocation';

  //Bulk and Retail
  static String getGroupDropDown = '$baseUrlSupplier/GetGroupDropDown';
  static String getRetailDetails = '$baseUrlSupplier/GetRetailDetails';
  static String saveUpdateBulkRetailDetail =
      '$baseUrlSupplier/SaveUpdateBulkRetailDetail';

  //  Notification
  static String getNotification(UserType userType) {
    return '$baseUrl/${userType.name}/FCMLogNotification';
  }
}
