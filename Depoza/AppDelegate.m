//
//  AppDelegate.m
//  Depoza
//
//  Created by Ivan Magda on 20.11.14.
//  Copyright (c) 2014 Ivan Magda. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "AllExpensesTableViewController.h"
#import "SettingsTableViewController.h"
#import "MoreInfoTableViewController.h"
#import <KVNProgress/KVNProgress.h>

    //CoreData
#import "Persistence.h"
#import "ExpenseData+Fetch.h"

@interface AppDelegate ()

@property (strong, nonatomic) Persistence *persistence;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation AppDelegate {
    MainViewController *_mainViewController;
}

#pragma mark - Helper Methods -

- (void)spreadManagedObjectContext {
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;

        //Get the MainViewController and set it's as a observer for creating context
    UINavigationController *navigationController = (UINavigationController *)tabBarController.viewControllers[0];
    _mainViewController = (MainViewController *)navigationController.viewControllers[0];

        //Get the AllExpensesViewController
    navigationController = (UINavigationController *)tabBarController.viewControllers[1];
    AllExpensesTableViewController *allExpensesController = (AllExpensesTableViewController *)navigationController.viewControllers[0];

        //Get the SettingsTableViewController
    navigationController = (UINavigationController *)tabBarController.viewControllers[2];
    SettingsTableViewController *settingsViewController = (SettingsTableViewController *)navigationController.viewControllers[0];

    self.persistence = [Persistence sharedInstance];
    self.managedObjectContext = [self.persistence managedObjectContext];

    NSParameterAssert(_managedObjectContext);
    _mainViewController.managedObjectContext = _managedObjectContext;
    allExpensesController.managedObjectContext = _managedObjectContext;
    settingsViewController.managedObjectContext = _managedObjectContext;
}

- (void)setKVNDisplayTime {
    KVNProgressConfiguration *configuration = [KVNProgressConfiguration defaultConfiguration];
    configuration.minimumSuccessDisplayTime = 0.55f;
    configuration.minimumErrorDisplayTime   = 0.75f;
    [KVNProgress setConfiguration:configuration];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self spreadManagedObjectContext];
    [self setKVNDisplayTime];

    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSString *query = url.query;
    if (query != nil) {
        if ([query hasPrefix:@"q="]) {
            // If we have a query string, strip out the "q=" part so we're just left with the identifier
            NSRange range = [query rangeOfString:@"q="];
            NSString *identifier = [query stringByReplacingOccurrencesOfString:@"^q=" withString:@"" options:NSRegularExpressionSearch range:range];

            ExpenseData *selectedExpense = [ExpenseData getExpenseFromIdValue:identifier.integerValue inManagedObjectContext:_managedObjectContext];

                //Manage navigation stack of MainViewControler navigationController
            NSInteger numberControllers = [_mainViewController.navigationController viewControllers].count;
            if (numberControllers > 1) {
                MoreInfoTableViewController *moreInfoController = [[_mainViewController.navigationController viewControllers]objectAtIndex:1];
                if ([moreInfoController.expenseToShow isEqual:selectedExpense]) {
                    return YES;
                } else {
                    [_mainViewController.navigationController popToRootViewControllerAnimated:NO];
                }
            }

            [_mainViewController performSegueWithIdentifier:@"MoreInfo" sender:selectedExpense];

            return YES;
        }
    }
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    [_persistence saveContext];
}

/*
- (void)createDataStore {
    CategoryData *communication = [CategoryData categoryDataWithTitle:@"Связь" iconName:@"SimCard" andExpenses:nil inManagedObjectContext:_managedObjectContext];
    CategoryData *clothes = [CategoryData categoryDataWithTitle:@"Одежда" iconName:@"Clothes" andExpenses:nil inManagedObjectContext:_managedObjectContext];
    CategoryData *healthcare = [CategoryData categoryDataWithTitle:@"Здоровье" iconName:@"Hearts" andExpenses:nil inManagedObjectContext:_managedObjectContext];
    CategoryData *foodstuffs = [CategoryData categoryDataWithTitle:@"Продукты" iconName:@"Ingredients" andExpenses:nil inManagedObjectContext:_managedObjectContext];
    CategoryData *eatingOut = [CategoryData categoryDataWithTitle:@"Еда вне дома" iconName:@"Cutlery" andExpenses:nil inManagedObjectContext:_managedObjectContext];
    CategoryData *housing = [CategoryData categoryDataWithTitle:@"Жилье" iconName:@"Exterior" andExpenses:nil inManagedObjectContext:_managedObjectContext];
    CategoryData *trip = [CategoryData categoryDataWithTitle:@"Поездки" iconName:@"Beach" andExpenses:nil inManagedObjectContext:_managedObjectContext];
    CategoryData *electronics = [CategoryData categoryDataWithTitle:@"Электроника" iconName:@"SmartphoneTablet" andExpenses:nil inManagedObjectContext:_managedObjectContext];
    CategoryData *entertainment = [CategoryData categoryDataWithTitle:@"Развлечения" iconName:@"Controller" andExpenses:nil inManagedObjectContext:_managedObjectContext];

    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
}
*/

@end