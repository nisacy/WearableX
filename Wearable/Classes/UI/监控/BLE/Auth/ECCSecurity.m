//
//  ECCSecurity.m
//  Wearable
//
//  Created by Admin on 2017/2/27.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import "ECCSecurity.h"
#import "Security/SecBase.h"
#import "Security/SecItem.h"
#import "openssl/ssl.h"
#import "openssl/x509v3.h"
#import "GMEllipticCurveCrypto.h"
#import "GMEllipticCurveCrypto+hash.h"

Byte signer_cert[]  = {
    0x30,  0x82,  0x01,  0xD7,  0x30,  0x82,  0x01,  0x7E,  0xA0,  0x03,  0x02,  0x01,  0x02,  0x02,  0x11,  0x5C,
    0x13,  0xF6,  0xF9,  0xB9,  0x75,  0x36,  0x75,  0x6A,  0x42,  0x41,  0xD1,  0x48,  0x96,  0xA1,  0x87,  0x01,
    0x30,  0x0A,  0x06,  0x08,  0x2A,  0x86,  0x48,  0xCE,  0x3D,  0x04,  0x03,  0x02,  0x30,  0x2F,  0x31,  0x11,
    0x30,  0x0F,  0x06,  0x03,  0x55,  0x04,  0x0A,  0x0C,  0x08,  0x54,  0x72,  0x61,  0x69,  0x6E,  0x69,  0x6E,
    0x67,  0x31,  0x1A,  0x30,  0x18,  0x06,  0x03,  0x55,  0x04,  0x03,  0x0C,  0x11,  0x41,  0x54,  0x45,  0x43,
    0x43,  0x35,  0x30,  0x38,  0x41,  0x20,  0x52,  0x6F,  0x6F,  0x74,  0x20,  0x43,  0x41,  0x30,  0x20,  0x17,
    0x0D,  0x31,  0x37,  0x30,  0x31,  0x31,  0x39,  0x30,  0x33,  0x30,  0x30,  0x30,  0x30,  0x5A,  0x18,  0x0F,
    0x39,  0x39,  0x39,  0x39,  0x31,  0x32,  0x33,  0x31,  0x32,  0x33,  0x35,  0x39,  0x35,  0x39,  0x5A,  0x30,
    0x42,  0x31,  0x11,  0x30,  0x0F,  0x06,  0x03,  0x55,  0x04,  0x0A,  0x0C,  0x08,  0x54,  0x72,  0x61,  0x69,
    0x6E,  0x69,  0x6E,  0x67,  0x31,  0x2D,  0x30,  0x2B,  0x06,  0x03,  0x55,  0x04,  0x03,  0x0C,  0x24,  0x50,
    0x72,  0x6F,  0x76,  0x69,  0x73,  0x69,  0x6F,  0x6E,  0x20,  0x54,  0x65,  0x73,  0x74,  0x20,  0x41,  0x54,
    0x45,  0x43,  0x43,  0x35,  0x30,  0x38,  0x41,  0x20,  0x53,  0x69,  0x67,  0x6E,  0x65,  0x72,  0x20,  0x35,
    0x30,  0x30,  0x41,  0x30,  0x59,  0x30,  0x13,  0x06,  0x07,  0x2A,  0x86,  0x48,  0xCE,  0x3D,  0x02,  0x01,
    0x06,  0x08,  0x2A,  0x86,  0x48,  0xCE,  0x3D,  0x03,  0x01,  0x07,  0x03,  0x42,  0x00,  0x04,  0x19,  0xD1,
    0x41,  0x4C,  0x7B,  0xF5,  0x46,  0xAA,  0xF8,  0x6C,  0x22,  0xB7,  0x9F,  0x6A,  0xBF,  0x3A,  0xA7,  0x8E,
    0x03,  0x70,  0xD4,  0x0B,  0x28,  0x8F,  0x31,  0x44,  0x24,  0x9C,  0x7C,  0x3E,  0x99,  0xEA,  0xE8,  0xF3,
    0xA2,  0x46,  0xBA,  0x4E,  0xCB,  0x4B,  0x05,  0x13,  0x7A,  0xFA,  0x07,  0xC6,  0x51,  0x5F,  0x8A,  0x8F,
    0x93,  0xED,  0xB8,  0xB2,  0xC3,  0x01,  0x3C,  0x34,  0x58,  0x11,  0x81,  0x79,  0xC6,  0x16,  0xA3,  0x66,
    0x30,  0x64,  0x30,  0x12,  0x06,  0x03,  0x55,  0x1D,  0x13,  0x01,  0x01,  0xFF,  0x04,  0x08,  0x30,  0x06,
    0x01,  0x01,  0xFF,  0x02,  0x01,  0x00,  0x30,  0x0E,  0x06,  0x03,  0x55,  0x1D,  0x0F,  0x01,  0x01,  0xFF,
    0x04,  0x04,  0x03,  0x02,  0x02,  0x84,  0x30,  0x1D,  0x06,  0x03,  0x55,  0x1D,  0x0E,  0x04,  0x16,  0x04,
    0x14,  0xA6,  0x87,  0x3D,  0x89,  0xD7,  0x11,  0x67,  0x0F,  0x9E,  0x24,  0xC2,  0xA6,  0xFD,  0x41,  0xB2,
    0x99,  0x27,  0xC6,  0x80,  0x02,  0x30,  0x1F,  0x06,  0x03,  0x55,  0x1D,  0x23,  0x04,  0x18,  0x30,  0x16,
    0x80,  0x14,  0x37,  0x0A,  0xA1,  0x3A,  0xEB,  0xEB,  0xCF,  0x09,  0x89,  0x70,  0x82,  0x6B,  0x3A,  0xB2,
    0x74,  0xFB,  0x96,  0x72,  0x68,  0xD3,  0x30,  0x0A,  0x06,  0x08,  0x2A,  0x86,  0x48,  0xCE,  0x3D,  0x04,
    0x03,  0x02,  0x03,  0x47,  0x00,  0x30,  0x44,  0x02,  0x20,  0x2A,  0x5E,  0x8B,  0x83,  0x74,  0xFF,  0x71,
    0x03,  0xCB,  0xD6,  0x61,  0x45,  0x65,  0x34,  0x98,  0xFB,  0xDE,  0xA6,  0x0F,  0x00,  0x50,  0x89,  0x6E,
    0x0A,  0x71,  0x65,  0x92,  0xA9,  0xE3,  0xE4,  0x50,  0x8A,  0x02,  0x20,  0x2A,  0xB0,  0xF6,  0x1A,  0xA1,
    0x58,  0x07,  0xB9,  0xF3,  0x52,  0x79,  0x74,  0xF7,  0xDE,  0xF9,  0xBA,  0x53,  0x4F,  0x73,  0xB9,  0x92,
    0x9F,  0x45,  0xFD,  0x66,  0x19,  0x7F,  0x8E,  0x31,  0x91,  0x9B,  0xF5
};


