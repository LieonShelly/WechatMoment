# WechatMoment
### 运行环境
- swift 4.2
- xcode 10.1

### 运行项目需注意
 - 首次运行时，可能会由于网络许可的问题，一直处于加载中，APP做了数据监测处理的，如果没得数据会每隔1秒请求一次，遇到这种一直的加载的情况，可以杀死APP再进入，也可以在设置中打开网络许可，APP会自动加载数据
 - App中第三方库的管理采用的是carthage，代码克隆下来后打开Cartfile中的注释的库，执行carthage update --platform iOS
 - App中对数据进行了筛选，返回数据中包含 error， unknown error 字段，同时没有文字和图片的数据都被滤除了
 
### 项目GitHub地址
	https://github.com/LieonShelly/WechatMoment.git
 

