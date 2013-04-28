//
//  ViewController.m
//  TableViewIndex
//
//  Created by Dean on 13-4-28.
//  Copyright (c) 2013年 Dean. All rights reserved.
//

#import "ViewController.h"
#import "DemoItemView.h"
#import "DSectionIndexView.h"
#import <QuartzCore/QuartzCore.h>

#define RANDOM_SEED() srandom(time(NULL))
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + random() % ((__MAX__+1) - (__MIN__)))

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,DSectionIndexViewDataSource,DSectionIndexViewDelegate>
@property (__d_weak, nonatomic) IBOutlet UITableView *tableview;
@property (retain, nonatomic) DSectionIndexView *sectionIndexView;
@property (retain, nonatomic) NSMutableArray *sections;
@property (retain, nonatomic) NSMutableDictionary *sectionDic;
@end

@implementation ViewController

- (void)dealloc
{
#ifdef IS_ARC
#else
    RELEASE_SAFELY(_sections);
    RELEASE_SAFELY(_sectionIndexView);
    RELEASE_SAFELY(_tableview);
    [super dealloc];
#endif
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _sectionIndexView = [[DSectionIndexView alloc] init];
        _sectionIndexView.backgroundColor = [UIColor clearColor];
        _sectionIndexView.dataSource = self;
        _sectionIndexView.delegate = self;
        _sectionIndexView.isShowCallout = YES;
        _sectionIndexView.calloutViewType = CalloutViewTypeForUserDefined;
        _sectionIndexView.calloutDirection = SectionIndexCalloutDirectionLeft;
        _sectionIndexView.calloutMargin = 100.f;
        [self.view addSubview:self.sectionIndexView];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self createData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.sectionIndexView reloadItemViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#define kSectionIndexWidth 40.f
#define kSectionIndexHeight 360.f
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _sectionIndexView.frame = CGRectMake(CGRectGetWidth(self.tableview.frame) - kSectionIndexWidth, (CGRectGetHeight(self.tableview.frame) - kSectionIndexHeight)/2, kSectionIndexWidth, kSectionIndexHeight);
    [_sectionIndexView setBackgroundViewFrame];
}

#pragma mark UITableViewDataSource && delegate method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.sectionDic objectForKey:[self.sections objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sections objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"IdentifierCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
#ifdef IS_ARC
#else
        [cell autorelease];
#endif
    }
    
