//
//  OCPayViewController.m
//  OpenCoinWallet
//
//  Created by Gulliver on 19.11.12.
//  Copyright (c) 2012 Opencoin Team. All rights reserved.
//

#import "OCPayViewController.h"

#import "OCBlank.h"
#import "OCMintKey.h"
#import "OCHttpClient.h"

@interface OCPayViewController ()
@property(readonly) NSMutableArray* items;
@end

@implementation OCPayViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
      _items = [NSMutableArray array];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  NSURL* baseURL = [NSURL URLWithString:@"https://mighty-lake-9219.herokuapp.com/gulden/" ];
  
  OCHttpClient* client = [[OCHttpClient alloc] initWithBaseURL:baseURL];
  
  __block OCCurrency* currency;
  __block NSError* error;
  [client getLatestCDD:^(OCCurrency *result, NSError *_error) {
    currency = result;
    error = _error;
    
    if (!error)
    {
      __block OCMintKey* mint_key = [[OCMintKey alloc] init];
      
      __block NSArray* blanks = [NSArray arrayWithObjects:
                         [OCBlank blankWithCurrency:currency
                                   WithDenomination:1
                                        WithMintKey:mint_key]
                         , nil];
      
      __block NSArray* blinded_token;
      
      [client validateBlanks:blanks
        WithMessageReference:42
    withTransactionReference:42
       WithAuthorisationInfo:@"opencoin"
                     success:^(NSArray *result, NSError *_error) {
                       blinded_token = result;
                       error = _error;
      if (!error)
      {
        [self.items removeAllObjects];
        [self.items addObjectsFromArray:blinded_token];
        [self.tableView reloadData];
      }
      else
      {
        {
          NSLog(@"error %@", [error localizedDescription]);
          [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        }
      }
      }];
    }
  }];
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