Byte device_cert[] = {
    0x30,  0x82,  0x01,  0xA4,  0x30,  0x82,  0x01,  0x49,  0xA0,  0x03,  0x02,  0x01,  0x02,  0x02,  0x11,  0x40,
    0x01,  0x02,  0x03,  0x04,  0x05,  0x06,  0x07,  0x08,  0x09,  0x0A,  0x0B,  0x0C,  0x0D,  0x0E,  0x0F,  0x02,
    0x30,  0x0A,  0x06,  0x08,  0x2A,  0x86,  0x48,  0xCE,  0x3D,  0x04,  0x03,  0x02,  0x30,  0x42,  0x31,  0x11,
    0x30,  0x0F,  0x06,  0x03,  0x55,  0x04,  0x0A,  0x0C,  0x08,  0x54,  0x72,  0x61,  0x69,  0x6E,  0x69,  0x6E,
    0x67,  0x31,  0x2D,  0x30,  0x2B,  0x06,  0x03,  0x55,  0x04,  0x03,  0x0C,  0x24,  0x50,  0x72,  0x6F,  0x76,
    0x69,  0x73,  0x69,  0x6F,  0x6E,  0x20,  0x54,  0x65,  0x73,  0x74,  0x20,  0x41,  0x54,  0x45,  0x43,  0x43,
    0x35,  0x30,  0x38,  0x41,  0x20,  0x53,  0x69,  0x67,  0x6E,  0x65,  0x72,  0x20,  0x35,  0x30,  0x30,  0x41,
    0x30,  0x20,  0x17,  0x0D,  0x31,  0x35,  0x31,  0x32,  0x31,  0x36,  0x30,  0x32,  0x35,  0x31,  0x33,  0x37,
    0x5A,  0x18,  0x0F,  0x39,  0x39,  0x39,  0x39,  0x31,  0x32,  0x33,  0x31,  0x32,  0x33,  0x35,  0x39,  0x35,
    0x39,  0x5A,  0x30,  0x3D,  0x31,  0x11,  0x30,  0x0F,  0x06,  0x03,  0x55,  0x04,  0x0A,  0x0C,  0x08,  0x54,
    0x72,  0x61,  0x69,  0x6E,  0x69,  0x6E,  0x67,  0x31,  0x28,  0x30,  0x26,  0x06,  0x03,  0x55,  0x04,  0x03,
    0x0C,  0x1F,  0x50,  0x72,  0x6F,  0x76,  0x69,  0x73,  0x69,  0x6F,  0x6E,  0x20,  0x54,  0x65,  0x73,  0x74,
    0x20,  0x41,  0x54,  0x45,  0x43,  0x43,  0x35,  0x30,  0x38,  0x41,  0x20,  0x44,  0x65,  0x76,  0x69,  0x63,
    0x65,  0x30,  0x59,  0x30,  0x13,  0x06,  0x07,  0x2A,  0x86,  0x48,  0xCE,  0x3D,  0x02,  0x01,  0x06,  0x08,
    0x2A,  0x86,  0x48,  0xCE,  0x3D,  0x03,  0x01,  0x07,  0x03,  0x42,  0x00,  0x04,  0x81,  0x9A,  0x9B,  0x76,
    0x23,  0xE3,  0x20,  0xE9,  0x85,  0x6D,  0x74,  0xEE,  0xCC,  0x94,  0x60,  0x06,  0xDB,  0x7E,  0x64,  0xE3,
    0x86,  0xB3,  0x3B,  0xF5,  0x08,  0x42,  0x47,  0x39,  0x8E,  0x5D,  0xD3,  0x22,  0xAF,  0x5B,  0xDC,  0x57,
    0xBB,  0xC6,  0xC0,  0xD2,  0x18,  0xF8,  0x82,  0x01,  0x2F,  0x1E,  0x3B,  0xDA,  0xF7,  0xF2,  0xED,  0x22,
    0xAA,  0xCA,  0x88,  0xF5,  0x7C,  0x3A,  0xEE,  0x5A,  0x3C,  0x3E,  0x1D,  0xF5,  0xA3,  0x23,  0x30,  0x21,
    0x30,  0x1F,  0x06,  0x03,  0x55,  0x1D,  0x23,  0x04,  0x18,  0x30,  0x16,  0x80,  0x14,  0xA6,  0x87,  0x3D,
    0x89,  0xD7,  0x11,  0x67,  0x0F,  0x9E,  0x24,  0xC2,  0xA6,  0xFD,  0x41,  0xB2,  0x99,  0x27,  0xC6,  0x80,
    0x02,  0x30,  0x0A,  0x06,  0x08,  0x2A,  0x86,  0x48,  0xCE,  0x3D,  0x04,  0x03,  0x02,  0x03,  0x49,  0x00,
    0x30,  0x46,  0x02,  0x21,  0x00,  0xC3,  0x10,  0x54,  0xB6,  0x26,  0xE1,  0x02,  0x0B,  0x9E,  0xA8,  0x02,
    0xE7,  0xA4,  0x58,  0x0F,  0xC3,  0x94,  0x80,  0xA4,  0x64,  0xB2,  0xC8,  0x0A,  0x50,  0xE2,  0x69,  0x71,
    0x87,  0x32,  0x4B,  0xC3,  0xAA,  0x02,  0x21,  0x00,  0x84,  0xA2,  0x28,  0xED,  0xAB,  0x1D,  0xA9,  0x9A,
    0x16,  0x36,  0x77,  0x2A,  0x1E,  0xE0,  0xBB,  0x3B,  0x1F,  0x4B,  0xCF,  0xBC,  0x6B,  0xD2,  0x54,  0xBA,
    0xB7,  0x5F,  0x79,  0xBB,  0x56,  0x44,  0x30,  0xE4
};