//    int randomIndex = [self getIndexByRandomRates:[NSArray arrayWithObjects:@152,@3,@98,@188,@250,@365,@798,@45,@32,@15789,@0471,@501,@38,@46,nil ]];
//    cell.textLabel.text = [NSString stringWithFormat:@"%d",randomIndex];
    cell.textLabel.text = [[self.sectionDic objectForKey:[self.sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (int)getIndexByRandomRates:(NSArray *)rates
{
    RANDOM_SEED();
    int maxValue = 0;
    for (NSNumber *rate in rates) {
        maxValue = maxValue + [rate intValue];
    }
    if(maxValue < 1){
        maxValue = 1;
    }
    int rateValue = RANDOM_INT(1, maxValue);
    int startValue = 0;
    int endValue = 0;
    int resultIndex = -1;
    for (NSNumber *rate in rates) {
        resultIndex = resultIndex + 1;
        if([rate intValue] == 0){
            // skip when rate is 0
            continue;
        }
        endValue = startValue + [rate intValue];
        if (rateValue > startValue && rateValue) {
            //this is the generated chip;
            return resultIndex;
        }
        startValue = endValue;
    }
    return resultIndex;
}


#pragma mark DSectionIndexViewDataSource && delegate method
- (NSInteger)numberOfItemViewForSectionIndexView:(DSectionIndexView *)sectionIndexView
{
    return self.tableview.numberOfSections;
}

- (DSectionIndexItemView *)sectionIndexView:(DSectionIndexView *)sectionIndexView itemViewForSection:(NSInteger)section
{
    DSectionIndexItemView *itemView = [[DSectionIndexItemView alloc] init];
    
    itemView.titleLabel.text = [self.sections objectAtIndex:section];
    itemView.titleLabel.font = [UIFont systemFontOfSize:12];
    itemView.titleLabel.textColor = [UIColor darkGrayColor];
    itemView.titleLabel.highlightedTextColor = [UIColor redColor];
    itemView.titleLabel.shadowColor = [UIColor whiteColor];
    itemView.titleLabel.shadowOffset = CGSizeMake(0, 1);
    
#ifdef IS_ARC
#else
    [itemView autorelease];
#endif
    
    return itemView;

}

- (UIView *)sectionIndexView:(DSectionIndexView *)sectionIndexView calloutViewForSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    
    label.frame = CGRectMake(0, 0, 80, 80);     
    
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor redColor];
    label.font = [UIFont boldSystemFontOfSize:36];
    label.text = [self.sections objectAtIndex:section];
    label.textAlignment = UITextAlignmentCenter;
    
    [label.layer setCornerRadius:label.frame.size.width/2];
    [label.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [label.layer setBorderWidth:3.0f];
    [label.layer setShadowColor:[UIColor blackColor].CGColor];
    [label.layer setShadowOpacity:0.8];
    [label.layer setShadowRadius:5.0];
    [label.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
#ifdef IS_ARC
#else
    [label autorelease];
#endif
    
    return label;
}

- (NSString *)sectionIndexView:(DSectionIndexView *)sectionIndexView
               titleForSection:(NSInteger)section
{
    return [self.sections objectAtIndex:section];
}

- (void)sectionIndexView:(DSectionIndexView *)sectionIndexView didSelectSection:(NSInteger)section
{
    [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableview:nil];
    [self setSections:nil];
    [self setSectionIndexView:nil];
    [super viewDidUnload];
}

- (void)createData
{
    self.sectionDic = [NSMutableDictionary dictionary];
    NSArray *array1 = [NSArray arrayWithObjects:@"apparel",@"apparentness",@"appel",@"appeasement",@"appearance",@"appear",@"appellant",@"apostate",@"appellation",@"aposteriori",@"apospory ", nil];
    NSArray *array2 = [NSArray arrayWithObjects:@"byron",@"SB",nil];
    NSArray *array3 = [NSArray arrayWithObjects:@"cabbage",@"cable",@"cafe", nil];
    NSArray *array4 = [NSArray arrayWithObjects:@"dean",nil];
    NSArray *array5 = [NSArray arrayWithObjects:@"finsh",@"five",@"fine",@"fix", nil];
    NSArray *array6 = [NSArray arrayWithObjects:@"english",@"egg", nil];
    NSArray *array7 = [NSArray arrayWithObjects:@"great",@"gate",@"gif",@"github", nil];
    NSArray *array8 = [NSArray arrayWithObjects:@"hello",@"hungry",@"home",@"house",@"however",@"humble", nil];
    NSArray *array9 = [NSArray arrayWithObjects:@"idea",@"implemention",@"insistt",@"invite", nil];
    NSArray *array10 = [NSArray arrayWithObjects:@"Jack",@"job",@"just", nil];
    NSArray *array11 = [NSArray arrayWithObjects:@"kill",@"king", nil];
    NSArray *array12 = [NSArray arrayWithObjects:@"lucky",@"limit", nil];
    NSArray *array13 = [NSArray arrayWithObjects:@"money",@"much",@"many",@"man",@"million",@"meter",@"may",@"miracle",@"manage",nil];
    NSArray *array14 = [NSArray arrayWithObjects:@"nice",@"nick",@"navigate", nil];
    NSArray *array15 = [NSArray arrayWithObjects:@"ok",@"over",nil];
    NSArray *array16 = [NSArray arrayWithObjects:@"pik",@"pice",@"pizze",nil];
    NSArray *array17 = [NSArray arrayWithObjects:@"quite", nil];
    NSArray *array18 = [NSArray arrayWithObjects:@"request",@"rice",nil];
    NSArray *array19 = [NSArray arrayWithObjects:@"sister",@"sex",@"slider", nil];
    NSArray *array20 = [NSArray arrayWithObjects:@"tool",@"tumb",@"taxi",@"take", nil];
    NSArray *array21 = [NSArray arrayWithObjects:@"unity",@"unless",nil];
    NSArray *array22 = [NSArray arrayWithObjects:@"video",@"vs", nil];
    NSArray *array23 = [NSArray arrayWithObjects:@"world",@"work", nil];
    NSArray *array24 = [NSArray arrayWithObjects:@"XXOO", nil];
    NSArray *array25 = [NSArray arrayWithObjects:@"yellow",@"yet",@"yes",@"yard", nil];
    NSArray *array26 = [NSArray arrayWithObjects:@"zero",@"zike",@"zoom", nil];
    NSArray *array27 = [NSArray arrayWithObjects:@"13579",@"&&&&",@"38",@"250",@"349321810@qq.com",@"码农", nil];
    
    [self.sectionDic setObject:array1 forKey:@"A"];
    [self.sectionDic setObject:array2 forKey:@"B"];
    [self.sectionDic setObject:array3 forKey:@"C"];
    [self.sectionDic setObject:array4 forKey:@"D"];
    [self.sectionDic setObject:array5 forKey:@"E"];
    [self.sectionDic setObject:array6 forKey:@"F"];
    [self.sectionDic setObject:array7 forKey:@"G"];
    [self.sectionDic setObject:array8 forKey:@"H"];
    [self.sectionDic setObject:array9 forKey:@"I"];
    [self.sectionDic setObject:array10 forKey:@"J"];
    [self.sectionDic setObject:array11 forKey:@"K"];
    [self.sectionDic setObject:array12 forKey:@"L"];
    [self.sectionDic setObject:array13 forKey:@"M"];
    [self.sectionDic setObject:array14 forKey:@"N"];
    [self.sectionDic setObject:array15 forKey:@"O"];
    [self.sectionDic setObject:array16 forKey:@"P"];
    [self.sectionDic setObject:array17 forKey:@"Q"];
    [self.sectionDic setObject:array18 forKey:@"R"];
    [self.sectionDic setObject:array19 forKey:@"S"];
    [self.sectionDic setObject:array20 forKey:@"T"];
    [self.sectionDic setObject:array21 forKey:@"U"];
    [self.sectionDic setObject:array22 forKey:@"V"];
    [self.sectionDic setObject:array23 forKey:@"W"];
    [self.sectionDic setObject:array24 forKey:@"X"];
    [self.sectionDic setObject:array25 forKey:@"Y"];
    [self.sectionDic setObject:array26 forKey:@"Z"];
    [self.sectionDic setObject:array27 forKey:@"#"];
    
    self.sections = [NSMutableArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#",nil];

}

@end
