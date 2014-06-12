lexer grammar radix;

// Radix notation: not in Java syntax, but defined for the
// Java function parseLong (http://docs.oracle.com/javase/7/docs/api/java/lang/Long.html#parseLong%28java.lang.String,%20int%29)
// Format from regex:  [1-9][0-9]?[rR]([0-9A-Za-z]+
// (but that's not enough; max radix is 36 (which accomodates a-z as digits)
// Examples:  2r10 = 2 dec; 16rFF = 0xFF = 255 dec
// for higher radices keep going after F, e.g.:
// 20rJ = 19 dec;  36rZ = 35 dec

RadixNumeral : ('+' | '-')? RadixLiteral ;

fragment
RadixLiteral
    :  Radix2Numeral  | Radix3Numeral  | Radix4Numeral  | Radix5Numeral
    |  Radix6Numeral  | Radix7Numeral  | Radix8Numeral  | Radix9Numeral
    |  Radix10Numeral | Radix11Numeral | Radix12Numeral | Radix13Numeral
    |  Radix14Numeral | Radix15Numeral | Radix16Numeral | Radix17Numeral
    |  Radix18Numeral | Radix19Numeral | Radix20Numeral | Radix21Numeral
    |  Radix22Numeral | Radix23Numeral | Radix24Numeral | Radix25Numeral
    |  Radix26Numeral | Radix27Numeral | Radix28Numeral | Radix29Numeral
    |  Radix30Numeral | Radix31Numeral | Radix32Numeral | Radix33Numeral
    |  Radix34Numeral | Radix35Numeral | Radix36Numeral
    ;

fragment Radix2Numeral  : '2'  [rR] [01]+  ;
fragment Radix3Numeral  : '3'  [rR] [012]+ ;
fragment Radix4Numeral  : '4'  [rR] [0-3]+ ;
fragment Radix5Numeral  : '5'  [rR] [0-4]+ ;
fragment Radix6Numeral  : '6'  [rR] [0-5]+ ;
fragment Radix7Numeral  : '7'  [rR] [0-6]+ ;
fragment Radix8Numeral  : '8'  [rR] [0-7]+ ;
fragment Radix9Numeral  : '9'  [rR] [0-8]+ ;
fragment Radix10Numeral : '10' [rR] [0-9]+ ;
fragment Radix11Numeral : '11' [rR] [0-9Aa]+     ;
fragment Radix12Numeral : '12' [rR] [0-9AaBb]+   ;
fragment Radix13Numeral : '13' [rR] [0-9A-Ca-c]+ ;
fragment Radix14Numeral : '14' [rR] [0-9A-Da-d]+ ;
fragment Radix15Numeral : '15' [rR] [0-9A-Ea-e]+ ;
fragment Radix16Numeral : '16' [rR] [0-9A-Fa-f]+ ;
fragment Radix17Numeral : '17' [rR] [0-9A-Ga-g]+ ;
fragment Radix18Numeral : '18' [rR] [0-9A-Ha-h]+ ;
fragment Radix19Numeral : '19' [rR] [0-9A-Ia-i]+ ;
fragment Radix20Numeral : '20' [rR] [0-9A-Ja-j]+ ;
fragment Radix21Numeral : '21' [rR] [0-9A-Ka-k]+ ;
fragment Radix22Numeral : '22' [rR] [0-9A-La-l]+ ;
fragment Radix23Numeral : '23' [rR] [0-9A-Ma-m]+ ;
fragment Radix24Numeral : '24' [rR] [0-9A-Na-n]+ ;
fragment Radix25Numeral : '25' [rR] [0-9A-Oa-o]+ ;
fragment Radix26Numeral : '26' [rR] [0-9A-Pa-p]+ ;
fragment Radix27Numeral : '27' [rR] [0-9A-Qa-q]+ ;
fragment Radix28Numeral : '28' [rR] [0-9A-Ra-r]+ ;
fragment Radix29Numeral : '29' [rR] [0-9A-Sa-s]+ ;
fragment Radix30Numeral : '30' [rR] [0-9A-Ta-t]+ ;
fragment Radix31Numeral : '31' [rR] [0-9A-Ua-u]+ ;
fragment Radix32Numeral : '32' [rR] [0-9A-Va-v]+ ;
fragment Radix33Numeral : '33' [rR] [0-9A-Wa-w]+ ;
fragment Radix34Numeral : '34' [rR] [0-9A-Xa-x]+ ;
fragment Radix35Numeral : '35' [rR] [0-9A-Ya-y]+ ;
fragment Radix36Numeral : '36' [rR] [0-9A-Za-z]+ ;

BadRadix : ('+' | '-')? ([2-9]|([123][0-9])) [rR] ~[ \t\r\n]+ ;