@implementation ECCSecurity
- (void)uint8_to_hex_str:(uint8_t)num hex_str:(uint8_t*)hex_str
{
    uint8_t nibble = (num >> 4) & 0x0F;
    
    if (nibble < 10)
        *(hex_str++) = '0' + nibble;
    else
        *(hex_str++) = 'A' + (nibble - 10);
    nibble = num & 0x0F;
    if (nibble < 10)
        *(hex_str++) = '0' + nibble;
    else
        *(hex_str++) = 'A' + (nibble - 10);
}

- (uint8_t*)uint_to_str:(uint32_t)num width:(int)width str:(uint8_t*)str
{
    uint8_t* ret = str + width;
    int i;
    
    // Pre-fill the string width with zeros
    for (i = 0; i < width; i++)
        *(str++) = '0';
    // Convert the number from right to left
    for (; num; num /= 10)
        *(--str) = '0' + (num % 10);
    
    return ret;
}

- (int) atcacert_date_enc_rfc5280_gen:(atcacert_tm_utc_t*)timestamp
                       formatted_date:(uint8_t*)formatted_date
{
    uint8_t* cur_pos = formatted_date;
    int year = 0;
    
    if (timestamp == NULL || formatted_date == NULL)
        return 1;
    
    year = timestamp->tm_year + 1900;
    
    if (year < 0 || year > 9999)
        return 1;
    cur_pos = [self uint_to_str:year width:4 str:cur_pos];
    
    if (timestamp->tm_mon < 0 || timestamp->tm_mon > 11)
        return 1;
    cur_pos = [self uint_to_str:(timestamp->tm_mon + 1) width:2 str:cur_pos];
  
    if (timestamp->tm_mday < 1 || timestamp->tm_mday > 31)
        return 1;
    cur_pos = [self uint_to_str:timestamp->tm_mday width:2 str:cur_pos];
    
    if (timestamp->tm_hour < 0 || timestamp->tm_hour > 23)
        return 1;
    cur_pos = [self uint_to_str:timestamp->tm_hour width:2 str:cur_pos];
    
    if (timestamp->tm_min < 0 || timestamp->tm_min > 59)
        return 1;
    cur_pos = [self uint_to_str:timestamp->tm_min width:2 str:cur_pos];
    
    if (timestamp->tm_sec < 0 || timestamp->tm_sec > 59)
        return 1;
    cur_pos = [self uint_to_str:timestamp->tm_sec width:2 str:cur_pos];
    
    *(cur_pos++) = 'Z';
    
    return 0;
}

- (int)atcacert_date_enc_rfc5280_utc:(atcacert_tm_utc_t*)timestamp
                      formatted_date:(uint8_t*)formatted_date
{
    uint8_t* cur_pos = formatted_date;
    int year = 0;
    
    if (timestamp == NULL || formatted_date == NULL)
        return 1;
    
    year = timestamp->tm_year + 1900;
    
    if (year >= 1950 && year <= 1999)
        year = year - 1900;
    else if (year >= 2000 && year <= 2049)
        year = year - 2000;
    else
        return 1;  // Year out of range for RFC2459 UTC format
    cur_pos = [self uint_to_str:year width:2 str:cur_pos];
    
    if (timestamp->tm_mon < 0 || timestamp->tm_mon > 11)
        return 1;
    cur_pos = [self uint_to_str:(timestamp->tm_mon + 1) width:2 str:cur_pos];
    
    if (timestamp->tm_mday < 1 || timestamp->tm_mday > 31)
        return 1;
    cur_pos = [self uint_to_str:timestamp->tm_mday width:2 str:cur_pos];
    
    if (timestamp->tm_hour < 0 || timestamp->tm_hour > 23)
        return 1;
    cur_pos = [self uint_to_str:timestamp->tm_hour width:2 str:cur_pos];
    
    if (timestamp->tm_min < 0 || timestamp->tm_min > 59)
        return 1;
    cur_pos = [self uint_to_str:timestamp->tm_min width:2 str:cur_pos];
    
    if (timestamp->tm_sec < 0 || timestamp->tm_sec > 59)
        return 1;
    cur_pos = [self uint_to_str:timestamp->tm_sec width:2 str:cur_pos];
    
    *(cur_pos++) = 'Z';
    
    return 0;
}

