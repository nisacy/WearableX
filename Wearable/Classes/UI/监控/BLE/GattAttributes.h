//
//  GattAttributes.h
//  Wearable
//
//  Created by Shinsoft on 17/2/12.
//  Copyright © 2017年 wearable. All rights reserved.
//

#ifndef GattAttributes_h
#define GattAttributes_h


/**
 * Service UUID's (128 bits)
 */
#define K_ENVIRONMENT_SERVICE                   @"F05ABAC0-3936-11E5-87A6-0002A5D5C51B"//环境服务
#define K_BATTERY_SERVICE                       @"F05ABAC3-3936-11E5-87A6-0002A5D5C51B"//电池服务
#define K_TOUCH_GESTURE_SERVICE                 @"F05ABAC4-3936-11E5-87A6-0002A5D5C51B"//触摸手势服务
#define K_DEVICE_ORIENTATION_SERVICE            @"F05ABAC1-3936-11E5-87A6-0002A5D5C51B"//设备服务

/**
 * Environment Characteristics UUID's (128 bits)
 */


#define K_ENVIRONMENT_CHARACTERISTICS           @"F05ABAD0-3936-11E5-87A6-0002A5D5C51B"//环境服务--特征

/* #define K_TEMPERATURE_CHARACTERISTICS          @"0xF05ABAD0393611E587A6-0002A5D5C51B"
 #define K_PRESSURE_CHARACTERISTICS          @"0xF05ABAD2393611E587A60002A5D5C51B"
 #define K_UV_CHARACTERISTICS          @"0xF05ABAD3393611E587A60002A5D5C51B" */


/**
 * Battery Characteristics UUID's (128 bits)
 */

#define K_LOW_BATTERY_INDICATION_CHARACTERISTICS @"F05ABADC-3936-11E5-87A6-0002A5D5C51B"//电池服务--低电量特征

/**
 * Touch gesture Characteristics UUID's (128 bits)
 */

#define K_GESTURE_CHARACTERISTICS                 @"F05ABADD-3936-11E5-87A6-0002A5D5C51B"//触摸手势--特征


/**
 * Device orientation Characteristics UUID's (128 bits)
 */

#define K_GYRO_POSITIONS_CHARACTERISTICS            @"F05ABAD4-3936-11E5-87A6-0002A5D5C51B"//设备服务--陀螺仪特征
#define K_ACCELERO_POSITIONS_CHARACTERISTICS        @"F05ABAD7-3936-11E5-87A6-0002A5D5C51B"//设备服务--加速度特征
#define K_DROP_DETECTION_INDICATION_CHARACTERISTICS @"F05ABADA-3936-11E5-87A6-0002A5D5C51B"//设备服务--检测指标下降特征
#define K_STEP_INC_INDICATION_CHARACTERISTICS       @"F05ABADB-3936-11E5-87A6-0002A5D5C51B"//设备服务--计步特征
#define K_ROTATION_VECTOR_CHARACTERISTICS           @"F05ABAD8-3936-11E5-87A6-0002A5D5C51B"//设备服务--旋转特征

/**
 * ODR Characteristics UUID's (128 bits)
 */
#define K_ENVIRONMENT_ODR_CHARCTERISTICS          @"F05ABAD1-3936-11E5-87A6-0002A5D5C51B"
#define K_MOTION_ODR_CHARCTERISTICS               @"F05ABAD9-3936-11E5-87A6-0002A5D5C51B"


/**
 *Authentication Service
 */
#define K_Authentication_CHARACTERISTICS           @"F05ABAD2-3936-11E5-87A6-0002A5D5C51B"//认证

/**
 * used to convert string uuid to valid UUID
 *
 * @param stringUuid
 * @return UUID
 */
//public UUID getUuidFromString(String stringUuid) {
//    return UUID.fromString(stringUuid)
//}


/**
 * Descriptor UUID's
 */
#define K_CLIENT_CHARACTERISTIC_CONFIG           @"00002902-0000-1000-8000-00805F9B34FB"
//public static final UUID CLIENT_CHARACTERISTIC_CONFIG_DESCRIPTOR_UUID          @UUID.fromString("00002902-0000-1000-8000-00805f9b34fb")


/**
 * Gatt services
 */
#define K_GENERIC_ACCESS_SERVICE                @"00001800-0000-1000-8000-00805F9B34FB"
#define K_GENERIC_ATTRIBUTE_SERVICE             @"00001801-0000-1000-8000-00805F9B34FB"



#endif /* GattAttributes_h */
