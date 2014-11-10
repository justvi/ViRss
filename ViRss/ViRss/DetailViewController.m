//
//  DetailViewController.m
//  ViRss
//
//  Created by lhs on 14/10/27.
//  Copyright (c) 2014年 lhs. All rights reserved.
//

#import "DetailViewController.h"
#import "ArticleViewController.h"
#import "Post.h"

@interface DetailViewController ()
{
    NSMutableString *currentValue;
    Post *post;
    BOOL parsingItem;
}
@property (nonatomic, strong) UIPopoverController *navigationPopoverController;

@end

@implementation DetailViewController

- (void)setTextInfo:(NSString *)textInfo
{
    if (textInfo != _textInfo) {
        _textInfo = textInfo;
        [self start];
        //[self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSURLConnectionDelegate

- (void)start
{
    NSURL *url = [NSURL URLWithString:self.textInfo];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    if (self.rssData == nil) {
        self.rssData = [[NSMutableData alloc] init];
    } else {
        [self.rssData setLength:0];
    }
    self.conn = [NSURLConnection connectionWithRequest:request delegate:self];
    [self.conn start];
    NSLog(@"start downloading: %@", self.textInfo);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.rssData setLength:0];
    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
    if (resp.statusCode == 200) {
        NSLog(@"success receive response");
    } else {
        [connection cancel];
        NSLog(@"did receive response");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"did receive data size: %ld", [data length]);
    [self.rssData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.rssData];
    parser.delegate = self;
    [parser parse];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"failed: %@", error);
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.entries = [[NSMutableArray alloc] init];
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.tableView reloadData];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //    NSLog(@"element name: %@", elementName);
    if ([elementName isEqualToString:@"entry"]) {
        post = [[Post alloc] init];
        parsingItem = YES;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //    NSLog(@"element name: %@---", elementName);
    if ([elementName isEqualToString:@"entry"]) {
        [self.entries addObject:post];
        NSLog(@"%@", post);
        post = nil;
        parsingItem = NO;
    }
    
    if (parsingItem == YES) {
        if ([elementName isEqualToString:@"title"]) {
            post.title = currentValue;
        } else if ([elementName isEqualToString:@"link"]) {
            post.link = currentValue;
        } else if ([elementName isEqualToString:@"updated"]) {
            //post.updated = ;
        } else if ([elementName isEqualToString:@"id"]) {
            post.wid = currentValue;
        } else if ([elementName isEqualToString:@"content"]) {
            post.content = currentValue;
        }
    }
    
    currentValue = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSString *tmpValue = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (currentValue == nil) {
        currentValue = [[NSMutableString alloc] initWithString:tmpValue];
    } else {
        [currentValue appendString:tmpValue];
    }
}

#pragma mark - UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"master";
    self.navigationPopoverController = pc;
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationPopoverController = nil;
    self.navigationItem.leftBarButtonItem = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.entries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"reuse";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [[self.entries objectAtIndex:indexPath.row] title];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleViewController *controller = [[ArticleViewController alloc] init];
    controller.contentString = [[self.entries objectAtIndex:indexPath.row] content];
    [self.navigationController pushViewController:controller animated:YES];
}

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
