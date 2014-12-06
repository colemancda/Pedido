//
//  main.m
//  PedidoServerDaemon
//
//  Created by Alsey Coleman Miller on 12/5/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>
@import NetworkObjects;
@import CorePedidoServer;

int main(int argc, const char * argv[]) {
    
    @autoreleasepool {
        
        NSLog(@"Initializing Server Manager");
        
        [ServerManager sharedManager];
        
        NSUInteger port = 8080;
        
        NSLog(@"Starting Server on port %ld", port);
        
        [[ServerManager sharedManager] startOnPort: port];
        
    }
    
    [[NSRunLoop currentRunLoop] run];
    
    return 0;
}
