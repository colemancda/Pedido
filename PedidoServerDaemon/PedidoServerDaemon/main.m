//
//  main.m
//  PedidoServerDaemon
//
//  Created by Alsey Coleman Miller on 12/5/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CorePedidoServer;

int main(int argc, const char * argv[]) {
    
    @autoreleasepool {
        
        NSLog(@"Initializing Server Manager");
        
        NSError *error = [[ServerManager sharedManager] start];
        
        if (error != nil) {
            
            NSLog(@"Could not start server on port %lu (%@)", [ServerManager sharedManager].serverPort, error.localizedDescription);
            
            return 1;
        }
        
        NSLog(@"Started server on port %lu", [ServerManager sharedManager].serverPort);
    }
    
    [[NSRunLoop currentRunLoop] run];
    
    return 0;
}
