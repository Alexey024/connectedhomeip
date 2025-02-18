/**
 *
 *    Copyright (c) 2021 Project CHIP Authors
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

#import "MTRDeviceConnectionBridge.h"
#import "MTRBaseDevice_Internal.h"
#import "MTRError_Internal.h"

void MTRDeviceConnectionBridge::OnConnected(void * context, chip::OperationalDeviceProxy * device)
{
    auto * object = static_cast<MTRDeviceConnectionBridge *>(context);
    MTRBaseDevice * chipDevice = [[MTRBaseDevice alloc] initWithDevice:device];
    dispatch_async(object->mQueue, ^{
        object->mCompletionHandler(chipDevice, nil);
        object->Release();
    });
}

void MTRDeviceConnectionBridge::OnConnectionFailure(void * context, chip::PeerId peerId, CHIP_ERROR error)
{
    auto * object = static_cast<MTRDeviceConnectionBridge *>(context);
    dispatch_async(object->mQueue, ^{
        object->mCompletionHandler(nil, [MTRError errorForCHIPErrorCode:error]);
        object->Release();
    });
}