- (atcacert_tm_utc_t)date_get_max_date:(atcacert_date_format_t)format
{
    
    atcacert_tm_utc_t timestamp;
    
    switch (format) {
        case DATEFMT_ISO8601_SEP:
            timestamp.tm_year = 9999 - 1900;
            timestamp.tm_mon = 12 - 1;
            timestamp.tm_mday = 31;
            timestamp.tm_hour = 23;
            timestamp.tm_min = 59;
            timestamp.tm_sec = 59;
            break;
            
        case DATEFMT_RFC5280_UTC:
            timestamp.tm_year = 2049 - 1900;
            timestamp.tm_mon = 12 - 1;
            timestamp.tm_mday = 31;
            timestamp.tm_hour = 23;
            timestamp.tm_min = 59;
            timestamp.tm_sec = 59;
            break;
            
        case DATEFMT_POSIX_UINT32_BE:
            timestamp.tm_year = 2106 - 1900;
            timestamp.tm_mon = 2 - 1;
            timestamp.tm_mday = 7;
            timestamp.tm_hour = 6;
            timestamp.tm_min = 28;
            timestamp.tm_sec = 15;
            break;
            
        case DATEFMT_POSIX_UINT32_LE:
            timestamp.tm_year = 2106 - 1900;
            timestamp.tm_mon = 2 - 1;
            timestamp.tm_mday = 7;
            timestamp.tm_hour = 6;
            timestamp.tm_min = 28;
            timestamp.tm_sec = 15;
            break;
            
        case DATEFMT_RFC5280_GEN:
            timestamp.tm_year = 9999 - 1900;
            timestamp.tm_mon = 12 - 1;
            timestamp.tm_mday = 31;
            timestamp.tm_hour = 23;
            timestamp.tm_min = 59;
            timestamp.tm_sec = 59;
            break;
            
        default:
            timestamp.tm_year = 9999 - 1900;
            timestamp.tm_mon = 12 - 1;
            timestamp.tm_mday = 31;
            timestamp.tm_hour = 23;
            timestamp.tm_min = 59;
            timestamp.tm_sec = 59;
            break;
    }
    
    return timestamp;
}


- (int)atcacert_der_enc_ecdsa_sig_value:(uint8_t*)raw_sig
                                der_sig:(uint8_t*)der_sig
                           der_sig_size:(size_t* )der_sig_size
{
    int ret = 0;
    size_t r_size = 0;
    size_t s_size = 0;
    size_t der_sig_size_calc = 0;
    
    if (raw_sig == NULL || der_sig_size == NULL)
        return 1;
    
    // Find size of the DER encoded R integer
    ret = [self atcacert_der_enc_integer:&raw_sig[0] int_data_size:32 der_int:NULL der_int_size:&r_size];
    if (ret != 0)
        return ret;
    
    // Find size of the DER encoded S integer
    ret = [self atcacert_der_enc_integer:&raw_sig[32] int_data_size:32 der_int:NULL der_int_size:&s_size];
    if (ret != 0)
        return ret;
    
    // This calculation assumes all DER lengths are a single byte, which is fine for 32 byte
    // R and S integers.
    der_sig_size_calc = 5 + r_size + s_size;
    
    if (der_sig != NULL && *der_sig_size < der_sig_size_calc) {
        *der_sig_size = der_sig_size_calc;
        return 1;
    }
    
    *der_sig_size = der_sig_size_calc;
    
    if (der_sig == NULL)
        return 0;                  // Caller just wanted the encoded size
    
    der_sig[0] = 0x03;                              // signatureValue bit string tag
    der_sig[1] = (uint8_t)(der_sig_size_calc - 2);  // signatureValue bit string length
    der_sig[2] = 0x00;                              // signatureValue bit string spare bits
    
    // signatureValue bit string value is the DER encoding of ECDSA-Sig-Value
    der_sig[3] = 0x30;                              // sequence tag
    der_sig[4] = (uint8_t)(der_sig_size_calc - 5);  // sequence length
    
    // Add R integer
    ret = [self atcacert_der_enc_integer:&raw_sig[0] int_data_size:32 der_int:&der_sig[5] der_int_size:&r_size];
    if (ret != 0)
        return ret;
    
    // Add S integer
    ret = [self atcacert_der_enc_integer:&raw_sig[32] int_data_size:32 der_int:&der_sig[5 + r_size] der_int_size:&s_size];
    if (ret != 0)
        return ret;
    
    return 0;
}

- (int) atcacert_der_enc_integer:(const uint8_t*)int_data
                   int_data_size:(size_t)int_data_size
                         der_int:(uint8_t*)der_int
                    der_int_size:(size_t*)der_int_size
{
    uint8_t der_length[5];
    size_t der_length_size = sizeof(der_length);
    size_t der_int_size_calc = 0;
    size_t trim = 0;
    size_t pad = 0;
    
    if (!(int_data[0] & 0x80)) {
        // This is not an unsigned value that needs a padding byte, trim any unnecessary bytes.
        // Trim a byte when the upper 9 bits are all 0s or all 1s.
        while (
               (int_data_size - trim >= 2) && (
                                               ((int_data[trim] == 0x00) && ((int_data[trim + 1] & 0x80) == 0)) ||
                                               ((int_data[trim] == 0xFF) && ((int_data[trim + 1] & 0x80) != 0))))
            trim++;
    }else
        // Will be adding extra byte for unsigned padding so it's not interpreted as negative
        pad = 1;
    
    int ret = [self atcacert_der_enc_length:(int_data_size + pad - trim) der_length:der_length der_length_size:&der_length_size];
    if (ret != 0)
        return ret;
    der_int_size_calc = 1 + der_length_size + int_data_size + pad - trim;
    
    if (der_int != NULL && der_int_size_calc > *der_int_size) {
        *der_int_size = der_int_size_calc;
        return 1;
    }
    
    *der_int_size = der_int_size_calc;
    
    if (der_int == NULL)
        return 0;                                                      // Caller just wanted the size of the encoded integer
    
    der_int[0] = 0x02;                                                                  // Integer tag
    memcpy(&der_int[1], der_length, der_length_size);                                   // Integer length
    if (pad)
        der_int[der_length_size + 1] = 0;                                               // Unsigned integer value requires padding byte so it's not interpreted as negative
    memcpy(&der_int[der_length_size + 1 + pad], &int_data[trim], int_data_size - trim); // Integer value
    
    return 0;
}

