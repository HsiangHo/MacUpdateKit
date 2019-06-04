//
//  MacUpdateManager.m
//  MacUpdateKit
//
//  Created by Jovi on 6/3/19.
//  Copyright © 2019 Jovi. All rights reserved.
//

#import "MacUpdateManager.h"
#import "MacUpdateAppInfoObject.h"
#import "MacUpdateWindowController.h"

static MacUpdateManager *instance;
@implementation MacUpdateManager{
    void (^_checkUpdateCompletionBlock)(BOOL rslt, MacUpdateAppInfoObject *AppObj);
    void (^_requestAppUpdateWindowCompletionBlock)(AppUpdateWindowResult rslt, MacUpdateAppInfoObject *AppObj);
    void (^_downloadCompleteBlock)(BOOL rslt,  NSString *installerPath, MacUpdateAppInfoObject *AppObj);
    MacUpdateUIConfiguration        *_configure;
    MacUpdateAppInfoObject          *_appObj;
    NSString                        *_check4UpdateURL;
    NSString                        *_downloadedFilePath;
    NSString                        *_cachPath;
    NSURLResponse                   *_downloadResponse;
    NSURLDownload                   *_theDownload;
    BOOL                            _bDownloaded;
}

+(instancetype)sharedManager{
    @synchronized (self) {
        if (nil == instance) {
            instance = [[MacUpdateManager alloc] init];
        }
        return instance;
    }
}

-(void)customize:(MacUpdateUIConfiguration *)configure withCheck4UpdatesURL:(NSString *)check4UpdateURL{
    _configure = configure;
    _check4UpdateURL = check4UpdateURL;
}

-(instancetype)init{
    if (self = [super init]) {
        _checkUpdateCompletionBlock = NULL;
        _requestAppUpdateWindowCompletionBlock = NULL;
    }
    return self;
}

-(BOOL)checkAppUpdate:(MacUpdateAppInfoObject *)appObj{
    BOOL bRslt = NO;
    if (nil == [appObj productID]) {
        return bRslt;
    }
    if ([appObj isNewVersionAvailable]) {
        return YES;
    }
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?pid=%@", _check4UpdateURL, [appObj productID]]]] returningResponse:nil error:nil];
    if (nil == response) {
        return bRslt;
    }
    NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    if (nil != error) {
        return bRslt;
    }
    
    [appObj setLatestVersion:[appInfoDic valueForKey:@"ver"]];
    [appObj setDownloadURL:[appInfoDic valueForKey:@"durl"]];
    [appObj setReleaseNotes:[appInfoDic valueForKey:@"notes"]];
    [appObj setForceUpdateFlag:[[appInfoDic valueForKey:@"fuflag"] boolValue]];
    
    bRslt = YES;
    return bRslt;
}

-(void)checkAppUpdateAsync:(MacUpdateAppInfoObject *)appObj withCompletionBlock:(void (^)(BOOL rslt, MacUpdateAppInfoObject *AppObj))block{
    _checkUpdateCompletionBlock = block;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL bRslt = [self checkAppUpdate: appObj];
        if (NULL != self->_checkUpdateCompletionBlock) {
            self->_checkUpdateCompletionBlock(bRslt, appObj);
        }
    });
}

-(BOOL)requestAppUpdateWindow:(MacUpdateAppInfoObject *)appObj withCompletionCallback:(void (^)(AppUpdateWindowResult rslt, MacUpdateAppInfoObject *AppObj))block{
    _requestAppUpdateWindowCompletionBlock = block;
    static MacUpdateWindowController *appStoreUpdateWindowCotroller = nil;
    if (nil != appStoreUpdateWindowCotroller) {
        [appStoreUpdateWindowCotroller setDelegate:nil];
        [appStoreUpdateWindowCotroller close];
    }
    appStoreUpdateWindowCotroller = [[MacUpdateWindowController alloc] initWithAppObject:appObj withCustomizeConfigure:_configure];
    [appStoreUpdateWindowCotroller setDelegate:(id<MacUpdateWindowControllerDelegate> _Nullable)self];
    [NSApp activateIgnoringOtherApps:YES];
    [appStoreUpdateWindowCotroller.window makeKeyAndOrderFront:nil];
    return YES;
}

