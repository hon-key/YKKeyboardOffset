# YKKeyboardOffset
一行代码解决 UITableView 弹出键盘上移的逻辑

当我们弹出键盘的时候，经常会挡住视图底部的某些控件，就算你为视图设置了滚动隐藏或者点击隐藏，操作起来仍然稍显麻烦。

这样的情况通常发生在UITableview上

你可以通过 KVO 的方式为一个 tableView 添加回调控制 Tableview 的高度来解决这个问题，但是这样通常很麻烦，且改变 TableView 的 frame 或者 constraint 很容易发生一些不可预知的问题。

该方法通过改变 UITableView 的 contentOffset 的方式来解决，不单不会出现问题，还可以一句代码解决问题

你只需要：
```objc
yourTableView.yk_fitKeyboardShowing = YES
```

当你离开控制器的时候，你只需要：
```objc
yourTableView.yk_fitKeyboardShowing = NO
```
