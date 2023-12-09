
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_tutorial/ui/auth/loginscreen.dart';
import 'package:firebase_tutorial/ui/posts/add_post.dart';
import 'package:firebase_tutorial/utils/utils.dart';
import 'package:flutter/material.dart';

//firebase fetch 2 tareeqe say hota hay stream builder ya phir firebase animated list jismay hum pub.dev say dependency nikalte hay firebase database ki
class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref(
      'Post'); //idhar hum reference denge firebase console database ki because hum fetch krenge us data ko taakey frontend per show kre or jo bracket mn post lika hay ye wahi likhna hay jo firebase mn jis node ka naam hay wrna error ayega
  final searchFilter = TextEditingController();
  final editController= TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Post screen")),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              icon: Icon(Icons.logout)),
          SizedBox(
            width: 13,
          ),
        ],
      ),
      body: Column(children: [
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextFormField(
            controller: searchFilter,
            decoration: InputDecoration(
                hintText: 'Search', border: OutlineInputBorder()),
            onChanged: (String value) {
              setState(() {});
            },
          ),
        ),
        Expanded(
          child: FirebaseAnimatedList(
              defaultChild: Text("Loadingggggg"),
              query:
                  ref, //humnay jo opper reference di hay wahi query mn dede keu kay opper reference post ki hay or post node hay jab woh firebase mn jayega toh node apney sarey child ko fetch krdega
              itemBuilder: (context, snapshot, animation, index) {
                final title = snapshot.child('title').value.toString();

                if (searchFilter.text.isEmpty) {
                  return ListTile(
                    title: Text(snapshot
                        .child('title')
                        .value
                        .toString()), //firebase say fetch kra humnay title and id dono ko aise
                    subtitle: Text(snapshot.child('id').value.toString()),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: (){
                              Navigator.pop(context);
                              showMyDialog(title,snapshot.child('id').value.toString());
                            },
                            leading: Icon(Icons.edit),
                            title: Text("Edit"),
                          ),
                        ),
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: (){
                              Navigator.pop(context);
                              ref.child(snapshot.child('id').value.toString()).remove();
                            },
                            leading: Icon(Icons.delete),
                            title: Text("Delete"),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (title
                    .toLowerCase()
                    .contains(searchFilter.text.toLowerCase().toLowerCase())) {
                  return ListTile(
                    title: Text(snapshot
                        .child('title')
                        .value
                        .toString()), //firebase say fetch kra humnay title and id dono ko aise
                    subtitle: Text(snapshot.child('id').value.toString()),
                  );
                } else {
                  return Container();
                }
              }),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPostScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
Future<void> showMyDialog(String title,String id)async{ editController.text=title;
    return showDialog(
          context: context,
          builder: (BuildContext context){
        return AlertDialog(
          title:  Text('Update'),
          content: Container(
            child: TextField(
              controller: editController,
              decoration: InputDecoration(hintText: "Edit here!"),

            ),
          ),
       actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Cancel")),
        TextButton(onPressed: (){
          Navigator.pop(context);
          ref.child(id).update({
            'title' : editController.text.toLowerCase()
          }).then((value){
Utils().toastMessage('Post Updated');
          }).onError((error, stackTrace){
    Utils().toastMessage(error.toString());
          });
        }, child: Text("Update"))
       ],
        );
          }
    );
  }

}

// Expanded(child: StreamBuilder(
//   stream: ref.onValue,
//   builder: (context,AsyncSnapshot<DatabaseEvent> snapshot){
    
//     if(!snapshot.hasData){
//       return CircularProgressIndicator();
//     }else{
//       Map<dynamic , dynamic> map= snapshot.data!.snapshot.value as dynamic;
//       List<dynamic>list =[];
//       list.clear();
//       list= map.values.toList();
//   return ListView.builder(
//     itemCount: snapshot.data!.snapshot.children.length,
//     itemBuilder: (context,index){
//     return ListTile(
//       title: Text(list[index]['title']),
//       subtitle: Text(list[index]['id']),
//     );
//   }
  
//   );}
// },)),