-(void)skipCurrentNewVersion:(MacUpdateAppInfoObject *)appObj{
    if (nil == [appObj latestVersion] || nil == [appObj productID]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setValue:[appObj latestVersion] forKey:[appObj productID]];
}

-(BOOL)isCurrentNewVersionSkipped:(MacUpdateAppInfoObject *)appObj{
    BOOL bRslt = NO;
    if (nil == [appObj latestVersion] || nil == [appObj productID]) {
        return bRslt;
    }
    NSString *skippedVersion = [[NSUserDefaults standardUserDefaults] valueForKey:[appObj productID]];
    if(nil == skippedVersion || [skippedVersion isEqualToString:@""]){
        return bRslt;
    }
    NSComparisonResult comparisonResult = [skippedVersion compare:[appObj latestVersion] options:NSNumericSearch];
    if (NSOrderedAscending != comparisonResult) {
        bRslt = YES;
    }
    return bRslt;
}

-(void)downloadUpdatesInBackground:(MacUpdateAppInfoObject *)appObj withCachePath:(NSString *)cachPath withDownloadCompleteBlock:(void (^)(BOOL rslt,  NSString *installerPath, MacUpdateAppInfoObject *AppObj))downloadCompleteBlock;{
    if (![appObj isNewVersionAvailable] || nil == [appObj downloadURL] || [[appObj downloadURL] isEqualToString:@""]) {
        return;
    }
    _cachPath = cachPath;
    if (nil == _cachPath || [_cachPath isEqualToString:@""]) {
        _cachPath = @"/tmp";
    }
    _appObj = appObj;
    _downloadCompleteBlock = downloadCompleteBlock;
    NSURL *URL = [NSURL URLWithString:[appObj downloadURL]];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:6000.0];
    _theDownload = [[NSURLDownload alloc] initWithRequest:theRequest delegate:self];
}

#pragma mark - delegate
-(void)skipButtonClick:(MacUpdateWindowController *)sender{
    if(NULL != _requestAppUpdateWindowCompletionBlock){
        _requestAppUpdateWindowCompletionBlock(AppUpdateWindowResultSkip, [sender appObj]);
    }
}

-(void)updateButtonClick:(MacUpdateWindowController *)sender{
    if(NULL != _requestAppUpdateWindowCompletionBlock){
        _requestAppUpdateWindowCompletionBlock(AppUpdateWindowResultUpdate, [sender appObj]);
    }
}

-(void)laterButtonClick:(MacUpdateWindowController *)sender{
    if(NULL != _requestAppUpdateWindowCompletionBlock){
        _requestAppUpdateWindowCompletionBlock(AppUpdateWindowResultLater, [sender appObj]);
    }
}

- (void)download:(NSURLDownload *)download decideDestinationWithSuggestedFilename:(NSString *)filename{
    if (_theDownload == download) {
        _downloadedFilePath = [NSString stringWithFormat:@"%@/%@", _cachPath, filename];
        if ([[NSFileManager defaultManager] fileExistsAtPath:_downloadedFilePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:_downloadedFilePath error:nil];
        }
        _bDownloaded = NO;
        [download setDestination:_downloadedFilePath allowOverwrite:NO];
    }
}

- (void)downloadDidFinish:(NSURLDownload *)download{
    if (_theDownload == download) {
        _bDownloaded = YES;
        if (NULL != _downloadCompleteBlock) {
            _downloadCompleteBlock(_bDownloaded, _downloadedFilePath, _appObj);
        }
    }
}

- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error{
    if (_theDownload == download) {
        _bDownloaded = NO;
        if (NULL != _downloadCompleteBlock) {
            _downloadCompleteBlock(_bDownloaded, _downloadedFilePath, _appObj);
        }
    }
}

- (void)download:(NSURLDownload *)download didReceiveResponse:(NSURLResponse *)response{
    if (_theDownload == download) {
        _downloadResponse = response;
    }
}

@end
