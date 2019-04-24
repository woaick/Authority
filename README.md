# AuthorityDemo
Train Authority Demo

##warning  只可以真机测试，只有arm64架构

# 集成SDK步骤

1 git clone https://github.com/latitech/AuthorityDemo.git 以后，目录中含有sdk文件夹，把该文件夹拖入你的项目根目录中


2 选择项目设置-> General -> Embedded Binaries，把sdk目录下所有的 framework 文件导入


3 在项目目录中导入 sdk 目录下 Resource 文件夹


4 在项目目录中导入 sdk 目录下 App.framework 目录下 flutter_assets 文件夹，请注意，不要勾选 Copy items if needed，选择 Create folder references

5 在项目Info.plist中，添加以下权限
Privacy - Camera Usage Description      相机使用
Privacy - Microphone Usage Description  麦克风使用
Privacy - Photo Library Additions Usage Description 添加图片到相册
Privacy - Photo Library Usage Description   使用相册中的图片


# 如何使用

1 创建一个视图控制器（ViewController）继承与 FlutterViewController


2 在另一个ViewController 中添加如下代码

导入头文件    
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>
#import <Flutter/Flutter.h>

3 利用UINavigationController push 到继承 FlutterViewController 的 ViewController

例：SecondViewController 是继承于 FlutterViewController

SecondViewController* flutterViewController = [[SecondViewController alloc] init];
[flutterViewController setInitialRoute:params];
[GeneratedPluginRegistrant registerWithRegistry:flutterViewController];
[self.navigationController pushViewController:flutterViewController animated:NO];

其中，params 是一个 json 字符串，以下为参数列表：

roomId：xxxxxx     房间ID -> NSString
roleId：xxxx           角色ID -> NSInteger
userId：xxxxx        用户ID -> NSString
nickname：xxxx    昵称 -> NSString
avatar：xxxx         头像地址 -> NSString
password：xxx     会议密码 -> NSString，没有设置密码该参数设置为空字符串：如@""

##warning   sdk中不包含设置密码以及输入密码的界面，需要自己实现
