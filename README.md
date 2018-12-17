# MWSSketchpadView
封装题库类app的草稿纸功能：

`单指`画线演算，`双指`上下左右拖动草稿纸；

`撤销`/`反撤销`/`清空`等功能；

根据题号`id`缓存各个题目的草稿内容。

---
### 导入项目
`pod 'MWSSketchpadView'`

---
### 使用
`#import "MWSSketchpadView.h"`

`[[MWSSketchpadView shareInstance] showWithID:234];`

**配置横向距离**

```
//默认是3页，一页代表屏幕的宽度
[MWSSketchpadView shareInstance].horizontalPage = 5;
```

**配置纵向距离**

```
//默认是3页，一页代表屏幕的宽度
[MWSSketchpadView shareInstance].verticalPage = 5;
```
