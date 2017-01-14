使用方法

make

//シミュレーター本体


ー通常モード
./sim prog.bin
最後まで実行し、実行命令数とレジスタの状態を出力
統計情報analysis.txtを出力する new


ー逆アセンブラモード
./sim prog.bin dass
機械語で書かれたprog.binを逆アセンブル。dass.txtを出す



ーステップモード
./sim prog.bin step

何も打たずEnter：ステップ実行
・実行した行と命令
・レジスタの状態
を出力する

bを入力しEnter：次のブレークポイントまで実行
・ブレークポイントの行
・レジスタの状態
を出力する。
ブレークポイントがその先に無い場合は、プログラムの最後に実行された命令とレジスタの最終状態を表示する。


ステップモードにおけるメモリ表示機能　New

・m 好きな数字
指定した番地の値を表示

・m 好きな数字1 好きな数字2
好きな数字1～好きな数字2の番地の値を表示


メモリトレース機能(現在は初期状態OFF、regdefのdefineを書き換えれば使える)
ms:メモリトレース開始(⇔今までのメモリ書き込み履歴を消去)
mt:書き込まれたメモリの値を表示する



コマンド一覧
\n :step
b  :break
m ~:メモリ表示
m ~ ~:メモリ表示
ms :メモリ書き込み履歴リセット
mt :書き込まれたメモリ表示




ーアナライズモード
./sim prog.bin g (fpuのflag)
対応したバイナリを入れるとアナライズされる



//fsim

in.txtとans.txtに

r0 0
#
r1 2
f0 4.0
#

のように書いておけばin.txtから入力を読んで、ans.txtに書いた内容と答え合わせをしてくれる

./fsim prog.bin
で起動

./fsim prog.bin p
としておくと、間違えた場合にレジスタの内容を全部書き出す



・フラグ指定←New!
FPUのシミュレータ実装とx86実装の切り替え機能

./sim prog.bin (数字)  → flag = 数字
./sim prog.bin step (数字) → flag = 数字

数字なしならば、flag = 0
flagの各bitが立っている
→シミュレータ実装に対応

早見表
flag  finv  fmul  fadd
0      x86   x86   x86
1      x86   x86   sim
2      x86   sim   x86
3      x86   sim   sim
4      sim   x86   x86
5      sim   x86   sim
6      sim   sim   x86
7      sim   sim   sim


・fsim←New!

./fsim prog.bin (p)
in.txtの内容をレジスタに入れて、実行し、結果がans.txtに等しいかチェックする

in.txtとans.txtは

r0 5
f0 2
#
r0 3
f0 1
#

のように書く(#は一回一回の区切り文字。最後にも必要)

オプションにpをつけると、間違ったときにレジスタの全内容を書き出してくれる


/*

//GUIシミュレーター←Old!

-------ビルド方法-------
１.Qt5.3.2をインストールする
http://qt-users.jp/download.html

2.GUIのフォルダにあるものを適当な場所に移してから、
qmake
make
実行ファイルが出来る。


まず扱いたい機械語バイナリをOpenする。
タブでモードを選んでいろいろ

①通常実行モード
simulateを押せば、レジスタの最終状態が出る

②逆アセンブラモード
Save先を選択してから、そこに書き出す。

③ステップ実行モード
Initializeで初期化してから、Stepしたりbreak pointまで飛んだり出来る。

*/
