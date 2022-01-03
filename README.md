## UIKit: Combineを用いたMVVMのSample

SwiftでMVVMを実現する場合、
今まではRxSwiftの利用が一般的でしたが、
Combineでも実現できるようになりました。

## 開発環境

macOS: Monterey 12.0.1 M1
Xcode: 13.1
iOS 15以上対象

## アプリ内容

- Github Repositoryを表示するiOSアプリ
- Storyboard利用
- Library未使用
- bindingにCombineを利用
- APIClientではasync awaitを利用

<img width=320px src="https://i.imgur.com/KkV7hIH.png">
