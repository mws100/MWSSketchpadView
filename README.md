# MWSSketchpadView
封装题库类app的草稿纸功能：

- `单指`画线演算，`双指`上下左右拖动草稿纸；

- `撤销`/`反撤销`/`清空`功能；

- 根据题号`id`缓存各个题目的草稿内容，持久化到本地;

---
### 导入项目
`pod 'MWSSketchpadView'`

---
### 使用
```
#import "MWSSketchpadView.h"

self.sketchpadView = [MWSSketchpadView shareInstance];
//配置横向距离,一页代表屏幕的宽度，默认3页
self.sketchpadView.horizontalPage = 5;
//配置纵向距离,一页代表屏幕的高度，默认3页
self.sketchpadView.verticalPage = 5;
//弹出显示
[self.sketchpadView showWithID:123];

```