-(int) atcacert_der_enc_length:(uint32_t)
length der_length:(uint8_t*)
der_length der_length_size:(size_t*) der_length_size
{
    size_t der_length_size_calc = 0;
    int exp = sizeof(length) - 1;
    
    if (length < 0x80) {
        // The length can take the short form with only one byte
        der_length_size_calc = 1;
        exp = 0;
    }else {
        // Length is long-form, encoded as a multi-byte big-endian unsigned integer
        
        // Find first non-zero octet
        while (length / ((uint32_t)1 << (8 * exp)) == 0)
            exp--;
        
        der_length_size_calc = 2 + exp;
    }
    
    if (der_length != NULL && *der_length_size < der_length_size_calc) {
        *der_length_size = der_length_size_calc;
        return 1;
    }
    
    *der_length_size = der_length_size_calc;
    
    if (der_length == NULL)
        return 0; // Caller is only requesting the size
    
    // Encode length in big-endian format
    for (; exp >= 0; exp--)
        der_length[der_length_size_calc - 1 - exp] = (uint8_t)((length >> (exp * 8)) & 0xFF);
    
    if (der_length_size_calc > 1)
        der_length[0] = 0x80 | (uint8_t)(der_length_size_calc - 1); // Set number of bytes octet with long-form flag
    
    return 0;
}


//    static byte[] signer_pubkey = hexTextToBytes("19D1414C7BF546AAF86C22B79F6ABF3AA78E0370D40B288F3144249C7C3E99EAE8F3A246BA4ECB4B05137AFA07C6515F8A8F93EDB8B2C3013C3458118179C616");
//   static byte[] device_pubkey = hexTextToBytes("AC9DE46DCCA7E00F52FA5780D827409E53BA4BBF804B53334341218042FB56EA618BABB04DBF383BF9B7ED4318171959E0A5FD1744104DD46775217F02FF4849");
//    static byte[] signer_compcert = hexTextToBytes("2A5E8B8374FF7103CBD66145653498FBDEA60F0050896E0A716592A9E3E4508A2AB0F61AA15807B9F3527974F7DEF9BA534F73B9929F45FD66197F8E31919BF588CC60500A10A000");
//    static byte[] device_compcert = hexTextToBytes("D9AE53E44EF644CFAFC7550741F791D99163C9463BF5E9EB5110D248278ACAAF811A22263BA0D64A22115B2150896DE65D908025950EF944A64C39A44F4F801B8918C0500A20A000");
//    
//   X509Certificate deviceX509cert;



- (void)init_signer_cert_def:(atcacert_def_t*)signer_cert_def device_cert_def:(atcacert_def_t*)device_cert_def
{
    signer_cert_def->issue_date_format = DATEFMT_RFC5280_UTC;
    signer_cert_def->expire_date_format = DATEFMT_RFC5280_GEN;
    signer_cert_def->tbs_cert_loc.offset = 4;
    signer_cert_def->tbs_cert_loc.count = 386;
    signer_cert_def->std_cert_elements[STDCERT_PUBLIC_KEY].offset = 222;
    signer_cert_def->std_cert_elements[STDCERT_PUBLIC_KEY].count = 64;
    signer_cert_def->std_cert_elements[STDCERT_SIGNATURE].offset = 402;
    signer_cert_def->std_cert_elements[STDCERT_SIGNATURE].count = 74;
    signer_cert_def->std_cert_elements[STDCERT_ISSUE_DATE].offset = 97;
    signer_cert_def->std_cert_elements[STDCERT_ISSUE_DATE].count = 13;
    signer_cert_def->std_cert_elements[STDCERT_EXPIRE_DATE].offset = 112;
    signer_cert_def->std_cert_elements[STDCERT_EXPIRE_DATE].count = 15;
    signer_cert_def->std_cert_elements[STDCERT_SIGNER_ID].offset = 191;
    signer_cert_def->std_cert_elements[STDCERT_SIGNER_ID].count = 4;
    signer_cert_def->std_cert_elements[STDCERT_CERT_SN].offset = 15;
    signer_cert_def->std_cert_elements[STDCERT_CERT_SN].count = 16;
    signer_cert_def->std_cert_elements[STDCERT_AUTH_KEY_ID].offset = 370;
    signer_cert_def->std_cert_elements[STDCERT_AUTH_KEY_ID].count = 20;
    signer_cert_def->std_cert_elements[STDCERT_SUBJ_KEY_ID].offset = 337;
    signer_cert_def->std_cert_elements[STDCERT_SUBJ_KEY_ID].count = 20;
        
        
    device_cert_def->issue_date_format = DATEFMT_RFC5280_UTC;
    device_cert_def->expire_date_format = DATEFMT_RFC5280_GEN;
    device_cert_def->tbs_cert_loc.offset = 4;
    device_cert_def->tbs_cert_loc.count = 333;
    device_cert_def->std_cert_elements[STDCERT_PUBLIC_KEY].offset = 236;
    device_cert_def->std_cert_elements[STDCERT_PUBLIC_KEY].count = 64;
    device_cert_def->std_cert_elements[STDCERT_SIGNATURE].offset = 349;
    device_cert_def->std_cert_elements[STDCERT_SIGNATURE].count = 74;
    device_cert_def->std_cert_elements[STDCERT_ISSUE_DATE].offset = 116;
    device_cert_def->std_cert_elements[STDCERT_ISSUE_DATE].count = 13;
    device_cert_def->std_cert_elements[STDCERT_EXPIRE_DATE].offset = 131;
    device_cert_def->std_cert_elements[STDCERT_EXPIRE_DATE].count = 15;
    device_cert_def->std_cert_elements[STDCERT_SIGNER_ID].offset = 108;
    device_cert_def->std_cert_elements[STDCERT_SIGNER_ID].count = 4;
    device_cert_def->std_cert_elements[STDCERT_CERT_SN].offset = 15;
    device_cert_def->std_cert_elements[STDCERT_CERT_SN].count = 16;
    device_cert_def->std_cert_elements[STDCERT_AUTH_KEY_ID].offset = 317;
    device_cert_def->std_cert_elements[STDCERT_AUTH_KEY_ID].count = 20;
    device_cert_def->std_cert_elements[STDCERT_SUBJ_KEY_ID].offset = 0;
    device_cert_def->std_cert_elements[STDCERT_SUBJ_KEY_ID].count = 0;
}

