

#import "ReportePrincipal.h"


@implementation ReportePrincipal

@dynamic cve_ent;
@dynamic acc_finan;
@dynamic mto_finan;
@dynamic acc_subs;
@dynamic mto_subs;
@dynamic vv;
@dynamic vr;


+(id)reportePrincipalWithContext:(NSManagedObjectContext *)context {
    ReportePrincipal *reportePrincipal = [NSEntityDescription
                        insertNewObjectForEntityForName:@"ReportePrincipal"
                        inManagedObjectContext:context];
    return reportePrincipal;
}



- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
