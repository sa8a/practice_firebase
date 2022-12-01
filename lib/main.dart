import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: double.infinity,
                  alignment: Alignment.topCenter,

                  // StreamBuilderにStreamの型としてQuerySnapshotを明示
                  child: StreamBuilder<QuerySnapshot>(
                    // streamの設定部分で、前述したデータの取得処理を記載
                    // Cloud FirestoreからStreamでデータを取得
                    // FirebaseFirestore.instanceでCloud Firestoreのデータベースのインスタンスを取得します。
                    // collection(~)でコレクションを選択
                    // orderBy(~)でフィールドの値にて並べ替え
                    // 最後にsnapshots()でStreamにてデータの取得を行う
                    stream: FirebaseFirestore.instance
                        .collection('dream')
                        .orderBy('createdAt')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('エラーが発生しました');
                      }
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final list = snapshot.requireData.docs
                          .map<String>((DocumentSnapshot document) {
                        final documentData =
                            document.data()! as Map<String, dynamic>;
                        return documentData['content']! as String;
                      }).toList();

                      final reverseList = list.reversed.toList();

                      return ListView.builder(
                        itemCount: reverseList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: Text(
                              reverseList[index],
                              style: const TextStyle(fontSize: 20),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // 保存するデータの定義（Map型のデータにて保存）
                      // createdAtはDateTime型をTimeStamp型に変換するため、
                      // このような処理を行っています。
                      final document = <String, dynamic>{
                        'content': _controller.text,
                        'createdAt': Timestamp.fromDate(DateTime.now()),
                      };

                      // Cloud Firestoreへのデータ保存
                      // collection : Firebaseで設定したコレクション名
                      // doc : 空欄にするとdocument IDを自動で設定
                      FirebaseFirestore.instance
                          .collection('dream')
                          .doc()
                          .set(document);

                      // 送信したらフォームをクリアする
                      setState(_controller.clear);
                    },
                    child: const Text('送信'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