- (BOOL)reconstruct_cert_with_certdef:(atcacert_def_t)cert_def  ca_pk:( NSMutableData *)ca_pk compert:( NSMutableData *)compcert pk:( NSMutableData *)pk fullcert:( Byte *) x509_cert
{
    //1 byte(0x04)+ 64 bytes(public key)
    Byte key_id_msg[1 + PUBLIC_KEY_LENGTH];
    Byte cert_sn_msg[3 + PUBLIC_KEY_LENGTH];
    Byte key_id[CC_SHA1_DIGEST_LENGTH];
    Byte cert_sn[CC_SHA256_DIGEST_LENGTH];
    Byte enc_dates[3];
    Byte signer_id[2];
    Byte signature_nonEnc[SIGNATURE_LENGTH];
    //initialize to the max signature_Enc size
    size_t signature_Enc_size = 5 + 2*2 + SIGNATURE_LENGTH + 2;
    
    atcacert_tm_utc_t issue_date;
    atcacert_tm_utc_t expire_date;
    Byte expire_years;
    
    //STDCERT_AUTH_KEY_ID
    if(cert_def.std_cert_elements[STDCERT_AUTH_KEY_ID].count != 0){
        key_id_msg[0] = 0x04;
        //memcpy(&key_id_msg[1], [ca_pk bytes], PUBLIC_KEY_LENGTH);
        [ca_pk getBytes:&key_id_msg[1] length:PUBLIC_KEY_LENGTH];
        if (!CC_SHA1(key_id_msg, sizeof(key_id_msg), key_id)) {
            return nil;
        }
        memcpy(&x509_cert[cert_def.std_cert_elements[STDCERT_AUTH_KEY_ID].offset], key_id, cert_def.std_cert_elements[STDCERT_AUTH_KEY_ID].count);
    }
    //STDCERT_SUBJ_KEY_ID
    if(cert_def.std_cert_elements[STDCERT_SUBJ_KEY_ID].count != 0){
        key_id_msg[0] = 0x04;
        //memcpy(&key_id_msg[1], [pk bytes], PUBLIC_KEY_LENGTH);
        [pk getBytes:&key_id_msg[1] length:PUBLIC_KEY_LENGTH];
        if (!CC_SHA1(key_id_msg, sizeof(key_id_msg), key_id)) {
            return nil;
        }
        memcpy(&x509_cert[cert_def.std_cert_elements[STDCERT_SUBJ_KEY_ID].offset], key_id, cert_def.std_cert_elements[STDCERT_SUBJ_KEY_ID].count);
    }
    //STDCERT_PUBLIC_KEY
    memcpy(&x509_cert[cert_def.std_cert_elements[STDCERT_PUBLIC_KEY].offset], [pk bytes], cert_def.std_cert_elements[STDCERT_PUBLIC_KEY].count);
    
    //STDCERT_SIGNATURE
    [compcert getBytes:signature_nonEnc length:SIGNATURE_LENGTH];
    [self atcacert_der_enc_ecdsa_sig_value:signature_nonEnc der_sig:&x509_cert[cert_def.std_cert_elements[STDCERT_SIGNATURE].offset] der_sig_size:&signature_Enc_size];
    //set the cert size according to the actual enc_signature size
    size_t cert_size = cert_def.std_cert_elements[STDCERT_SIGNATURE].offset + signature_Enc_size - 4;
    x509_cert[3] = (Byte) (cert_size & 0xff);
    x509_cert[2] = (Byte) ((cert_size >> 8) & 0xff);
    
    //STDCERT_ISSUE_DATE and STDCERT_EXPIRE_DATE
    [compcert getBytes:enc_dates range:NSMakeRange(64, 3)];
    issue_date.tm_year = (Byte)((enc_dates[0] & 0xff)>>3) + 2000 - 1900;
    issue_date.tm_mon = (((enc_dates[0] & 0x07) << 1) | ((enc_dates[1] & 0x80) >> 7)) - 1;
    issue_date.tm_mday = (Byte)((enc_dates[1] & 0x7C) >> 2);
    issue_date.tm_hour = ((enc_dates[1] & 0x03) << 3) | ((enc_dates[2] & 0xE0) >> 5);
    issue_date.tm_min = 0;
    issue_date.tm_sec = 0;
    expire_years = (Byte) (enc_dates[2] & 0x1F);
    
    if (expire_years != 0) {
        expire_date.tm_year = issue_date.tm_year + expire_years;
        expire_date.tm_mon = issue_date.tm_mon;
        expire_date.tm_mday = issue_date.tm_mday;
        expire_date.tm_hour = issue_date.tm_hour;
        expire_date.tm_min = issue_date.tm_min;
        expire_date.tm_sec = issue_date.tm_sec;
    } else {
        // Expire years is 0, means no expiration. Set to max date for the given expiration date format.
        expire_date = [self date_get_max_date:cert_def.expire_date_format];
    }
    
    Byte issue_date_enc_byte[DATEFMT_MAX_SIZE];
    
    switch (cert_def.issue_date_format) {
            //case DATEFMT_ISO8601_SEP:     return atcacert_date_enc_iso8601_sep(timestamp, formatted_date);
        case DATEFMT_RFC5280_UTC:
            [self atcacert_date_enc_rfc5280_utc:&issue_date formatted_date:issue_date_enc_byte];
            break;
            //case DATEFMT_POSIX_UINT32_BE: return atcacert_date_enc_posix_uint32_be(timestamp, formatted_date);
            //case DATEFMT_POSIX_UINT32_LE: return atcacert_date_enc_posix_uint32_le(timestamp, formatted_date);
        case DATEFMT_RFC5280_GEN:
            [self atcacert_date_enc_rfc5280_gen:&issue_date formatted_date:issue_date_enc_byte];
            break;
            
        default:
            [self atcacert_date_enc_rfc5280_utc:&issue_date formatted_date:issue_date_enc_byte];
            break;
    }
    memcpy(&x509_cert[cert_def.std_cert_elements[STDCERT_ISSUE_DATE].offset], issue_date_enc_byte, cert_def.std_cert_elements[STDCERT_ISSUE_DATE].count);
    
    Byte expire_date_enc_byte[DATEFMT_MAX_SIZE];
    
    switch (cert_def.expire_date_format) {
            //case DATEFMT_ISO8601_SEP:     return atcacert_date_enc_iso8601_sep(timestamp, formatted_date);
        case DATEFMT_RFC5280_UTC:
            [self atcacert_date_enc_rfc5280_utc:&expire_date formatted_date:expire_date_enc_byte];
            break;
            //case DATEFMT_POSIX_UINT32_BE: return atcacert_date_enc_posix_uint32_be(timestamp, formatted_date);
            //case DATEFMT_POSIX_UINT32_LE: return atcacert_date_enc_posix_uint32_le(timestamp, formatted_date);
        case DATEFMT_RFC5280_GEN:
            [self atcacert_date_enc_rfc5280_gen:&expire_date formatted_date:expire_date_enc_byte];
            break;
            
        default:
            [self atcacert_date_enc_rfc5280_utc:&expire_date formatted_date:expire_date_enc_byte];
            break;
    }
    memcpy(&x509_cert[cert_def.std_cert_elements[STDCERT_EXPIRE_DATE].offset], expire_date_enc_byte, cert_def.std_cert_elements[STDCERT_EXPIRE_DATE].count);
    
    //STDCERT_SIGNER_ID
    [compcert getBytes:signer_id range:NSMakeRange(67, 2)];
    uint8_t hex_str[4];
    [self uint8_to_hex_str:signer_id[0] hex_str:&hex_str[0]];
    [self uint8_to_hex_str:signer_id[1] hex_str:&hex_str[2]];
    memcpy(&x509_cert[cert_def.std_cert_elements[STDCERT_SIGNER_ID].offset], hex_str, cert_def.std_cert_elements[STDCERT_SIGNER_ID].count);

    
    //STDCERT_CERT_SN
    [pk getBytes:cert_sn_msg length:PUBLIC_KEY_LENGTH];
    [compcert getBytes:&cert_sn_msg[64] range:NSMakeRange(64, 3)];
    if (!CC_SHA256(cert_sn_msg, sizeof(cert_sn_msg), cert_sn)) {
        return nil;
    }
    cert_sn[0] &= 0x7F;
    cert_sn[0] |= 0x40;
    memcpy(&x509_cert[cert_def.std_cert_elements[STDCERT_CERT_SN].offset], cert_sn, cert_def.std_cert_elements[STDCERT_CERT_SN].count);
    
    return true;
}


