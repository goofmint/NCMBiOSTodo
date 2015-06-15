# NCMBiOS_Todo

NCMBのデータストアを使用した簡単なTodoアプリです。認証は行っていません。

- Todoの一覧
- Todoの登録と編集、削除
    - Todoとして登録できるものはタイトルのみ


動作確認は次の環境で行っています。

- OS X Yosemite 10.10.3 (14D136)
- Xcode Version 6.3.2 (6D2105)
- ruby 2.1.5p273 (2014-11-13 revision 48405) [x86_64-darwin14.0]
- cocoapods 0.37.2


以下の説明は、CocoaPodsの利用の仕方やブリッジヘッダーの設定の仕方を含め、[クイックスタート](http://mb.cloud.nifty.com/doc/quickstart_ios.html)の内容をご理解いただいているものとします。

Podfileは次のように設定してください。現在のところ、 `use_frameworks!` オプションは利用できませんので注意してください。ニフティさんにissueをあげていますので、興味がある方は[こちら](動作環境は次の内容を想定しています。)をごらんください。

Podfile

```
platform :ios, '8.3'

inhibit_all_warnings!

# # 2015/06/06時点では、このオプションを指定するとビルドエラーが発生します。
# use_frameworks!

pod 'NCMB', :git => 'https://github.com/NIFTYCloud-mbaas/ncmb_ios.git'
```

## サンプルアプリケーション概要

- アプリケーションを起動すると、Todo一覧が表示されます。
- ナビゲーションバーの `+` をタップすると、Todoを編集する画面が表示されます。
- Todo一覧で、項目を右にスライドすると、 `編集` と `削除` が選択できます。

なお、このアプリでは、 `NCMBSubclassing` を使用していません。

## ライセンス

The MIT License (MIT)

Copyright (c) 2015 Naoki Tsutsui

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
