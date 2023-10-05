/// Tüm Assets path leri buradan çekilecek
/// Proje içinde Herhangi bir path yazılmayacak

const String fontFamily = 'GreycliffCF';
const String assetsPath = 'assets/';

String getFlagPath(String countryCode) => 'assets/flags/${countryCode.toLowerCase()}.png';

String imageAssetsPath = 'assets/images/';

String myLocationImage = '${imageAssetsPath}my_location_image.png';
