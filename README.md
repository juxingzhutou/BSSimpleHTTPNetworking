# BSSimpleHTTPNetworking

本项目是一个建立在[AFNetworking](https://github.com/AFNetworking/AFNetworking)基础上的RPC形式封装模板。库本身仅提供了几种典型的HTTP请求的封装，Demo中有具体如何在其上封装与具体接口对应的方法的示例。

这个库的目的就是用最简单直接的方式在AFNetworking上进行封装，以实现离散型的网络接口设计，提高网络请求相关代码的质量。

HTTP接口的包装见文件`BSHTTPAPI.h`和`BSHTTPAPI.m`，示例如下：

```
- (void)getBaiDuIndexPageOnSuccess:(BSOnHTTPRequestSuccess)onSuccess
                         onFailure:(BSOnHTTPRequestFailure)onFailure {
    [[BSNetworking sharedInstance] httpGetWithAbsoluteURL:@"http://www.baidu.com"
                                                   params:nil
                                                onSuccess:onSuccess
                                                onFailure:onFailure];
}
```

具体HTTP接口的本地Stub实现中调用了`BSNetworking`中封装的HTTP方法用于实际的网络请求。**在使用时只需要为每个HTTP接口在`BSHTTPAPI`类上实现一个对应的实例方法即可。**

目前`BSNetworking`已支持的请求方法有：

1. HTTP Get请求
2. 普通HTTP Post请求
3. Multipart HTTP Post请求

Multipart请求的实现可以参考Demo中的又拍云上传接口的实现以及`BSNetworking`中的注释。