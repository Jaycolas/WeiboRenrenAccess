//
//  CoreDataTableViewController.m
//
//  Created for Stanford CS193p Fall 2013.
//  Copyright 2013 Stanford University. All rights reserved.
//

#import "CoreDataTableViewController.h"

@implementation CoreDataTableViewController

#pragma mark - Fetching

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //To set debug flag conveniently
    self.debug = YES;
    
    
}

- (void)performFetch:(NSFetchedResultsController *)NSFRC
{
    if (NSFRC) {
        if (NSFRC.fetchRequest.predicate) {
            if (self.debug) NSLog(@"[%@ %@] fetching %@ with predicate: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), NSFRC.fetchRequest.entityName, NSFRC.fetchRequest.predicate);
        } else {
            if (self.debug) NSLog(@"[%@ %@] fetching all %@ (i.e., no predicate)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), NSFRC.fetchRequest.entityName);
        }
        NSError *error;
        //BOOL success = [self.fetchedResultsController performFetch:&error];
        BOOL success = [NSFRC performFetch:&error];
        if (!success) NSLog(@"[%@ %@] performFetch: failed", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    } else {
        if (self.debug) NSLog(@"[%@ %@] no NSFetchedResultsController (yet?)", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    }
    [self.tableView reloadData];
}


- (UISearchController *)nameSearchController
{
    if (!_nameSearchController) {
        _nameSearchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _nameSearchController.searchResultsUpdater = self;
        _nameSearchController.dimsBackgroundDuringPresentation = NO;
        
        //Test Code
        //_nameSearchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        
       // _nameSearchController.searchBar.frame = CGRectMake(self.nameSearchController.searchBar.frame.origin.x, self.nameSearchController.searchBar.frame.origin.y, self.nameSearchController.searchBar.frame.size.width, 45);
        
        
        
    }
    
    return _nameSearchController;
}

- (void)setSeachFRC:(NSFetchedResultsController *)newfrc
{
    NSFetchedResultsController *oldfrc = _seachFRC;
    if (newfrc != oldfrc) {
        _seachFRC = newfrc;
        newfrc.delegate = self;
        if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title)) {
            self.title = newfrc.fetchRequest.entity.name;
        }
        if (newfrc) {
            if (self.debug) NSLog(@"[%@ %@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), oldfrc ? @"updated" : @"set");
            [self performFetch:newfrc];
        } else {
            if (self.debug) NSLog(@"[%@ %@] reset to nil", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            [self.tableView reloadData];
        }
    }
}


- (void)setFetchedResultsController:(NSFetchedResultsController *)newfrc
{
    NSFetchedResultsController *oldfrc = _fetchedResultsController;
    if (newfrc != oldfrc) {
        _fetchedResultsController = newfrc;
        newfrc.delegate = self;
        if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title)) {
            self.title = newfrc.fetchRequest.entity.name;
        }
        if (newfrc) {
            if (self.debug) NSLog(@"[%@ %@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), oldfrc ? @"updated" : @"set");
            [self performFetch:newfrc];
        } else {
            if (self.debug) NSLog(@"[%@ %@] reset to nil", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            [self.tableView reloadData];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSFetchedResultsController * usedNSFRC;
    
    if (self.nameSearchController.active) {
        usedNSFRC = self.seachFRC;
    } else {
        usedNSFRC = self.fetchedResultsController;
    }
    
    
    NSInteger sections = [[usedNSFRC sections] count];
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSFetchedResultsController * usedNSFRC;
    
    if (self.nameSearchController.active) {
        usedNSFRC = self.seachFRC;
    } else {
        usedNSFRC = self.fetchedResultsController;
    }
    
    
    NSInteger rows = 0;
    if ([[usedNSFRC sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[usedNSFRC sections] objectAtIndex:section];
        rows = [sectionInfo numberOfObjects];
    }
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSFetchedResultsController * usedNSFRC;
    
    if (self.nameSearchController.active) {
        usedNSFRC = self.seachFRC;
    } else {
        usedNSFRC = self.fetchedResultsController;
    }
    
	return [[[usedNSFRC sections] objectAtIndex:section] name];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSFetchedResultsController * usedNSFRC;
    
    if (self.nameSearchController.active) {
        usedNSFRC = self.seachFRC;
    } else {
        usedNSFRC = self.fetchedResultsController;
    }
    
    
	return [usedNSFRC sectionForSectionIndexTitle:title atIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSFetchedResultsController * usedNSFRC;
    
    if (self.nameSearchController.active) {
        usedNSFRC = self.seachFRC;
    } else {
        usedNSFRC = self.fetchedResultsController;
    }
    
    return [usedNSFRC sectionIndexTitles];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            NSLog(@"type: %d has not been handled.", type);
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{		
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSLog(@"Null implementation for UISearchResultsUpdating Protocol");
    
}

@end