-(void) test{
    NSString *hexStr0 = @"12gde3";
    NSMutableData* challenge0 = [self convertHexStrToData:hexStr0];
    NSLog(@"hexStr0 = %@", hexStr0);
    NSLog(@"challenge0 = %@", challenge0);
    
}


- (NSMutableData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    return hexData;
}

- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

+ (void)x509Verify:(NSData *)publicKeyData chanllengeData:(NSData *)chanllengeData responseData:(NSData *)responseData{
    const unsigned char *certificateDataBytes = (const unsigned char *)[publicKeyData bytes];
    X509 *certificateX509 = d2i_X509(NULL, &certificateDataBytes, [publicKeyData length]);
    ASN1_BIT_STRING *pubKey2 = X509_get0_pubkey_bitstr(certificateX509);
    NSData * publicKey = [NSData dataWithBytes:pubKey2->data length:pubKey2->length];
    NSLog(@"%@", publicKey);
    
    GMEllipticCurveCrypto * crypto = [GMEllipticCurveCrypto cryptoForKey:publicKey];
//    BOOL valid = [crypto verifySignature:responseData forHash:chanllengeData];
    BOOL valid = [crypto hashSHA256AndVerifySignature:responseData forData:chanllengeData];
    NSLog(@"result: %@", @(valid));
}

+ (void)x509Verify:(NSData *)root_cert signer_cert:(NSData *)signer_cert device_cert:(NSData *)device_cert {
    const unsigned char *root_certBytes = (const unsigned char *)[root_cert bytes];
    X509 *root_cert_X509 = d2i_X509(NULL, &root_certBytes, [root_cert length]);
    EVP_PKEY * rootKey = X509_get_pubkey(root_cert_X509);
    
    const unsigned char *signer_certBytes = (const unsigned char *)[signer_cert bytes];
    X509 *signer_cert_X509 = d2i_X509(NULL, &signer_certBytes, [signer_cert length]);
    EVP_PKEY * signerKey = X509_get_pubkey(signer_cert_X509);
    
    const unsigned char *device_certBytes = (const unsigned char *)[device_cert bytes];
    X509 *device_cert_X509 = d2i_X509(NULL, &device_certBytes, [device_cert length]);
    
    OpenSSL_add_all_algorithms();
    OpenSSL_add_all_ciphers();
    OpenSSL_add_all_digests();
    int root_cert_code = X509_verify(root_cert_X509, rootKey);
    int signer_cert_code = X509_verify(signer_cert_X509, rootKey);
    int device_cert_code = X509_verify(device_cert_X509, signerKey);
    printf("root code: %d, signer code: %d, device code:%d\n", root_cert_code, signer_cert_code, device_cert_code);
}

