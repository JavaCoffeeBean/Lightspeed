// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightspeed_voice_task/data/user_repository.dart';
import 'package:lightspeed_voice_task/main.dart';
import 'package:lightspeed_voice_task/ui_widgets/checkbox.dart';
import 'package:lightspeed_voice_task/ui_widgets/dropdown.dart';
import 'package:lightspeed_voice_task/user_bloc/users_bloc.dart';

class TodosPage extends StatefulWidget {
  final String nameOfUser;
  final int idOfUser;

  const TodosPage ({Key key, this.nameOfUser, this.idOfUser}) : super(key: key);

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  String selectedValue = "ID";


  @override
  Widget build(BuildContext context) {
    String nameUser = widget.nameOfUser;

    final userBloc = context.bloc<UsersBloc>();
    userBloc.add(GetTodos(widget.idOfUser));

    return Scaffold(
      backgroundColor: const Color(0xFF062F06), //FF062F06
      body: Center(
        child: BlocConsumer<UsersBloc, UsersState>(
          listener: (context, state) {
            if (state is UsersError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is UsersInitial) {
              return Container(color: Colors.grey,);
            } else if (state is Loading) {
              return CircularProgressIndicator();
            } else if (state is TodosLoaded) {
              return todosPageLoaded(state.todosFuture,widget.nameOfUser);
            } else {
              return Container(height: 150,padding: const EdgeInsets.all(20),decoration: const BoxDecoration(color: Color(
                  0xFF157815),borderRadius: BorderRadius.all(Radius.circular(20))),child: Column(
                children: [
                  Text('There was a problem fetching the data. Is your device online?',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200),),
                  Icon(Icons.error_outline,color: Color(0xFF920000),),
                  ElevatedButton(onPressed: (){
                    userBloc.add(GetTodos(widget.idOfUser));
                    print("added event in todo");
                  }, child: Text("Reload",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200)))
                ],
              ),);
            }
          },
        ),
      ),
    );





  }



  Widget todosPageLoaded(Future todoFuture, String nameOfTheUser) {

    return Container(margin: const EdgeInsets.all(20),padding: const EdgeInsets.all(10),alignment: Alignment.center,decoration: const BoxDecoration(color: Color(
        0xFF0A4C0A),borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Center(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(mainAxisSize: MainAxisSize.max,
              children: [
                Row(mainAxisSize: MainAxisSize.min,
                  children:  [
                    Text(nameOfTheUser + "'s\nTodos",overflow: TextOverflow.clip,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200,fontSize: 20,letterSpacing: 1.5,),textAlign: TextAlign.center,),
                  ],
                ),
                const Divider(color: Color(0xFF157815),),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BlocProvider(
                      create: (context) => UsersBloc(UserRepository()),
                      child: UsersPage(),
                    ) ));
                  }, child: Text("Back",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w200))),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10,left: 7),
                  child: Align(alignment:Alignment.centerLeft,
                      child: Text("Sort By",style: TextStyle(color:Colors.white,fontSize: 10,fontWeight: FontWeight.w200),textAlign: TextAlign.start,)),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 100,
                      height: 50,
                      child: Dropdown()
                  ),
                ),
                FutureBuilder(
                    future: todoFuture,
                    builder: (context, snapshot) {


                      while(snapshot.data == null) {
                        print("response data is still null");
                        return CircularProgressIndicator();
                      }
                      return ListView.builder(shrinkWrap: true,scrollDirection: Axis.vertical,physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, i) {
                            return ListView(shrinkWrap: true,scrollDirection: Axis.vertical,physics: NeverScrollableScrollPhysics(),
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          CheckboxWidget(title: snapshot.data[i].title,)
                                        ],
                                      ),
                                      Divider(color: Colors.green.withOpacity(.5),)
                                    ],
                                  )
                                ]
                            );
                          }
                      );

                    }
                )
              ],
            ),
          ),
        ),
      ),

    );
  }




}