+ (NSData*) encodeSig:(NSData *)data {
    Byte *nonEncodedSig = (Byte *)[data bytes];
    Byte overallSize = 0x44;
    Byte rSize = 32;
    
    Byte sSize = 32;
    Byte sigOid = 0x30;
    Byte ptOid = 0x02;
    
    Byte r[32];
    Byte s[32];
    Byte ANS_1_encoded_70[70];
    Byte ANS_1_encoded_71[71];
    Byte ANS_1_encoded_72[72];
    
    // String str2 = hex(kpA);
    // arraycopy(Object src, int srcPos, Object dest, int destPos, int
    // length)
    memcpy(r, nonEncodedSig, 32);
//    System.arraycopy(nonEncodedSig, 0, r, 0, 32);
    memcpy(s, &nonEncodedSig[32], 32);
//    System.arraycopy(nonEncodedSig, 32, s, 0, 32);
    BOOL rPad = false;
    BOOL sPad = false;
    // Look at MSB of r
    if ((Byte) nonEncodedSig[0] < 0) {
        // add 00 pad
        // rSize++;
        // overallSize++;
        overallSize++;
        rSize++;
        rPad = true;
    }
    if (nonEncodedSig[32] < 0) {
        // add 00 pad
        // sSize++
        // overallSize++
        overallSize++;
        sSize++;
        sPad = true;
    }
    
    if (sPad == false && rPad == false) {
        // Copy the ASN.1 encoding for the signature & R component
        int arrIndex = 0;
        ANS_1_encoded_70[arrIndex++] = sigOid;
        ANS_1_encoded_70[arrIndex++] = overallSize;
        ANS_1_encoded_70[arrIndex++] = ptOid;
        ANS_1_encoded_70[arrIndex++] = rSize;
        
        // Copy the R portion of the signature
        memcpy(&ANS_1_encoded_70[arrIndex], r, 32);
//        System.arraycopy(r, 0, ANS_1_encoded_70, arrIndex, 32);
        arrIndex += 32;
        
        // Copy the ASN.1 encoding for S
        ANS_1_encoded_70[arrIndex++] = ptOid;
        ANS_1_encoded_70[arrIndex++] = sSize;
        
        // Copy the S portion of the signature
        memcpy(&ANS_1_encoded_70[arrIndex], s, 32);
//        System.arraycopy(s, 0, ANS_1_encoded_70, arrIndex, 32);
        return [NSData dataWithBytes:ANS_1_encoded_70 length:70];
//        return ANS_1_encoded_70;
    } else if ((sPad == false && rPad == true) || (sPad == true && rPad == false)) {
        // Copy the ASN.1 encoding for the signature & R component
        int arrIndex = 0;
        ANS_1_encoded_71[arrIndex++] = sigOid;
        ANS_1_encoded_71[arrIndex++] = overallSize;
        ANS_1_encoded_71[arrIndex++] = ptOid;
        ANS_1_encoded_71[arrIndex++] = rSize;
        if (rPad == true) {
            ANS_1_encoded_71[arrIndex++] = 0x00;
        }
        // Copy the R portion of the signature
        memcpy(&ANS_1_encoded_71[arrIndex], r, 32);
//        System.arraycopy(r, 0, ANS_1_encoded_71, arrIndex, 32);
        arrIndex += 32;
        
        // Copy the ASN.1 encoding for S
        ANS_1_encoded_71[arrIndex++] = ptOid;
        ANS_1_encoded_71[arrIndex++] = sSize;
        if (sPad == true) {
            ANS_1_encoded_71[arrIndex++] = 0x00;
        }
        
        // Copy the S portion of the signature
        memcpy(&ANS_1_encoded_71[arrIndex], s, 32);
//        System.arraycopy(s, 0, ANS_1_encoded_71, arrIndex, 32);
        return [NSData dataWithBytes:ANS_1_encoded_71 length:71];
//        return ANS_1_encoded_71;
    } else if (sPad == true && rPad == true) {
        // Copy the ASN.1 encoding for the signature & R component
        int arrIndex = 0;
        ANS_1_encoded_72[arrIndex++] = sigOid;
        ANS_1_encoded_72[arrIndex++] = overallSize;
        ANS_1_encoded_72[arrIndex++] = ptOid;
        ANS_1_encoded_72[arrIndex++] = rSize;
        if (rPad == true) {
            ANS_1_encoded_72[arrIndex++] = 0x00;
        }
        // Copy the R portion of the signature
        memcpy(&ANS_1_encoded_72[arrIndex], r, 32);
//        System.arraycopy(r, 0, ANS_1_encoded_72, arrIndex, 32);
        arrIndex += 32;
        
        // Copy the ASN.1 encoding for S
        ANS_1_encoded_72[arrIndex++] = ptOid;
        ANS_1_encoded_72[arrIndex++] = sSize;
        if (sPad == true) {
            ANS_1_encoded_72[arrIndex++] = 0x00;
        }
        
        // Copy the S portion of the signature
        memcpy(&ANS_1_encoded_72[arrIndex], s, 32);
//        System.arraycopy(s, 0, ANS_1_encoded_72, arrIndex, 32);
        return [NSData dataWithBytes:ANS_1_encoded_72 length:72];
//        return ANS_1_encoded_72;
    }
    return nil;
}


//- (NSData *)getKeyBitsFromKeyRef:(SecKeyRef)keyRef {
//    NSData *tag = [@"com.cogddo.pubkey" dataUsingEncoding:NSASCIIStringEncoding];
//    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:0];
//    [dictM setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
//    [dictM setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
//    [dictM setObject:tag forKey:(__bridge id)kSecAttrApplicationTag];
//    [dictM setObject:@YES forKey:(__bridge id)kSecReturnData];
//    [dictM setObject:(__bridge id)keyRef forKey:(__bridge id)kSecValueRef];
//    CFTypeRef result;
//    NSData *keyData = nil;
//    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dictM, &result);
//    if (status == noErr) {
//        keyData = CFBridgingRelease(result);
//        NSLog(@"delete");
//        SecItemDelete((__bridge CFDictionaryRef)dictM);
//    }
//    return keyData;
//    
//}

@end
